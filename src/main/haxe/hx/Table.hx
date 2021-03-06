package hx;

import Prelude;

using stx.Option;
using stx.Tuples;
/*
abstract Table<T>(Dynamic<T>) from Dynamic<T> to Dynamic<T>{
  public function new(?v){
    this = Options.orDefault(v,{});
  }
  public function set(k: String, v: T): Table<T> {
    Reflect.setField(this, k, v);
    
    return this;
  }
  public function patch(fields: Iterable<Tuple2<String, T>>): Table<T> {
    for (field in fields) {
      Reflect.setField(this, field.fst(), field.snd());
    }
    return this;
  }
  public function extract(?names: Iterable<String>, def: T): Array<T> {
    var result: Array<T> = [];
    
    for (field in names) {
      var value = Reflect.field(this, field);
      
      result.push(if (value != null) cast value else def);
    }
    
    return result;
  }
  public function replace(d2: Table<T>, def: T):Table<T> {
    var names: Array<String> = Reflect.fields(d2);
    
    var oldValues = extractValues(d1, names, def);
    
    extendWith(cast d1, cast d2);
    
    return names.zip(oldValues).foldLeft({}, function(o, t) {
      Reflect.setField(o, t.fst(), t.snd());
      
      return o;
    });
  }
  public function has(fields:Iterable<String>):Bool{
    fields      =
    var vals    = extract(d);
    var names   = vals.map( Pair.fst );

    return fields.all(
      function(x){
        return names.any( function(y) return x == y );
      }
    );
  }
  public function missing(fields:Array<String>):Option<String>{
    return fields.foldLeft(
      None,
      function(memo,next){
        return switch (memo){
          case None     : Reflect.hasField(this,next) ? None : Some(next) ;
          case Some(v)  : Some(v);
        }
      }
    );
  }
  public function mapValues<S>(f: T -> S): Table<S> {
    return patch({}, Reflect.fields(this).map(function(name) {
      return tuple2(name,f(Reflect.field(this, name)));
    }));
  }
  public function defined(fields:Array<String>):Bool{
    return extract(this,fields,null)
      .all( function(x) return x != null );
  }
  public function iterator(): Iterator<String> {
    return Reflect.fields(this).iterator();
  }
}*/