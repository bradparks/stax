package stx;

import stx.macro.F;
import stx.Promises;
import stx.Error;

using stx.Prelude;
using stx.Iterables;
using stx.Iteratee;
using stx.Functions;

typedef EnumeratorApply<E,A> = Iteratee<E,A> -> Future<Iteratee<E,A>>;

class Enumerator<E>{
  @:noUsing static public function create<E,A>( opts : { apply : EnumeratorApply<E,A> } ){
    return new Enumerator(opts);
  }
  @:noUsing static public function pure<E,A>(apply:EnumeratorApply<E,A>){
    return create( { apply : apply } );
  }

  public function new<A>(opts : { apply : EnumeratorApply<E,A> }){
    this.apply = opts.apply;
  }
  public dynamic function apply<A>(i:Iteratee<E,A>):Future<Iteratee<E,A>>{
    return null;
  }
  public function run<A>(i:Iteratee<E,A>){
    return apply(i).flatMap(function(x) return x.run());
  }
}
class Enumerators{
  static public function applyer<E,A>(en:Enumerator<E>,it:Iteratee<E,A>){
    return en.apply(it);
  }
  static public function flatten<A,E>(eventual:Future<Enumerator<E>>):Enumerator<E>{
    return 
      Enumerator.pure(
        function(it:Iteratee<E,A>){
          return eventual.flatMap(applyer.p2(it));
        }
      );
  }
  static public function enumInput<E,A>(e:Input<E>):Enumerator<E>{
    return 
      Enumerator.pure(
        function(it){
          return
            it.fold(
              function(step){
                return 
                  switch (step) {
                    case Step.Cont(k) : Promises.success(k(e));
                    default           : Promises.success(it);
                  }
              }
            ).map(
              function(e){
                return switch (e) {
                  case Left(v)  : Iteratees.Error(v,null);
                  case Right(v) : v;
                }
              }
            );
        }
      );
  }
  /*static public function interleave<E,A>(es:Iterable<Enumerator<E>>){
    return 
      Enumerator.create(
        function(it0:Iteratee<E,A>){
          var attending   = es;
          //: Ref[Option[Seq[Boolean]]] = es.map(function(x)return truRef(Some(es.map(_ => true)))
          var result      = new Future();

          var deliverIfNotYet = 
            function(r:Iteratee<E,A>){
              if(true)//something
              {
                result.deliver(r);
              }
            }
          var iteratee        =
            function(f:Iterable<Bool> -> Iterable<Bool>){
              var step = null;
                  step =  function(inpt:Input<E>){
                            var ft    = Promises.success(Iteratees.Done(null,Input.Empty));
                            var it1   = it0;
                                it0   = Iteratees.flatten(ft);
                                switch (inpt) {
                                  case Input.End  :
                                    if(attending.map(f).forall(function(x) return x  == false)) {
                                      ft.deliver(Iteratees.flatten(it1.feed(Input.End)));
                                    } else {
                                      ft.deliver(it1);
                                    }
                                    Iteratees.Done(null, Input.Empty);
                                  default         :
                                    var nextI = 
                                      it1.fold(
                                        function(inpt1){
                                          return switch (inpt1) {
                                            case Cont(k) :
                                              var n = k(inpt);
                                              return
                                                switch (n) {
                                                  case Step.Cont(kk)  :
                                                    ft.deliver(Iteratees.Cont(kk));
                                                    Future.pure(Iteratees.Cont(step));
                                                  default             :
                                                    ft.deliver(n);
                                                    Future.pure(Iteratees.Done(null,Input.Empty));
                                                }
                                            default       :
                                              ft.redeem(it1);
                                            }
                                        }
                                      );
                                      Iteratees.flatten(nextI);
                                }
                          }
                return Iteratees.Cont(step);
              }
            var ps =
              es.zipWithIndex().map(
                function(t){
                    return 
                    Tuple2.into(F.n([e,index],return e.apply(iteratee(F.n(vals,return vals.patch(index,[true],1))))))
                    .map(F.n(v,return v.flatMap(F.n(v2,return v2.pureFold(SBase.identity())))));
                }
              );

        }
      );
  }*/
}