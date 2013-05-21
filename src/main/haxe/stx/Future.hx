package stx;

import stx.ifs.Value;

import stx.Tuples.*;
using stx.Tuples;

using stx.Error;            
using stx.Prelude;
using stx.Arrays;
using stx.Options;
using stx.Anys;
using stx.Iterables;
using stx.Future;
using stx.Eithers;

/**
  An asynchronous operation that may complete in the future unless
  successfully canceled.
  <p>
  Futures can be combined and chained together to form complicated
  asynchronous control flows. Often used operations are map() and
  flatMap().
  <p>
 */
class Future<T> implements IValue<T>{
  @:isVar public var value(get_value, set_value):T;
  
  function get_value():T { 
    return this.value; 
  }
  function set_value(value:T):T {
    return this.value = value;
  }
  var _listeners: Array<T -> Void>;
  var _isSet: Bool;
  var _isCanceled: Bool;
  var _cancelers: Array<Void -> Bool>;
  var _canceled: Array<Void -> Void>;

  public function new() {
    _listeners  = [];
    value       = null;
    _isSet      = false;
    _isCanceled = false;
    _cancelers  = [];
    _canceled   = [];
  }
  public function isEmpty(){
    return _listeners.length == 0;
  }
  /** 
    Creates a "dead" future that is canceled and will never be delivered.
   */
  public static function dead<T>(): Future<T> {
    return new Future().withEffect(function(future) {
      future.cancel();
    });
  }

  /** 
    Delivers the value of the future to anyone awaiting it. If the value has
    already been delivered, this method will throw an exception.
   */
  public function deliver(t: T): Future<T> {
    return if (_isCanceled) this;
    else if (_isSet) { Prelude.error()('Future already delivered'); }
    //else if (_isSet) Prelude.error()("Future :" + this.value + " already delivered");
    else {
      value = t;
      _isSet  = true;

      for (l in _listeners) l(value);

      _listeners = [];

      this;
    }
  }

  /** 
    Installs the specified canceler on the future. Under ordinary
    circumstances, the future will not be canceled unless all cancelers
    return true. If the future is already done, this method has no effect.
    <p>
    This method does not normally need to be called. It's provided primarily
    for the implementation of future primitives.
   */
  public function allowCancelOnlyIf(f: Void -> Bool): Future<T> {
    if (!isDone()) _cancelers.push(f);

    return this;
  }

  /** 
    Installs a handler that will be called if and only if the future is
    canceled.
    <p>
    This method does not normally need to be called, since there is no
    difference between a future being canceled and a future taking an
    arbitrarily long amount of time to evaluate. It's provided primarily
    for implementation of future primitives to save resources when it's
    explicitly known the result of a future will not be used.
   */
  public function ifCanceled(f: Void -> Void): Future<T> {
    if (isCanceled()) f();
    else if (!isDone()) _canceled.push(f);

    return this;
  }

  /** 
    Attempts to cancel the future. This may succeed only if the future is
    not already delivered, and if all cancel conditions are satisfied.
    <p>
    If a future is canceled, the result will never be delivered.
   
    @return true if the future is canceled, false otherwise.
   */
  public function cancel(): Bool {
    return if (isDone()) false;   // <-- Already done, can't be canceled
    else if (isCanceled()) true;  // <-- Already canceled, nothing to do
    else {                        // <-- Ask to see if everyone's OK with canceling
      var r = true;

      for (canceller in _cancelers) r = r && canceller();

      if (r) {
        // Everyone's OK with canceling, mark state & notify:
        forceCancel();
      }

      r;
    }
  }

  /** 
    Determines if the future is "done" -- that is, delivered or canceled.
   */
  public function isDone(): Bool {
    return isDelivered() || isCanceled();
  }

  /** 
    Determines if the future is delivered.
   */
  public function isDelivered(): Bool {
    return _isSet;
  }

  /** 
    Determines if the future is canceled.
   */
  public function isCanceled(): Bool {
    return _isCanceled;
  }

