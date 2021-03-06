/*
 HaXe JSON library written by Spencer Tipping <spencer@socialmedia.com>
 Contributed by Social Media Networks

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
package stx.io.json;

import stx.Tuples;
using Prelude;
using stx.Tuples;

enum JValue {
  JNull;
  JBool(v: Bool);
  JNumber(v: Float);
  JString(v: String);
  JArray(v: Array<JValue>);
  JObject(v: Array<JValue>);
  JField(k: String, v: JValue);
}
class JValues{
	  static public function fold<T>(v: JValue, initial: T, f: T -> JValue -> T): T {
    var cur = initial;
    
    map(v, function(j) { cur = f(cur, j); return j; });
    
    return cur;
  }

  static public function path(v: JValue, s: String): JValue {
    var ss = s.split ("/"), c = v;
    for (x in ss.iterator()) if (x.length > 0) c = get (c, x);
    return c;
  }

  static public function map (v: JValue, f: JValue -> JValue): JValue {
    switch (v) {
      case JArray(xs):   return f(JArray  (xs.map (function (x) {return map (x, f);})));
      case JField(k, v): return f(JField  (k, map (v, f)));
      case JObject(fs):  return f(JObject (fs.map (function (field) { return map(field, f); })));
      
      default: return f(v);
    }
  }
  
  static public function getOption(v: JValue, k: String): Option<JValue> {
    switch(v) {
      case JObject(_):
        var hash = extractMap(v);
        
        return if (hash.exists(k)) Some(hash.get(k));
               else None;
      
      default: return None;
    }
  }
  static public function get(v: JValue, k: String): JValue {
    return switch (getOption(v, k)) {
      case Some(v): v;      
      case None:    except()("Expected to find field " + k + " in " + v);
    }
  }
  static public function getOrElse(v: JValue, k: String, def: Thunk<JValue>) {
    return switch (getOption(v, k)) {
      case Some(v): v;
      case None:    def();
    }
  }
  static public function extractString(v: JValue): String {
    return switch (v) {
      case JString(s): s;

      default: except()("Expected JString but found: " + v);
    }
  }
  static public function extractNumber(v: JValue): Float {
    return switch (v) {
      case JNumber(n): n;
      
      default: except()("Expected JNumber but found: " + v);
    }
  }
  static public function extractBool(v: JValue): Bool {
    return switch (v) {
      case JBool (b): b;
      
      default: except()("Expected JBool but found: " + v);
    }
  }
  static public function extractKey(v: JValue): String {
    return extractField(v).fst();
  }
  static public function extractValue(v: JValue): JValue {
    return extractField(v).snd();
  }
  static public function extractField(v: JValue): Tuple2<String, JValue> {
    return switch (v) {
      case JField (k, v): tuple2(k, v);
      default						: except()("Expected JField but found: " + v);
    }
  }  
  static public function extractMap(v: JValue): Map<String,JValue> {
    return switch (v) {
      case JObject(xs): 
        var hash = new Map<String,JValue>();
        
        for (x in xs) {
          var field = extractField(x);
          
          hash.set(field.fst(), field.snd());
        }
        
        hash;
      
      default: except()("Expected JObject but found: " + v);
    }
  }
  static public function extractFields(v: JValue): Array<Tuple2<String, JValue>> {
    return extractArray(v).flatMap(function(j) {
      return switch(j) {
        case JField(k, v): [tuple2(k, v)];
        
        default: [];
      }
    });
  }
  static public function extractArray(v: JValue): Array<JValue> {
    return switch (v) {
      case JArray (xs): xs;
      
      case JObject (xs): xs;
      
      default: except()("Expected JArray or JObject but found: " + v);
    }
  }
}