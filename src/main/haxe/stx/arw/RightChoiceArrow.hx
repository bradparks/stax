package stx.arw;

import stx.Tuples.*;
import stx.Prelude;
using stx.arw.Arrows;

typedef ArrowRightChoice<B,C,D> = Arrow<Either<D,B>,Either<D,C>>;

abstract RightChoiceArrow<B,C,D>(ArrowRightChoice<B,C,D>) from ArrowRightChoice<B,C,D> to ArrowRightChoice<B,C,D>{
	public function new(a:Arrow<B,C>){
		this = new Arrow(
			function (?i:Either<D,B>, cont : Function1<Either<D,C>, Void>){
				switch (i) {
					case Right(v) 	:
						new ApplicationArrow().withInput( tuple2(a,v) ,
							function(x){
								cont( Right(x) );
							}
						);
					case Left(v) :
						cont( Left(v) );
				}
			}
		);
	}
	@:to public inline function asArrow():Arrow<Either<D,B>,Either<D,C>>{
		return this;
	}
}