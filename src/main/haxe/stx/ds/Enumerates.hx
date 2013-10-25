package stx.ds;

import hx.ds.ifs.Enumerator;

import stx.Iterators;

abstract Enumerates<T>(Enumerator<T>) from Enumerator<T> to Enumerator<T>{
  public function new(v){
    this = v;
  }
  public function map<U>(fn:T->U):Enumerator<U>{
    return Iterators.map(this,fn);
  }
  public function flatMap<U>(fn:T->Enumerator<U>):Enumerator<U>{
    return Iterators.flatMap(this,fn);
  }
  public function foldl<Z>(memo:Z,fn:Z->T->Z):Z{
    return Iterators.foldl(this,memo,fn);
  }
  public function foldr<Z>(memo:Z,fn:T->Z->Z):Z{
    return Iterators.foldr(this,memo,fn);
  }
  public function toArray():Array<T>{
    return Iterators.toArray(this);
  }
  public function size():Int{
    return Iterators.size(this);
  }
}