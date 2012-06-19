package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.Prelude;

using stx.Functions;
using stx.Dynamics;

class CodeBlocks {
	/**
	 * Takes a Void->Void and returns a Void->Dynamic.
	 * @param	c
	 * @return
	 */
  public static function returningC(c:CodeBlock,val):Thunk<Dynamic>{
    return function(){
      c();
      return val;
    }
  }
  public static function catching<A,B>(c:Thunk<A>):Either<Dynamic,A>{
    var o = null;
    try{
      o = Right(c());
    }catch(e:Dynamic){
      o = Left(e);
    }
    return o;
  }
  public static function equals(a:CodeBlock,b:CodeBlock){
    return Reflect.compareMethods(a,b);
  }
}	
class Functions0 {
	/**
	 * Takes a function that returns a result, and produces one that ignores that result.
	 */
	public static function enclose<R>(f:Thunk<R>):CodeBlock{
		return
			function():Void{
				f();
			}
	}
	/**
	 * Takes a function 'f' and produces one that ignores any error the occurs whilst calling 'f'.
	 * @param	f
	 */
  public static function swallow(f: Void -> Void): Void -> Void {
    return function() {
      try {
        f();
      }
      catch (e: Dynamic) { }
    }
  }
  /**
   * Produces a function that calls 'f1' and 'f2' in left to right order.
   * @param	f1
   * @param	f2
	 * @return The composite function.
   */
  public static function thenDo(f1: Void -> Void, f2: Void -> Void): Void -> Void {
    return function() {
      f1();
      f2();
    }
  }
	/**
	 * Produces a function that calls 'f', ignores its result, and returns the result produced by thunk.
	 * @param f	
	 * @param thunk
	 */
  public static function returning<R1, R2>(f: Void -> R1, thunk: Thunk<R2>): Void -> R2 {
    return function() {
      f();
      
      return thunk();
    }
  }
	/**
	 * Produces a function that calls 'f', ignores it's result, and returns 'value'
	 * @param f
	 * @param value
	 */
  public static function returningC<R1, R2>(f: Void -> R2, value: R2): Void -> R2 {
    return returning(f, value.toThunk());
  }
	/**
	 * Produces a function that takes a parameter. ignores it, and calls 'f', returning it's result.
	 * @param f
	 */
  public static function promote<A, Z>(f: Void -> Z): A -> Z {
    return function(a: A): Z {
      return f();
    }
  }
  /**
	 * Produces a function that takes a parameter, ignores it, and calls 'f'.
	 * @param f
	 * @return a Function1
   */
  public static function promoteEffect<A>(f: Void -> Void): A -> Void {
    return function(a: A): Void {
      f();
    }
  }
  /**
	 * Produces a function that calls and stores the result of 'before', then 'f', then calls 'after' with the result of 
	 * 'before' and finally returns the result of 'f'.
	 * @param f function that produces output
	 * @param before
	 * @param after
	 * @return the output of f;
   */
  public static function stage<Z, T>(f: Function0<Z>, before: Void -> T, after: T -> Void): Z {
    var state = before();
    
    var result = f();
    
    after(state);
    
    return result;
  }
  /**
	 * Produces a function that calls 'f', ignoring the result.
	 * @param f
	 * @return 
   */
  public static function toEffect<T>(f: Function0<T>): Void -> Void {
    return function() {
      f();
    }
  }
  public static function map<A,B>(f:Thunk<A>,f1:A->B):Thunk<B>{
    return function(){return f1(f());}
  }
  public static function equals<A>(a:Thunk<A>,b:Thunk<A>){
    return Reflect.compareMethods(a,b);
  }
}
class Functions1 {
	/**
	 * Produces a function that ignores any error the occurs whilst calling the input function.
	 * @param	f
	 * @return 
	 */
  public static function swallow<A>(f: Function1<A, Void>): Function1<A, Void> {
    return toEffect(swallowWith(f, null));
  }
	/**
	 * Produces a function that ignores any error the occurs whilst calling the input function, and produces 'd' if error occurs.
	 * @param	f
	 * @return 
	 */
  public static function swallowWith<P1, R>(f: Function1<P1, R>, d: R): Function1<P1, R> {
    return function(a) {
      try {
        return f(a);
      }
      catch (e: Dynamic) { }
      return d;
    }
  }
	/**
   * Produces a function that calls 'f1' and 'f2' in left to right order with the same input, and returns no result.
   * @param	f1
   * @param	f2
	 * @return The composite function.
   */
  public static function thenDo<P1>(f1: P1 -> Void, f2: P1 -> Void): P1 -> Void {
    return function(p1) {
      f1(p1);
      f2(p1);
    }
  }
	/**
	 * Produces a function that produces a function for each parameter in the originating function. When these
	 * functions have been called, the result of the original function is produced.
	 * @param f
	 */
	 public static function curry<P1, R>(f: Function1<P1, R>) {
    return function() {
      return function(p1: P1) {
        return f(p1);
      }
    }
  }
	/**
	 * Produces a function that calls 'f', ignores its result, and returns the result produced by thunk.
	 * @param f
	 * @param thunk
	 */
  public static function returning<P1, R1, R2>(f: Function1<P1, R1>, thunk: Thunk<R2>): Function1<P1, R2> {
    return function(p1) {
      f(p1);
      
      return thunk();
    }
  }
	/**
	 * Produces a function that calls 'f', ignores it's result, and returns 'value'
	 * @param f
	 * @param value
	 */
  public static function returningC<P1, R1, R2>(f: Function1<P1, R2>, value: R2): Function1<P1, R2> {
    return returning(f, value.toThunk());
  }
	/**
	 * Returns a function that calls 'f1' with the output of 'f2'.
	 * @param f1
	 * @param f2
	 */
  public static function compose<U, V, W>(f1: Function1<V, W>, f2: Function1<U, V>): Function1<U, W> {
    return function(u: U): W {
      return f1(f2(u));
    }
  }
	/**
	 * Returns a function that calls 'f2' with the output of 'f1'trace.
	 * @param f1
	 * @param f2
	 */
  public static function andThen<U, V, W>(f1: Function1<U, V>, f2: Function1<V, W>): Function1<U, W> {
    return compose(f2, f1);
  }
	/**
	 * Produdes a function that calls 'f' with the given parameters p1....pn.
	 */
  public static function lazy<P1, R>(f: Function1<P1, R>, p1: P1): Thunk<R> {
    var r = null;
    
    return function() {
      return if (r == null) { r = f(p1); r; } else r;
    }
  }
	/**
	 * Produces a function that calls 'f', ignoring the result.
	 * @param f
	 * @return 
   */
  public static function toEffect<P1, R>(f: Function1<P1, R>): P1 -> Void {
    return function(p1) {
      f(p1);
    }
  }
  public static function equals<P1,R>(a:Function1<P1,R>,b:Function1<P1,R>){
    return Reflect.compareMethods(a,b);
  }
}
class Functions2 {  
  /**
   * fill in the first parameter of the function, produces another function.
   */
  public static function p1<P1,P2,R>(f:Function2<P1,P2,R>,p1:P1):P2->R{
    return f.curry()(p1);
  }
  public static function p2<P1,P2,R>(f:Function2<P1,P2,R>,p2:P2):P1->R{
    return f.flip().curry()(p2);
  }
	/**
	 * Produces a function that ignores any error the occurs whilst calling the input function.
	 * @param	f
	 * @return 
	 */
  public static function swallow<P1, P2>(f: Function2<P1, P2, Void>): Function2<P1, P2, Void> {
    return toEffect(swallowWith(f, null));
  }
	/**
	 * Produces a function that ignores any error the occurs whilst calling the input function, and produces 'd' if error occurs.
	 * @param	f
	 * @return 
	 */
  public static function swallowWith<P1, P2, R>(f: Function2<P1, P2, R>, d: R): Function2<P1, P2, R> {
    return function(p1, p2) {
      try {
        return f(p1, p2);
      }
      catch (e: Dynamic) { }
      return d;
    }
  }
	/**
   * Produces a function that calls 'f1' and 'f2' in left to right order with the same input, and returns no result.
   * @param	f1
   * @param	f2
	 * @return The composite function.
   */
  public static function thenDo<P1, P2>(f1: P1 -> P2 -> Void, f2: P1 -> P2 -> Void): P1 -> P2 -> Void {
    return function(p1, p2) {
      f1(p1, p2);
      f2(p1, p2);
    }
  }
	/**
	 * Produces a function that calls 'f', ignores its result, and returns the result produced by thunk.
	 * @param f
	 * @param thunk
	 */
  public static function returning<P1, P2, R1, R2>(f: Function2<P1, P2, R1>, thunk: Thunk<R2>): Function2<P1, P2, R2> {
    return function(p1, p2) {
      f(p1, p2);
      
      return thunk();
    }
  }
	/**
	 * Produces a function that calls 'f', ignores it's result, and returns 'value'
	 * @param f
	 * @param value
	 */
  public static function returningC(f, value) {
    return returning(f, value.toThunk());
  }
	/**
	 * Produces a function which takes the parameters of 'f' in a flipped order.
	 */
  public static function flip<P1, P2, R>(f: Function2<P1, P2, R>): Function2<P2, P1, R> {
    return function(p2, p1) {
      return f(p1, p2);
    }
  }
	/**
	 * Produces a function that produces a function for each parameter in the originating function. When these
	 * functions have been called, the result of the original function is returned.
	 * @param f
	 */
  public static function curry<P1, P2, R>(f: Function2<P1, P2, R>): Function1<P1, Function1<P2, R>> {
    return function(p1: P1) {
      return function(p2: P2) {
        return f(p1, p2);
      }
    }
  }
	/**
	 * Takes a function with one parameter that returns a function of one parameter, and produces
	 * a function that takes two parameters that calls the two functions sequentially,
	 */
  public static function uncurry<P1, P2, R>(f: Function1<P1, Function1<P2, R>>): Function2<P1, P2, R> {
    return function(p1: P1, p2: P2) {
      return f(p1)(p2);
    }
  }
	/**
	 * Produdes a function that calls 'f' with the given parameters p1....pn.
	 */
  public static function lazy<P1, P2, R>(f: Function2<P1, P2, R>, p1: P1, p2: P2): Thunk<R> {
    var r = null;
    
    return function() {
      return if (r == null) { r = f(p1, p2); r; } else r;
    }
  }
	/**
	 * Produces a function that calls 'f', ignoring the result.
	 * @param f
	 * @return 
   */
  public static function toEffect<P1, P2, R>(f: Function2<P1, P2, R>): P1 -> P2 -> Void {
    return function(p1, p2) {
      f(p1, p2);
    }
  }
  public static function equals<P1,P2,R>(a:Function2<P1,P2,R>,b:Function2<P1,P2,R>){
    return Reflect.compareMethods(a,b);
  }
}
class Functions3 {  
	/**
	 * Produces a function that ignores any error the occurs whilst calling the input function.
	 * @param	f
	 * @return 
	 */
  public static function swallow<A, B, C>(f: Function3<A, B, C, Void>): Function3<A, B, C, Void> {
    return toEffect(swallowWith(f, null));
  }
	/**
	 * Produces a function that ignores any error the occurs whilst calling the input function, and produces 'd' if error occurs.
	 * @param	f
	 * @return 
	 */
  public static function swallowWith<A, B, C, R>(f: Function3<A, B, C, R>, d: R): Function3<A, B, C, R> {
    return function(a, b, c) {
      try {
        return f(a, b, c);
      }
      catch (e: Dynamic) { }
      return d;
    }
  }
	/**
   * Produces a function that calls 'f1' and 'f2' in left to right order with the same input, and returns no result.
   * @param	f1
   * @param	f2
	 * @return The composite function.
   */
  public static function thenDo<P1, P2, P3>(f1: P1 -> P2 -> P3 -> Void, f2: P1 -> P2 -> P3 -> Void): P1 -> P2 -> P3 -> Void {
    return function(p1, p2, p3) {
      f1(p1, p2, p3);
      f2(p1, p2, p3);
    }
  }
	/**
	 * Produces a function that calls 'f', ignores its result, and returns the result produced by thunk.
	 * @param f
	 * @param thunk
	 */
  public static function returning<P1, P2, P3, R1, R2>(f: Function3<P1, P2, P3, R1>, thunk: Thunk<R2>): Function3<P1, P2, P3, R2> {
    return function(p1, p2, p3) {
      f(p1, p2, p3);
      
      return thunk();
    }
  }
	/**
	 * Produces a function that calls 'f', ignores it's result, and returns 'value'
	 * @param f
	 * @param value
	 */
  public static function returningC(f, value) {
    return returning(f, value.toThunk());
  }
	/**
	 * Produces a function that produces a function for each parameter in the originating function. When these
	 * functions have been called, the result of the original function is produced.
	 * @param f
	 */
  public static function curry<P1, P2, P3, R>(f: Function3<P1, P2, P3, R>): Function1<P1, Function1<P2, Function1<P3, R>>> {
    return function(p1: P1) {
      return function(p2: P2) {
        return function(p3: P3) {
          return f(p1, p2, p3);
        }
      }
    }
  }
	/**
	 * Takes a function with one parameter that returns a function of one parameter, and produces
	 * a function that takes two parameters that calls the two functions sequentially,
	 */
  public static function uncurry<P1, P2, P3, R>(f: Function1<P1, Function1<P2, Function1<P3, R>>>): Function3<P1, P2, P3, R> {
    return function(p1: P1, p2: P2, p3: P3) {
      return f(p1)(p2)(p3);
    }
  }
	/**
	 * Produdes a function that calls 'f' with the given parameters p1....pn.
	 */
  public static function lazy<P1, P2, P3, R>(f: Function3<P1, P2, P3, R>, p1: P1, p2: P2, p3: P3): Thunk<R> {
    var r = null;
    
    return function() {
      return if (r == null) { r = f(p1, p2, p3); r; } else r;
    }
  }
	/**
	 * Produces a function that calls 'f', ignoring the result.
	 * @param f
	 * @return 
   */
  public static function toEffect<P1, P2, P3, R>(f: Function3<P1, P2, P3, R>): P1 -> P2 -> P3 -> Void {
    return function(p1, p2, p3) {
      f(p1, p2, p3);
    }
  }
  public static function equals<P1,P2,P3,R>(a:Function3<P1,P2,P3,R>,b:Function3<P1,P2,P3,R>){
    return Reflect.compareMethods(a,b);
  }
}
class Functions4 {  
	/**
	 * Produces a function that ignores any error the occurs whilst calling the input function.
	 * @param	f
	 * @return 
	 */
  public static function swallow<A, B, C, D>(f: Function4<A, B, C, D, Void>): Function4<A, B, C, D, Void> {
    return toEffect(swallowWith(f, null));
  }
	/**
	 * Produces a function that ignores any error the occurs whilst calling the input function, and produces 'd' if error occurs.
	 * @param	f
	 * @return 
	 */
  public static function swallowWith<A, B, C, D, R>(f: Function4<A, B, C, D, R>, def: R): Function4<A, B, C, D, R> {
    return function(a, b, c, d) {
      try {
        return f(a, b, c, d);
      }
      catch (e: Dynamic) { }
      return def;
    }
  }
	/**
   * Produces a function that calls 'f1' and 'f2' in left to right order with the same input, and returns no result.
   * @param	f1
   * @param	f2
	 * @return The composite function.
   */
  public static function thenDo<P1, P2, P3, P4>(f1: P1 -> P2 -> P3 -> P4 -> Void, f2: P1 -> P2 -> P3 -> P4 -> Void): P1 -> P2 -> P3 -> P4 -> Void {
    return function(p1, p2, p3, p4) {
      f1(p1, p2, p3, p4);
      f2(p1, p2, p3, p4);
    }
  }
	/**
	 * Produces a function that calls 'f', ignores its result, and returns the result produced by thunk.
	 * @param f
	 * @param thunk
	 */
  public static function returning<P1, P2, P3, P4, R1, R2>(f: Function4<P1, P2, P3, P4, R1>, thunk: Thunk<R2>): Function4<P1, P2, P3, P4, R2> {
    return function(p1, p2, p3, p4) {
      f(p1, p2, p3, p4);
      
      return thunk();
    }
  }
	/**
	 * Produces a function that calls 'f', ignores it's result, and returns 'value'
	 * @param f
	 * @param value
	 */
  public static function returningC(f, value) {
    return returning(f, value.toThunk());
  }
	/**
	 * Produces a function that produces a function for each parameter in the originating function. When these
	 * functions have been called, the result of the original function is produced.
	 * @param f
	 */
  public static function curry<P1, P2, P3, P4, R>(f: Function4<P1, P2, P3, P4, R>): Function1<P1, Function1<P2, Function1<P3, Function1<P4, R>>>> {
    return function(p1: P1) {
      return function(p2: P2) {
        return function(p3: P3) {
          return function(p4: P4) {
            return f(p1, p2, p3, p4);
          }
        }
      }
    }
  }
	/**
	 * Takes a function with one parameter that returns a function of one parameter, and produces
	 * a function that takes two parameters that calls the two functions sequentially,
	 */
  public static function uncurry<P1, P2, P3, P4, R>(f: Function1<P1, Function1<P2, Function1<P3, Function1<P4, R>>>>): Function4<P1, P2, P3, P4, R> {
    return function(p1: P1, p2: P2, p3: P3, p4: P4) {
      return f(p1)(p2)(p3)(p4);
    }
  }
	/**
	 * Produdes a function that calls 'f' with the given parameters p1....pn.
	 */
  public static function lazy<P1, P2, P3, P4, R>(f: Function4<P1, P2, P3, P4, R>, p1: P1, p2: P2, p3: P3, p4: P4): Thunk<R> {
    var r = null;
    
    return function() {
      return if (r == null) { r = f(p1, p2, p3, p4); r; } else r;
    }
  }
	/**
	 * Produces a function that calls 'f', ignoring the result.
	 * @param f
	 * @return 
   */
  public static function toEffect<P1, P2, P3, P4, R>(f: Function4<P1, P2, P3, P4, R>): P1 -> P2 -> P3 -> P4 -> Void {
    return function(p1, p2, p3, p4) {
      f(p1, p2, p3, p4);
    }
  }
  public static function equals<P1,P2,P3,P4,R>(a:Function4<P1,P2,P3,P4,R>,b:Function4<P1,P2,P3,P4,R>){
    return Reflect.compareMethods(a,b);
  }
}
class Functions5 {  
	/**
	 * Produces a function that ignores any error the occurs whilst calling the input function.
	 * @param	f
	 * @return 
	 */
  public static function swallow<A, B, C, D, E>(f: Function5<A, B, C, D, E, Void>): Function5<A, B, C, D, E, Void> {
    return toEffect(swallowWith(f, null));
  }
	/**
	 * Produces a function that ignores any error the occurs whilst calling the input function, and produces 'd' if error occurs.
	 * @param	f
	 * @return 
	 */
  public static function swallowWith<A, B, C, D, E, R>(f: Function5<A, B, C, D, E, R>, def: R): Function5<A, B, C, D, E, R> {
    return function(a, b, c, d, e) {
      try {
        return f(a, b, c, d, e);
      }
      catch (e: Dynamic) { }
      return def;
    }
  }
	/**
   * Produces a function that calls 'f1' and 'f2' in left to right order with the same input, and returns no result.
   * @param	f1
   * @param	f2
	 * @return The composite function.
   */
  public static function thenDo<P1, P2, P3, P4, P5>(f1: P1 -> P2 -> P3 -> P4 -> P5 -> Void, f2: P1 -> P2 -> P3 -> P4 -> P5 -> Void): P1 -> P2 -> P3 -> P4 -> P5 -> Void {
    return function(p1, p2, p3, p4, p5) {
      f1(p1, p2, p3, p4, p5);
      f2(p1, p2, p3, p4, p5);
    }
  }
	/**
	 * Produces a function that calls 'f', ignores its result, and returns the result produced by thunk.
	 * @param f
	 * @param thunk
	 */
  public static function returning<P1, P2, P3, P4, P5, R1, R2>(f: Function5<P1, P2, P3, P4, P5, R1>, thunk: Thunk<R2>): Function5<P1, P2, P3, P4, P5, R2> {
    return function(p1, p2, p3, p4, p5) {
      f(p1, p2, p3, p4, p5);
      
      return thunk();
    }
  }
	/**
	 * Produces a function that calls 'f', ignores it's result, and returns 'value'
	 * @param f
	 * @param value
	 */
  public static function returningC(f, value) {
    return returning(f, value.toThunk());
  }
	/**
	 * Produces a function that produces a function for each parameter in the originating function. When these
	 * functions have been called, the result of the original function is produced.
	 * @param f
	 */
  public static function curry<P1, P2, P3, P4, P5, R>(f: Function5<P1, P2, P3, P4, P5, R>): Function1<P1, Function1<P2, Function1<P3, Function1<P4, Function1<P5, R>>>>> {
    return function(p1: P1) {
      return function(p2: P2) {
        return function(p3: P3) {
          return function(p4: P4) {
            return function(p5: P5) {
              return f(p1, p2, p3, p4, p5);
            }
          }
        }
      }
    }
  }
	/**
	 * Takes a function with one parameter that returns a function of one parameter, and produces
	 * a function that takes two parameters that calls the two functions sequentially,
	 */
  public static function uncurry<P1, P2, P3, P4, P5, R>(f: Function1<P1, Function1<P2, Function1<P3, Function1<P4, Function1<P5, R>>>>>): Function5<P1, P2, P3, P4, P5, R> {
    return function(p1: P1, p2: P2, p3: P3, p4: P4, p5: P5) {
      return f(p1)(p2)(p3)(p4)(p5);
    }
  }
	/**
	 * Produdes a function that calls 'f' with the given parameters p1....pn.
	 */
  public static function lazy<P1, P2, P3, P4, P5, R>(f: Function5<P1, P2, P3, P4, P5, R>, p1: P1, p2: P2, p3: P3, p4: P4, p5: P5): Thunk<R> {
    var r = null;
    
    return function() {
      return if (r == null) { r = f(p1, p2, p3, p4, p5); r; } else r;
    }
  }
	/**
	 * Produces a function that calls 'f', ignoring the result.
	 * @param f
	 * @return 
   */
  public static function toEffect<P1, P2, P3, P4, P5, R>(f: Function5<P1, P2, P3, P4, P5, R>): P1 -> P2 -> P3 -> P4 -> P5 -> Void {
    return function(p1, p2, p3, p4, p5) {
      f(p1, p2, p3, p4, p5);
    }
  }
  public static function equals<P1,P2,P3,P4,P5,R>(a:Function5<P1,P2,P3,P4,P5,R>,b:Function5<P1,P2,P3,P4,P5,R>){
    return Reflect.compareMethods(a,b);
  }
}
