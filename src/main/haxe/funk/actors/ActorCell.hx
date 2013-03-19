package funk.actors;

import funk.Funk;

using funk.actors.dispatch.Envelope;
using funk.actors.dispatch.Mailbox;
using funk.actors.dispatch.MessageDispatcher;
using funk.actors.ActorSystem;
using funk.actors.ActorRef;
using funk.types.Any;
using funk.types.Option;
using funk.collections.immutable.List;

typedef ActorContext = {

    function actorOf(props : Props, name : String) : ActorRef;

    function child(name : String) : Option<ActorRef>;

    function children() : List<ActorRef>;

    function parent() : ActorRef;

    function props() : Props;

    function self() : ActorRef;

    function sender() : ActorRef;

    function system() : ActorSystem;
};

class ActorContextInjector {

    private static var _contexts : List<ActorContext> = Nil;

    private static var _currentContext : Option<ActorContext> = None;

    public static function pushContext(context : ActorContext) : Void {
        _currentContext = Some(context);
        _contexts = _contexts.prepend(context);
    }

    public static function popContext() : Void {
        _contexts = _contexts.tail();
        _currentContext = _contexts.headOption();
    }

    public static function currentContext() : Option<ActorContext> return _currentContext;
}

class ActorCell {

    private var _self : ActorRef;

    private var _mailbox : Mailbox;

    private var _dispatcher : MessageDispatcher;

    private var _system : ActorSystem;

    private var _childrenRefs : List<ActorRef>;

    private var _currentMessage : Envelope;

    private var _props : Props;

    public function new(system : ActorSystem, self : InternalActorRef, props : Props) {
        _system = system;
        _self = self;
        _props = props;

        _dispatcher = _system.dispatchers().lookup(_props.dispatcher());
    }

    public function start() {
        _mailbox = _dispatcher.createMailbox(this);
        _mallbox.systemEnqueue(self(), Create);

        _parent.sendSystemMessage(Supervise(self()));

        _dispatcher.attach(this);
    }

    public function suspend() : Void _dispatcher.systemDispatch(this, Suspend);

    public function resume() : Void _dispatcher.systemDispatch(this, Resume);

    public function stop() : Void _dispatcher.systemDispatch(this, Stop);

    public function children() : List<ActorRef> return _childrenRefs.children;

    public function tell(message : EnumValue, sender : ActorRef) : Void {
        var ref = AnyTypes.toBool(sender)? sender : _system.deadLetters();
        _dispatcher.dispatch(this, Envelope(message, ref));
    }

    public function sender() : ActorRef {
        return switch(_currentMessage) {
            case Envelope(msg, sender) if (AnyTypes.toBool(sender)): sender;
            case _: _system.deadLetters();
        }
    }

    public function self() : ActorRef return _self;

    public function guardian() : InternalActorRef return _self;

    public function lookupRoot() : InternalActorRef return _self;

    public function system() : ActorSystem return _system;

    public function provider() : ActorRefProvider return _system.provider();

    public function dispatcher() : MessageDispatcher return _dispatcher;

    public function newActor() : Actor {
        ActorContextInjector.pushContext(this);

        try {
            var instance = props.creator();

            if (AnyTypes.toBool(instance)) {
                Funk.Errors(ActorError("Actor instance passed to actorOf can't be 'null'"));
            }
        } catch(e : Dynamic) {
            throw e;
        }

        ActorContextInjector.popContext();
    }

    public function systemInvoke(message : SystemMessage) {
        switch(message) {
            case Create: systemCreate();
            case Recreate(cause): systemRecreate(cause);
            case Link(subject): systemLink(subject);
            case Unlink(subject): systemUnlink(subject);
            case Suspend: systemSuspend();
            case Resume: systemResume();
            case Terminated: systemTerminated();
            case Supervise(child): systemSupervise(child);
            case ChildTerminated(child): handChildTerminated(child);
        }
    }

    public function invoke(message : Envelope) {
        _currentMessage = message;
    }

    private function systemCreate() : Void {
        try {
            _actor = newActor();
            _actor.preStart();
        } catch (e : Dynamic) {
            _parent.tell(Failed(self, "exception during creation"));
        }
    }

    private function systemRecreate(cause : Errors) : Void {
        switch(cause) {
            case _: // TODO (Simon) : Work out if we can reboot the actor.
        }
    }

    private function systemSuspend() : Void if(isNormal()) _dispatcher.suspend(this);

    private function systemResume() : Void if(isNormal()) _dispatcher.resume(this);

    private function systemLink(subject : ActorRef) : Void {
        if (!isTerminating()) {
            // TODO (Simon) : Workout if we need to link
        }
    }

    private function systemUnlink(subject : ActorRef) : Void {
        if (!isTerminating()) {
            // TODO (Simon) : Workout if we need to link
        }
    }

    private function systemTerminated() : Void {
        children().foreach(function(value) value.stop());

        _dispatcher.detach(this);
        parent().sendSystemMessage(ChildTerminated(self()));
        _actor = null;
    }

    private function systemSupervise(child : ActorRef) : Void {
        var opt = _childrenRefs.find(function(value) return value == child);
        if (opt.isEmpty()) {
            _childrenRefs = _childrenRefs.prepend(child);
        }
    }

    private function handChildTerminated(child : ActorRef) : Void {
        _childrenRefs = _childrenRefs.filterNot(function(value) return value == child);
    }

    private function childrenRefs() : List<ActorRef> return _childrenRefs;
}
