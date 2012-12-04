package stx.error;

using Std;

import haxe.PosInfos;

class ErrorStack<T> extends DataError<Iterable<T>>{
	@:noUsing
	static public function create<A>(data:Iterable<A>, ?msg:String, ?pos:PosInfos){
		return new ErrorStack(data,msg,pos);
	}
	@noUsing
	static public function build<A>(?msg:String,?pos:PosInfos){
		return 
			function(iterable:Iterable<A>){
				return create(iterable,msg,pos);
			}
	}
	public function new(data:Iterable<T>,msg:String = 'Stack of Errors: ',?pos:PosInfos){
		super(data,'$msg: $data'.format(),pos);
	}
}