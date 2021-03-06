package rx;

import Stax.*;

using hx.Reactor;

import stx.utl.Selector;

import stx.Fail;
import stx.Contract;
import stx.Eventual;
import stx.Compare;
import stx.Chunk;
import Prelude;
import stx.Continuation;

using stx.Iterables;
using stx.Types;
using stx.Compose;

import rx.ifs.Observable in IObservable;

import rx.observable.*;
import rx.disposable.*;

typedef ObservableType<T> = IObservable<T>;


abstract Observable<T>(ObservableType<T>) from ObservableType<T> to ObservableType<T>{
  @doc("Produces an Observable that does nothing.")
  @:noUsing static public function unit<T>():Observable<T>{
    return function(obs:Observer<T>):Disposable{ 
      return noop; 
    }
  }
  @doc("Produces an Observable that sends a done message.")
  @:noUsing static public function empty<T>():Observable<T>{
    return function(obs:Observer<T>):Disposable{ 
      obs.apply(Nil);
      return noop; 
    }
  }
  public function new(v){
    this = v;
  }
  public function subscribe(obs:Observer<T>):Disposable{
    return this.subscribe(obs);
  }
  @:from static public function fromIterableChunk<T>(itr:Iterable<Chunk<T>>):Observable<T>{
    return new IterableChunkObservable(itr);
  }
  @:from static public function fromIterable<T>(itr:Iterable<T>):Observable<T>{
    return new IterableObservable(itr);
  }
  @:from static public function fromAnonymousObservable<T>(fn:Observer<T> -> Disposable){
    return new AnonymousObservable(fn);
  }
  @:from static public function fromT<T>(v:T):Observable<T>{
    return function(observer:Observer<T>){
      observer.onData(v);
      observer.onDone();
      return Disposable.unit();
    }
  }
  /*
    @:from static public function fromContinuation<T>(cnt:Continuation<Disposable,Chunk<T>>):Observable<T>{
      var ct : ContinuationType<Disposable,Chunk<T>>  = cnt;
      var ot : ObservableType<T>                      = new ObservableDelegate(ct);
    return new Observable(ot);
  }*/
  /*
  public function map<U>(fn:T->U):Observable<U>{
    return Observables.map(this,fn);
  }
  public function flatMap<U>(fn:T->Observable<U>):Observable<U>{
    return Observables.flatMap(this,fn);
  }
  */
  /*
  public function each(fn:Chunk<T>->Void):Disposable{
    return Observables.each(this,fn);
  }
  */
  public function next(fn:T->Void){
    return Observables.next(this,fn);
  }
  public function fail(fn:Fail->Void){
    return Observables.fail(this,fn);
  }
  public function done(fn:Niladic){
    return Observables.done(this,fn);
  }
}
class Observables{
  static public function materialize<T>(observer:Observer<T>){
    return new Materialize()
  }
}
@doc("Observe an Eventual value")
class EventualObservables{
  static public function observe<T>(evt:Eventual<T>):Observable<T>{
    return new EventualObservable(evt);
  }
}
@doc("Observe the Outcome of a Contract.")
class ContractObservables{
  static public function observe<T>(evt:Contract<T>):Observable<T>{
    return new ContractObservable(evt);
  } 
}
@doc("Observe values emitted by a Reactor.")
class ReactorChunkObservables{
  static public function observe<T>(rct:Reactor<Chunk<T>>):Observable<T>{
    return new ReactorChunkObservable(rct);
  }
}
class IterableChunkObservables{
  static public function observe<T>(itr:Iterable<Chunk<T>>):Observable<T>{
    return new IterableChunkObservable(itr);
  }
}
class IterableObservables{
  static public function observe<T>(itr:Iterable<T>):Observable<T>{
    return new IterableObservable(itr);
  }
}