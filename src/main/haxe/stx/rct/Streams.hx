package stx.rct;

import Stax.*;

import hx.sch.Process;
import hx.sch.Task;

import stx.Fail;
import Prelude;

import stx.rct.Propagation;
import stx.rct.Stream;

import stx.Anys;
import stx.Functions;
import stx.Compare;

using stx.Arrays;
using stx.Iterables;
using stx.Option;
using stx.ds.List;
using stx.Tuples;
using stx.rct.Pulse;

class Streams {

    private static function toArray<T>(stream:Stream<T>):Array<Stream<T>> return [stream];

    static public function fromAny<T>(any:T):Stream<T> {
      var stream = pure(None);
      Niladics.trampoline(function() stream.dispatch(any), 1)();
      return stream;
    }
    static public function fromFunction<T>(func:Function0<T>):Stream<T> {
      var stream = pure(None);
      Niladics.trampoline(function() stream.dispatch(func()), 1)();
      return stream;
    }
    static public function fromIterable<T>(iterable:Iterable<T>):Stream<T> return fromIterator(iterable.iterator());

    static public function fromIterator<T>(iterator:Iterator<T>):Stream<T> {
      var stream = pure(None);
      Niladics.trampoline(function() {
        while(iterator.hasNext()) {
            stream.dispatch(iterator.next());
          }
      }, 1)();
      return stream;
    }

    static public function bindTo<T>(func:Function1<T, Void>, stream:Stream<T>):Stream<T> {
      each(stream, function(v) func(v));
      return stream;
    }

    static public function calm<T>(stream:Stream<T>, behaviour:Behaviour<Int>):Stream<T> {
      var out:Stream<T> = pure(None);

      var task:Option<Task> = None;
      create(function(pulse:Pulse<T>):Propagation<T> {
        task = Process.stop(task);
        task = Process.start(function() stream.dispatch(pulse.value()), behaviour.value);

        return Negate;
      }, toArray(stream));

      return out;
    }

    static public function constant<T1, T2>(stream:Stream<T1>, value:T2):Stream<T2> {
      return map(stream, function(v) return value);
    }

    @:noUsing
    static public function create<T1, T2>(pulse:Function1<Pulse<T1>, Propagation<T2>>,sources:Array<Stream<T1>>):Stream<T2> {
      var stream = new Stream<T2>(cast pulse);

      sources.each(function (source:Stream<T1>) {
        switch(option(source)){
            case Some(val): val.attach(cast stream);
              case _:
          }
      });

      return stream;
    }

    static public function delay<T>(stream:Stream<T>, behaviour:Behaviour<Int>):Stream<T> {
      var out:Stream<T> = pure(None);

      create(function(pulse:Pulse<T>):Propagation<T> {
        Streams.dispatchWithDelay(out, pulse.value(), behaviour.value);

          return Negate;
      }, toArray(stream));

      return out;
    }

    static public function dispatchWithDelay<T>(stream:Stream<T>, value:T, delay:Int):Stream<T> {
      Process.start(function() stream.dispatch(value), delay);
      return stream;
    }

    static public function dispatchLater<T>(stream:Stream<T>, value:T):Stream<T>{
      Process.start(function() stream.dispatch(value), 1);
      return stream;   
    }
    static public function flatMap<T1, T2>(stream:Stream<T1>, func:Function1<T1, Stream<T2>>):Stream<T2> {
      var previous:Option<Stream<T2>> = None;
      var out = pure(None);

      create(function(pulse:Pulse<T1>):Propagation<T2> {
        previous.each(function(s) s.detach(out));

          previous = option(func(pulse.value()));
          previous.each(function(s) s.attach(out));

          return Negate;
      }, toArray(stream));

      return out;
    }

    static public function each<T>(stream:Stream<T>, func:Function1<T, Void>):Stream<T> {
      create(function(pulse:Pulse<T>):Propagation<T> {
        func(pulse.value());

          return Negate;
      }, toArray(stream));

      return stream;
    }

    static public function pure<T>(sources: Option<Array<Stream<T>>>):Stream<T> {
      return create(function(pulse) return Propagate(pulse), 
                      sources.getOrElse(function() return Arrays.unit())
                      );
    }
    static public function unit<T>():Stream<T> {
      return pure(None);
    }

    static public function map<T1, T2>(stream:Stream<T1>, func:Function1<T1, T2>):Stream<T2> {
      return create(function(pulse:Pulse<T1>):Propagation<T2> return Propagate(pulse.map(func)), 
                      toArray(stream)
                      );
    }

