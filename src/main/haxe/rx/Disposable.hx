package rx;

import stx.Prelude;
import rx.ifs.Disposable in IDisposable;
import rx.disposable.AnonymousDisposable;

abstract Disposable(IDisposable) from IDisposable to IDisposable{
  @:noUsing static public function unit():Disposable{
    return function(){}
  }
  public function new(v){
    this = v;
  }
  public function dispose(){
    this.dispose();
  }
  @:from static public function fromCodeBlock(d:CodeBlock):Disposable{
    return new AnonymousDisposable(d);
  }
}