package funk.actors;

import funk.Funk;
import funk.actors.ActorContext;

using funk.futures.Promise;
using funk.types.AnyRef;
using funk.types.Option;

class Actor implements ActorRef {

    private var _context : ActorContext;

    private var _self : ActorRef;

    public function new() {
        var context = ActorContextInjector.currentContext();
        if (context.isEmpty()) Funk.error(ActorError("No Context Error"));

        _context = context.get();
        _self = _context.self();
    }

    public function receive(value : AnyRef) : Void {

    }

    public function actorOf(props : Props, name : String) : ActorRef return _self.actorOf(props, name);

    public function actorFor(name : String) : ActorRef return _self.actorFor(name);

    public function ask(value : AnyRef, sender : ActorRef) : Promise<AnyRef> return _self.ask(value, sender);

    public function send(value : AnyRef, sender : ActorRef) : Void _self.send(value, sender);

    public function path() : ActorPath return _self.path();

    public function name() : String return path().name();
}