    static public function merge<T>(streams:Array<Stream<T>>):Stream<T> {
      return streams.size() == 0 ? zero():pure(Some(streams));
    }

    static public function once<T>(value:T):Stream<T> {
      var sent = false;
      var stream = create(function(pulse:Pulse<T>) {
        return if (sent) {
            fail(IllegalOperationFail("Received a value that wasn't expected " + pulse.value));
              Negate;
          } else {
            sent = true;
              Propagate(pulse);
          }
      }, Arrays.unit());

      stream.dispatch(value);

      return stream;
    }

    static public function random(time:Behaviour<Float>):Stream<Float> {
      var timerStream:Stream<Float> = timer(time);

      var mapStream:Stream<Float> = map(timerStream, function(value) return Math.random());
      mapStream.whenFinishedDo(function():Void timerStream.finish());

      return mapStream;
    }

    static public function sine(time:Behaviour<Float>, ?resolution:Null<Int>):Stream<Float> {
      var resolution:Null<Int> = resolution == null ? 100:resolution;
      var angle:Float = Math.PI * 2 / resolution;

      var timerStream:Stream<Float> = timer(time);

      var mapStream:Stream<Float> = map(timerStream, function(value) return Math.sin(Process.stamp() + angle));
      mapStream.whenFinishedDo(function():Void timerStream.finish());

      return mapStream;
    }

    static public function shift<T>(stream:Stream<T>, value:Int):Stream<T> {
      var queue:Array<T> = [];

      return create(function(pulse:Pulse<T>):Propagation<T> {
        queue.push(pulse.value());

          return (queue.length <= value) ? Negate:Propagate(pulse.withValue(queue.shift()));
      }, toArray(stream));
    }

    static public function startsWith<T>(stream:Stream<T>, value:T):Behaviour<T> {
      return new Behaviour(stream, value, function(pulse:Pulse<T>):Propagation<T> return Propagate(pulse));
    }

    static public function steps<T>(stream:Stream<T>):Stream<T> {
      var time = -1.0;

      return create(function(pulse:Pulse<T>):Propagation<T> {
        return if(pulse.time() != time) {
            time = pulse.time();

              Propagate(pulse);
          } else Negate;
      }, toArray(stream));
    }

    static public function timer(time:Behaviour<Float>):Stream<Float> {
      var stream:Stream<Float> = pure(None);
      var task:Option<Task> = None;

      stream.whenFinishedDo(function() task = Process.stop(task));

      var pulser:Function0<Void> = null;
      pulser = function() {
        stream.dispatch(Process.stamp());

          task = Process.stop(task);

          if(!stream.weakRef()) task = Process.start(pulser, time.value);
      };

      task = Process.start(pulser, time.value);

      return stream;
    }

    static public function values<T>(stream:Stream<T>):Array<T> {
      var list:List<T> = List.create();

      var collection = [];

      each(stream, function(value:T):Void collection.push(value));

      return collection;
    }

    static public function zero<T>():Stream<T> {
      return create(function(pulse:Pulse<T>):Propagation<T> {
            fail(IllegalOperationFail("Received a value that wasn't expected " + pulse.value()));
              return Negate;
          }, Arrays.unit());
    }

    static public function zip<T1, T2>(stream0:Stream<T1>, stream1:Stream<T2>):Stream<Tuple2<T1, T2>> {
      return zipWith(stream0, stream1, function (a, b) {
        var tuple:Tuple2<T1, T2> = tuple2(a, b);
          return tuple;
      });
    }

    static public function zipAny<T1, T2>(stream0:Stream<T1>, stream1:Stream<T2>):Stream<Tuple2<T1, T2>> {
      return zipWith(stream0, stream1, function (a, b) {
        var tuple:Tuple2<T1, T2> = tuple2(a, b);
          return tuple;
      }, function (t0, t1) return true);
    }

    static public function zipWith<T1, T2, R>(stream0:Stream<T1>,
                                              stream1:Stream<T2>,
                                              func:Function2<T1, T2, R>,
                                              ?guard:Float -> Float -> Bool = null
                                              ):Stream<R> {
      var time = -1.0;
      var value:Option<T1> = None;

      var guarded = !Anys.toBool(guard) ? function (t0, t1) return t0 == t1:guard;

      create(function(pulse:Pulse<T1>):Propagation<T1> {
        time = pulse.time();
          value = option(pulse.value());

          return Negate;
      }, toArray(stream0));

      return create(function(pulse:Pulse<T2>):Propagation<R> {
        return if (guarded(time, pulse.time())) Propagate(pulse.withValue(func(value.get(), pulse.value())));
          else Negate;
      }, toArray(stream1));
    }
}