  /** 
    Delivers the result of the future to the specified handler as soon as it
    is delivered.
   */
  public function deliverTo(f: T -> Void): Future<T> {
    if (isCanceled()) return this;
    else if (isDelivered()) f(value);
    else _listeners.push(f);

    return this;
  }
  /**
    Alias for deliverTo
  */
  public function foreach(f:T->Void):Future<T> {
    return deliverTo(f);
  }
  /** 
    Uses the specified function to transform the result of this future into
    a different value, returning a future of that value.
    <p>
    urlLoader.load("image.png").map(function(data) return new Image(data)).deliverTo(function(image) imageContainer.add(image));
   */
  public function map<S>(f: T -> S): Future<S> {
    var fut: Future<S> = new Future();

    deliverTo(function(t: T) { fut.deliver(f(t)); });
    ifCanceled(function() { fut.forceCancel(); });

    return fut;
  }
   /** 
    Maps the result of this future to another future, and returns a future
    of the result of that future. Useful when chaining together multiple
    asynchronous operations that must be completed sequentia
    lly.
    <p>
    <pre>
    <code>
    urlLoader.load("config.xml").flatMap(function(xml){
      return urlLoader.load(parse(xml).mediaUrl);
    }).deliverTo(function(loadedMedia){
      container.add(loadedMedia);
    });
    </code>
    </pre>
   */
  public function flatMap<B>(fn:T->Future<B>):Future<B>{
    var fut: Future<B> = new Future();
    var f = this;
    f.deliverTo(function(t: T) {
      fn(t).deliverTo(function(s: B) {
        fut.deliver(s);
      }).ifCanceled(function() {
        untyped fut.forceCancel();
      });
    });

    f.ifCanceled(function() { untyped fut.forceCancel(); });

    return fut;
  }

  /**
    Drop this future, returning f.
  */
  public function then<S>(f: Future<S>): Future<S> {
    return f;
  }


  /** 
    Returns a new future that will be delivered only if the result of this
    future is accepted by the specified filter (otherwise, the new future
    will be canceled).
   */
  public function filter(f: T -> Bool): Future<T> {
    var fut: Future<T> = new Future();

    deliverTo(function(t: T) { if (f(t)) fut.deliver(t); else fut.forceCancel(); });

    ifCanceled(function() fut.forceCancel());

    return fut;
  }

  /** 
    Zips this future and the specified future into another future, whose
    result is a tuple of the individual results of the futures. Useful when
    an operation requires the result of two futures, but each future may
    execute independently of the other.
   */
  public function zip<A>(f2: Future<A>): Future<Tuple2<T, A>> {
    return zipWith( f2, Tuples.tuple2 );
  }
  public function zipWith<A,B>(f2:Future<A>,fn : T -> A -> B):Future<B>{
    //trace('zip');
    var zipped: Future<B> = new Future();
    var sent : Bool       = false;

    var f1 = this;
    var deliverZip = function() {
      if (f1.isDelivered() && f2.isDelivered() && !sent ) {
        sent = true;
        zipped.deliver(
          fn(f1.valueO().get(), f2.valueO().get())
        );
      }
    }
    f1.deliverTo(function(v) deliverZip());
    f2.deliverTo(function(v) deliverZip());

    zipped.allowCancelOnlyIf(function() return f1.cancel() || f2.cancel());

    f1.ifCanceled(function() zipped.forceCancel());
    f2.ifCanceled(function() zipped.forceCancel());

    return zipped; 
  }
  /** 
    Retrieves the value of the future, as an option.
   */
  public function valueO(): Option<T> {
    return if (_isSet) Some(value) else None;
  }
  public function toOption(): Option<T> {
    return valueO();
  }

  public function toArray(): Array<T> {
    return valueO().toArray();
  }

  private function forceCancel(): Future<T> {
    if (!_isCanceled) {
      _isCanceled = true;

      for (canceled in _canceled) canceled();
    }

    return this;
  }

