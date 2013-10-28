package hx.rct;

import stx.Prelude;

class Notifier {
  private var handlers : Array<CodeBlock>;

  public function new() {
    handlers = new Array();
  }
  public function add(h : CodeBlock) : CodeBlock {
    handlers.push(h);
    return h;
  }
  public function rem(h : CodeBlock) : CodeBlock {
    for(i in 0...handlers.length)
      if(Reflect.compareMethods(handlers[i], h))
        return handlers.splice(i, 1)[0];
    return null;
  }
  public function clear() {
    handlers = new Array();
  }
  public function dispatch() {
    try {
      // prevents problems with self removing events
      var list = handlers.copy();
      for( l in list )
        l();
      return true;
    } catch( exc : EventException ) {
      return false;
    }
  }
  public function has() {
    return handlers.length > 0;
  }
  public static function stop() {
    throw StopPropagation;
  }
}