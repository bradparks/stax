/*
 HaXe library written by John A. De Goes <john@socialmedia.com>

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the
 distribution.

 THIS SOFTWARE IS PROVIDED BY SOCIAL MEDIA NETWORKS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SOCIAL MEDIA NETWORKS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package stx.math.tween;

import Prelude;
using stx.ds.Set;
using stx.ds.Map;
using stx.Option;
using stx.Tuples;

using stx.ds.Foldables;

typedef Tweener = Float -> Dynamic<Float>

class Tween {
  public static function linear(state1: Dynamic<Float>, state2: Dynamic<Float>, ?def = 0.0): Tweener {
    var combinedFields = Reflect.fields(state1).toSet().append(Reflect.fields(state2));
    
    var data = combinedFields.map(function(name: String): Tuple2<String, {start: Float, delta: Float}> {
      var start: Float = Options.create(Reflect.field(state1, name)).getOrElseC(def);
      var end:   Float = Options.create(Reflect.field(state2, name)).getOrElseC(def);
      
      return tuple2(name,{
        start:  start,
        delta:  end - start
      });
    }).toMap();
    
    return function(t: Float): Dynamic<Float> {
      return data.foldLeft({}, function(r, tuple) {
        var name  = tuple.fst();
        var start = tuple.snd().start;
        var delta = tuple.snd().delta;
        
        Reflect.setField(r, name, start + t * delta);
        
        return r;
      });
    }
  }
}