  public static function create<T>(): Future<T> {
    return new Future<T>();
  }
  public static function toFuture<T>(t: T): Future<T> {
    return Future.create().deliver(t);
  }
  @:noUsing
  static public function pure<A>(v:A):Future<A>{
    return toFuture(v);
  }
  @:noUsing
  static public function unit<A>():Future<A>{
    return new Future();
  }
  public function deliverMe(f:Future<T>-> Void): Future<T> {
    if (isCanceled()) return this;
    else if (isDelivered()) f(this);
    else _listeners.push(function(g) {
        f(this);
      });
    return this;
  }
}
class Futures{
  static public function foreach<A>(f:Future<A>,fn:A->Void):Future<A>{
    return f.foreach(fn);
  }
  static public function mapL<A,B,C>(f:Future<Either<A,B>>,fn:A->C):Future<Either<C,B>>{
    return f.map(
      function(x){
        return switch (x){
          case      Left(l)      : Left(fn(l));
          case      Right(r)     : Right(r);
        };
      }
    );
  }
  static public function mapR<A,B,C>(f:Future<Either<A,B>>,fn:B->C):Future<Either<A,C>>{
    return f.map(
      function(x){
        return switch (x){
          case      Left(l)      : Left(l);
          case      Right(r)     : Right(fn(r));
        }
      }
    );
  }
  static public function map<A,B>(f:Future<A>,fn:A->B):Future<B>{
    return f.map(fn);
  }
  static public function flatMap<A,B>(f:Future<A>,fn:A->Future<B>):Future<B>{
    var fut: Future<B> = new Future();
    f.deliverTo(function(t: A) {
      fn(t).deliverTo(function(s: B) {
        fut.deliver(s);
      }).ifCanceled(function() {
        untyped fut.forceCancel();
      });
    });

    f.ifCanceled(function() { untyped fut.forceCancel(); });

    return fut;
  }
  static public function flatMapR<A,B>(f:Future<Outcome<A>>,fn:A->Future<Outcome<B>>):Future<Outcome<B>>{
    return flatMap(f,
      function(x){
        return switch (x){
          case Left(l)      : Future.pure(Left(l));
          case Right(r)     : fn(r);
        }
      }
    );
  }
  static public function zip<A,B>(f:Future<A>,f2:Future<B>):Future<Tuple2<A,B>>{
    return f.zip(f2);
  }
  static public function waitFor<A>(toJoin:Array<Future<A>>):Future<Array<A>> {
    var
      joinLen = toJoin.size(),
      myprm = Future.create(),
      combined:Array<{seq:Int,val:Dynamic}> = [],
      sequence = 0;
        
    toJoin.foreach(function(xprm:Dynamic) {
        if(!Std.is(xprm,Future)) {
          throw "not a Future:"+xprm;
        }

        xprm.sequence = sequence++; 
        xprm.deliverMe(function(r:Dynamic) {
            combined.push({ seq:r.sequence,val:r.value});
            if (combined.length == joinLen) {
              combined.sort(function(x,y) { return x.seq - y.seq; });

              //trace("combined :"+combined.map(function(el) { return el.seq; }).stringify());              
              myprm.deliver(combined.map(function(el) { return el.val; }));
            }
          });
      });  
    return myprm;
  }
  static public function bindFold<A,B>(iter:Iterable<A>,start:Future<B>,fm:B->A->Future<B>):Future<B>{
    return 
      iter.foldl(
        start ,
        function(memo : Future<B>, next : A){
          return 
            memo.flatMap(
              function(b: B){
                return fm(b,next);
              }
            );
        }
      );
  }
}
class Futures1{
  /**
    One parameter callback handler, where callback is called exactly once.
  */
  static public function futureOf<A>(f:(A->Void)->Void):Future<A>{
    var fut = new Future();
    f(
      function(res){
        fut.deliver(res);
      }
    );
    return fut;
  }
}
class Futures2{
  /**
    Creates a Future of Tuple2<A,B> from a callback function(a:A,b:B)
  */
  static public function futureOf<A,B>(f:(A->B->Void)->Void):Future<Tuple2<A,B>>{
    var ft = new Future();
    f(
      function(a,b){
        ft.deliver( tuple2(a,b) );
      }
    );
    return ft;
  }
}
class Futures3{
  /**
    Creates a Future of Tuple2<A,B,C> from a callback function(a:A,b:B,c:C)
  */
  static public function futureOf<A,B,C>(f:(A->B->C->Void)->Void):Future<Tuple3<A,B,C>>{
    var ft = new Future();
    f(
      function(a,b,c){
        ft.deliver( tuple3(a,b,c) );
      }
    );
    return ft;
  }
}