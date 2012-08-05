package stx;

/**
 * ...
 * @author 0b1kn00b
 */
import stx.Prelude;

class Bools {
  static public function toInt(v: Bool): Float { return if (v) 1 else 0; }
  
	/**
	 * Produces the result of 'f' if 'v' is true.
	 */
  static public function ifTrue<T>(v: Bool, f: Thunk<T>): Option<T> {
    return if (v) Some(f()) else None;
  }
	/**
	 * Produces the result of 'f' if 'v' is false.
	 */  
  static public function ifFalse<T>(v: Bool, f: Thunk<T>): Option<T> {
    return if (!v) Some(f()) else None;
  }
  /**
	 * Produces the result of 'f1' if 'v' is true, 'f2' otherwise.
	 */
  static public function ifElse<T>(v: Bool, f1: Thunk<T>, f2: Thunk<T>): T {
    return if (v) f1() else f2();
  }  
	
  static public function compare(v1 : Bool, v2 : Bool) : Int {
    return if (!v1 && v2) -1 else if (v1 && !v2) 1 else 0;   
  }

  static public function equals(v1 : Bool, v2 : Bool) : Bool {
    return v1 == v2;   
  }

  static public function and(v1 : Bool, v2 : Bool) : Bool{
    return v1 && v2;
  }
  static public function or(v1:Bool,v2:Bool):Bool{
    return v1 || v2;
  }
  static public function not(v:Bool){
    return !v;
  }
}