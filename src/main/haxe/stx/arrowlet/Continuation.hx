package stx.arrowlet;

import Prelude;
using stx.Arrowlet;

@:note("#0b1kn00b, Doesn't run unless cont filled in, how to fix?")
abstract Continuation<A,B>(Arrowlet<A,B>){
	public function new(cps:A->stx.Continuation<Void,B>){
		this = new Arrowlet(
			inline function(?i:A, cont: B->Void):Void{
			cps(i).apply(cont);
		});
	}
	public function apply(?i){
		return this.apply(i);
	}
}