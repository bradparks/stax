package stx;

/**
 * ...
 * @author 0b1kn00b
 */
														using stx.Maths;
class Maths {	
	/**
	 * Produces either a zero or a one randomly, influenced by weight
	 * @return
	 */
	public static inline function rndOne(?weight : Float = 0.5 ):Int {
		return Std.int ( ( Math.random() - weight )  );
	}
	/**
	 * Produces the radians of a given angle in degrees.
	 * @param	v
	 */
	public static inline function radians(v:Float) {
		return v * ( Math.PI / 180 );
	}
	/**
	 * Produces the degrees of a given angle in radians.
	 * @param	v
	 */
	public static inline function degrees(v:Float) {
		return v * ( 180 / Math.PI ) ;
	}
}
class Ints {
	/**
	 * Produces whichever is the greater.
	 * @param	v1
	 * @param	v2
	 * @return
	 */
	public static inline function max(v1: Int, v2: Int): Int { return if (v2 > v1) v2; else v1; }
	/**
	 * Produces whichever is the lesser.
	 * @param	v1
	 * @param	v2
	 * @return
	 */
  public static function min(v1: Int, v2: Int): Int { return if (v2 < v1) v2; else v1; }
	/**
	 * Produces a Bool if 'v' == 0;
	 * @param	v
	 * @return
	 */
  public static function toBool(v: Int): Bool { return if (v == 0) false else true; }
	/**
	 * Coerces an Int to a Float.
	 * @param	v
	 * @return
	 */
  public static function toFloat(v: Int): Float { return v; }
    
	/**
	 * Produces -1 if 'v1' is smaller, 1 if 'v1' is greater, or 0 if 'v1' == 'v2'
	 * @param	v1
	 * @param	v2
	 * @return
	 */
  public static function compare(v1: Int, v2: Int) : Int {
    return if (v1 < v2) -1 else if (v1 > v2) 1 else 0;
  }
	/**
	 * Produces true if 'v1' == 'v2'
	 * @param	v1
	 * @param	v2
	 * @return
	 */
  public static function equals(v1: Int, v2: Int) : Bool {
    return v1 == v2;
  }
	/**
	 * Produces true if 'value' is odd, false otherwise.
	 * @param	value
	 */
	public static inline function isOdd(value:Int) {
		return value%2 == 0 ? false : true;
	}
	/**
	 * Produces true if 'value' is even, false otherwise.
	 * @param	value
	 */
	public static inline function isEven(value:Int){
		return (isOdd(value) == false);
	}
	/**
	 * Produces true if 'n' is an integer, false otherwise.
	 * @param	n
	 */
	public static inline function isInteger(n:Float){
		return (n%1 == 0);
	}
	/**
	 * Produces true if 'n' is a natural number, false otherwise.
	 * @param	n
	 */
	public static inline function isNatural(n:Int){
		return ((n > 0) && (n%1 == 0));
	}
	/**
	 * Produces true if 'n' is a prime number, false otherwise.
	 * @param	n
	 */
	public static inline function isPrime(n:Int){
		if (n == 1) return false;
		if (n == 2) return false;
		if (n%2== 0) return false;
		var iter = new IntIter(3,Math.ceil(Math.sqrt(n))+1);
		for (i in iter){
			if (n % 1 == 0){
				return false;
			}
			i++;
		}
		return true;
	}
	/**
	 * Produces the factorial of 'n'.
	 * @param	n
	 */
	public static function factorial(n:Int){
		if (!isNatural(n)){
			throw "function factorial requires natural number as input";
		}
		if (n == 0){
			return 1;
		}
		var i = n-1;
		while(i>0){
			n = n*i;
			i--;
		}
		return n;
	}
	public static inline function divisors(n:Int){
		var r = new Array<Int>();
		var iter = new IntIter(1,Math.ceil((n/2)+1));
		for (i in iter){
			if (n % i == 0){
				r.push(i);
			}
		}
		if (n!=0){r.push(n);}
		return r;
	}
	public static inline function clamp(n:Int, min : Int , max : Int  ) {
		if (n > max) {
			n = max;
		}else if ( n < min) {
			n = min;
		}
		return n;
	}
	/**
	 * Produces half of 'n'.
	 * @param	n
	 */
	public static inline function half(n:Int) {
		return n / 2;
	}
	/**
	 * Produces the sum of the elements in 'xs'.
	 * @param	xs
	 * @return
	 */
	public static inline function sum(xs:Iterable<Int>):Int {
		var o = 0;
		for ( val in xs ) {
			o += val;
		}
		return o;
	}
}
class Floats {
	/**
	 * Produces the difference between 'n1' and 'n0'.
	 * @param	n0
	 * @param	n1
	 */
	public static inline function delta(n0:Float,n1:Float){
		return n1 - n0;
	}
	/**
	 * @param	v
	 * @param	n0
	 * @param	n1
	 */
	public static inline function normalize(v:Float,n0:Float,n1:Float){
		return (v - n0) / delta(n0, n1);
	}
	public static inline function interpolate(v:Float,n0:Float,n1:Float){
		return n0 + ( delta(n0, n1) ) * v;
	}
	public static inline function map(v:Float,min0:Float,max0:Float,min1:Float,max1:Float){
		return interpolate(normalize(v, min0, max0), min1, max1);
	}
	public static inline function round(n:Float,c:Int = 1):Int{
		var r = Math.pow(10, c);
		return (Math.round(n * r) / r).int();
	}
	public static inline function ceil(n:Float,c:Int = 1):Int{
		var r = Math.pow(10, c);
		return (Math.ceil(n * r) / r).int();
	}
	public static inline function floor(n:Float,c:Int = 1):Int{
		var r = Math.pow(10, c);
		return (Math.floor(n * r) / r).int();
	}
	public static inline function clamp(n:Float, min : Float , max : Float) {
		if (n > max) { n = max; }else if (n < min) { n = min; }
		return n;
	}
	public static inline function sgn(n:Float) {
		return (n == 0 ? 0 : Math.abs(n) / n);
	}
  public static function max(v1: Float, v2: Float): Float { return if (v2 > v1) v2; else v1; }
  public static function min(v1: Float, v2: Float): Float { return if (v2 < v1) v2; else v1; }
  public static function int(v: Float): Int { return Std.int(v); } 
  public static function compare(v1: Float, v2: Float) {   
    return if (v1 < v2) -1 else if (v1 > v2) 1 else 0;
  }
  public static function equals(v1: Float, v2: Float) {
    return v1 == v2;
  }
  public static function toString(v: Float): String {
    return "" + v;
  }
}