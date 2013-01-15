package funk.ioc;

import funk.Funk;
import funk.types.Option;
import funk.types.Provider;

using funk.types.extensions.Bools;
using funk.types.extensions.Reflects;

enum BindingType<T> {
    To(type : Class<T>);
    Instance(instance : T);
    Provider(provider : Class<Provider<T>>);
}

@:final
class Binding<T> {

    private var _module : Module;

    private var _boundTo : Option<Class<T>>;

    private var _bindingType : BindingType<T>;

    private var _singletonScope : Bool;

    private var _evaluated : Bool;

    private var _value : T;

    public function new(module : Module, boundTo : Option<Class<T>>) {
        if (null == module) {
            Funk.error(ArgumentError());
        }

        _module = module;
        _boundTo = boundTo;

        _evaluated = false;
        _singletonScope = false;
    }

    public function boundTo() : Option<Class<T>> {
        return _boundTo;
    }

    public function to(type : Class<T>) : Scope {
        if (null == type) {
            Funk.error(ArgumentError());
        }

        _evaluated = false;
        _bindingType = To(type);
        return this;
    }

    public function toInstance(instance : T) : Scope {
        if (null == instance) {
            Funk.error(ArgumentError());
        }

        _evaluated = false;
        _bindingType = Instance(instance);
        return this;
    }

    public function toProvider(provider : Class<Provider<T>>) : Scope {
        if (null == provider) {
            Funk.error(ArgumentError());
        }

        _evaluated = false;
        _bindingType = Provider(provider);
        return this;
    }

    public function getInstance() : T {
        return if(_singletonScope) {
            if(!_evaluated) {
                _value = solve();
                _evaluated = true;
            }

            // Passes back the instance.
            _value;
        } else {
            solve();
        }
    }

    public function asSingleton() : Void {
        _singletonScope = true;
    }

    private function solve() : T {
        return switch(_bindingType) {
            case To(type):
                switch (_module.getInstance(type)) {
                    case Some(v): v;
                    case None: 
                        // Try and bind to the original type, else bind to the type.
                        switch(_boundTo){
                            case Some(v): Reflects.createEmptyInstance(v);
                            case None: Reflects.createEmptyInstance(type);
                            default: 
                                Funk.error(BindingError("Invalid To Bind"));
                        }
                }
            case Instance(instance): instance;
            case Provider(provider):
                switch (_module.getInstance(provider)) {
                    case Some(v):
                        if (Reflects.hasMethod(v, 'get')) {
                            v.get();
                        } else {
                            Funk.error(BindingError("Invalid Provider"));
                        }
                    case None:
                        Funk.error(BindingError("Provider not found in module."));
                }
            default: 
                Funk.error(BindingError("Invalid Bind"));
        }
    }
}
