package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.ds.plus.Show;				using stx.ds.plus.Show;


typedef Product = {
	
}
typedef Tuple2<A,B> = { >Product,
	_1 : Null<A>,
	_2 : Null<B>,
}
typedef Tuple3<A,B,C> = { > Tuple2<A,B>,
	_3 : Null<C>,
}
typedef Tuple4<A,B,C,D> = { > Tuple3<A,B,C>,
	_4 : Null<D>,
}
typedef Tuple5<A,B,C,D,E> = { > Tuple4<A,B,C,D>,
	_5 : Null<E>,
}
class Products {
	static public function arity(p:Product) {
		return 
				if ( Reflect.hasField( p , '_5' ) ) {
					5;
				}else if ( Reflect.hasField( p , '_4' ) ) {
					4;
				}else if ( Reflect.hasField( p , '_3' ) ) {
					3;
				}else if ( Reflect.hasField( p , '_2' ) ) {
					2;
				}else {
					1;
				}
	}
	static public function element(p:Product, index:Int) {
		return switch (index) {
			case 5	: cast(p)._5;
			case 4	: cast(p)._4;
			case 3	: cast(p)._3;
			case 2	: cast(p)._2;
			case 1	: cast(p)._1;
		}
	}
	static public function elements(p:Product):Array<Dynamic> {
		return switch (arity(p)) {
			case 5 	: 
					var p : Tuple5<Dynamic,Dynamic,Dynamic,Dynamic,Dynamic> = cast(p);
					[ p._1 , p._2 , p._3 , p._4, p._5 ];
			case 4	:
					var p : Tuple4<Dynamic,Dynamic,Dynamic,Dynamic> = cast(p);
					[ p._1 , p._2 , p._3 , p._4 ];
			case 3	:
					var p : Tuple3<Dynamic,Dynamic,Dynamic> = cast(p);
					[ p._1 , p._2 , p._3 ];
			case 2	:
					var p : Tuple2<Dynamic,Dynamic> = cast(p);
					[ p._1 , p._2 ];
		}
	}
	/*static public function toString(p:Product): String {
    var s = "Tuple" + arity(p) + "(" + p.getProductShow(0)(element(p,1));
    for(i in 1...arity(p))
      s += ", " + p.getProductShow(i)(element(p,i));
    return s + ")";
  }*/
}
class Tuples {
	public static inline function t2<A,B>(_1:A,_2:B):stx.Tuple2<A,B>{
		return { _1 : _1, _2 : _2 };
	}
	public static inline function t3<A,B,C>(_1:A,_2:B,_3:C):stx.Tuple3<A,B,C>{
		return { _1 : _1, _2 : _2, _3 : _3};
	}
	public static inline function t4<A,B,C,D>(_1:A,_2:B,_3:C,_4:D):stx.Tuple4<A,B,C,D>{
		return { _1 : _1, _2 : _2, _3 : _3, _4 : _4 };
	}
	public static inline function t5<A,B,C,D,E>(_1:A,_2:B,_3:C,_4:D,_5:E):stx.Tuple5<A,B,C,D,E>{
		return { _1 : _1, _2 : _2, _3 : _3, _4 : _4, _5 : _5 };
	}
}
class T2 {
	public static function map<A,B,C,D>(t:Tuple2<A,B>,fn:Tuple2<A,B> -> Tuple2<C,D>):stx.Tuple2<C,D>{
		return fn(t);
	}
	public static function first<A,B>(t:Tuple2<A,B>):A{
		return t._1;
	}
	public static function second<A,B>(t:Tuple2<A,B>):B{
		return t._2;
	}
	public static function entuple<A,B>(_1:A,_2:B):stx.Tuple2<A,B>{
		return Tuples.t2(_1, _2);
	}
	public static function apply<A,B,C>(args:stx.Tuple2<A,B>,f:A->B->C):C{
		return f(args._1, args._2);
	}
	public static function call<A,B,C>(f:A->B->C,args:stx.Tuple2<A,B>):C{
		return f(args._1, args._2);
	}
	public static function patch<A,B>(t0:stx.Tuple2<A,B>,t1:stx.Tuple2<A,B>):stx.Tuple2<A,B>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		return stx.Tuples.t2(_1, _2);
	}
	public static function toArray<A,B>(v:stx.Tuple2<A,B>):Array<Dynamic>{
		return [v._1, v._2];
	}
	public static function fromArray(arr:Array<Dynamic>):stx.Tuple2<Dynamic,Dynamic>{
		return stx.Tuples.t2(arr[0], arr[1]);
	}
}
class T3 {
	public static function entuple<A,B,C>(a:stx.Tuple2<A,B>,c:C):stx.Tuple3<A,B,C>{
		return stx.Tuples.t3(a._1, a._2 , c);
	}
	public static function apply<A,B,C,D>(args:stx.Tuple3<A,B,C>,f:A->B->C->D):D{
		return f(args._1, args._2, args._3);
	}
	public static function call<A,B,C,D>(f:A->B->C->D,args:stx.Tuple3<A,B,C>):D{
		return f(args._1, args._2, args._3);
	}
	public static function patch<A,B,C>(t0:stx.Tuple3<A,B,C>,t1:stx.Tuple3<A,B,C>):stx.Tuple3<A,B,C>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		var _3 = t1._3 == null ? t0._3 : t1._3;
		return stx.Tuples.t3(_1, _2, _3);
	}
}
class T4 {
	public static function entuple<A,B,C,D>(a:stx.Tuple3<A,B,C>,b:D):stx.Tuple4<A,B,C,D>{
		return stx.Tuples.t4(a._1, a._2, a._3, b);
	}
	public static function call<A,B,C,D,E>(f:A->B->C->D->E,args:stx.Tuple4<A,B,C,D>):E{
		return f(args._1, args._2, args._3, args._4);
	}
	public static function apply<A,B,C,D,E>(args:stx.Tuple4<A,B,C,D>,f:A->B->C->D->E):E{
		return f(args._1, args._2, args._3,args._4);
	}
	public static function patch<A,B,C,D>(t0:stx.Tuple4<A,B,C,D>,t1:stx.Tuple4<A,B,C,D>):stx.Tuple4<A,B,C,D>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		var _3 = t1._3 == null ? t0._3 : t1._3;
		var _4 = t1._4 == null ? t0._4 : t1._4;
		return stx.Tuples.t4(_1, _2, _3, _4);
	}
}
class T5 {
	public static function entuple<A,B,C,D,E>(a:stx.Tuple4<A,B,C,D>,b:E):stx.Tuple5<A,B,C,D,E>{
		return stx.Tuples.t5(a._1, a._2 , a._3, a._4 ,b);
	}
	public static function call<A,B,C,D,E,F>(f:A->B->C->D->E->F,args:stx.Tuple5<A,B,C,D,E>):F{
		return f(args._1, args._2, args._3, args._4, args._5);
	}	
	public static function apply<A,B,C,D,E,F>(args:stx.Tuple5<A,B,C,D,E>,f:A->B->C->D->E->F):F{
		return f(args._1, args._2, args._3, args._4, args._5);
	}
	public static function patch<A,B,C,D,E>(t0:stx.Tuple5<A,B,C,D,E>,t1:stx.Tuple5<A,B,C,D,E>):stx.Tuple5<A,B,C,D,E>{
		var _1 = t1._1 == null ? t0._1 : t1._1;
		var _2 = t1._2 == null ? t0._2 : t1._2;
		var _3 = t1._3 == null ? t0._3 : t1._3;
		var _4 = t1._4 == null ? t0._4 : t1._4;
		var _5 = t1._5 == null ? t0._5 : t1._5;
		return stx.Tuples.t5(_1, _2, _3, _4, _5);
	}
}