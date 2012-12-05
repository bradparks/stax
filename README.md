h1. Stax v0.1

Stax is the functional programming stack for Haxe designed for developers who prefer declarative programming and productivity over program size and speed.

The standard library that comes with HaXe is pragmatically designed. The library is small, and there are only a few abstractions. As a result, the HaXe standard library is an excellent choice when the most important features are program size and performance.

Stax lies on the other end of the spectrum. Stax emphasizes functional concepts, generic abstractions, productivity, composability, and testability. When these features are most important, Stax makes an excellent choice.

h2. Getting Starting with Stax

Stax's source can be included via

<code>-cp {stax_dir}/src/main/haxe</code>

Stax makes heavy use of haxes 'using' instruction to allow method chaining.

<pre><code>using Stax//imports some essential functions
class Test{
 public function main(){
  var str = ['hello','world']
   .map(
    function(str){ 
     var first_letter 	= str.substr(0,1).toUpperCase();
     var rest 					= str.substr(1);
     return first_letter + rest;
    }
   ).foldl(
     '',
     function(init,str){
      return init + ' ' + str;
     }
   );
   trace( str );
  }
}</code></pre>

In addition you can find:

 * *Tuples*, of arity 1 - 5, which are ideal containers for a bundle of times when a class would be too heavyweight. <code>var t = Tuple2.create(23, "foo");</code>
 * *Option*, which eliminates the need for <code>null</code> and makes code much safer. <code>var o = Some(23); var n = None;</code>
 * *Future*, which makes it easy to chain asynchronous operations.
 * *Conversions*, which enable you to convert between primitives. <code>var float = 12.toFloat();</code>
 * *Array enhancements*, which allow you to write functional code with arrays. <code>[123, 24].map(function(i) return i * 2;);</code>
 * *Function enhancements*, (_stx.Functions_) which allow you to manipulate functions like first-class values. <code>var h = f.compose(g); h.curry()(2)(3);</code>
 * *Basic typeclasses*, which allow you to hash, order, and show all built-in HaXe primitives. <code>var hasher = Int.HasherF(); var hash = hasher.hash(3243);</code>
 * A unified collections library, including immutable, fully-featured versions of Set, Map, and List.
 * JSON encoding, decoding, and transformation;
 * Functional reactive library;
 * Logging;
 * Configuration;
 * IO;
 * And more!

h2. Stax Collections Library

The Stax collections library, contained in the package _haxe.ds_, includes three types of collections:

 * Lists (_stx.ds.List_), which represent ordered sequences of elements;
 * Sets (_stx.ds.Set_), which represent unordered collections of unique elements;
 * Maps (_stx.ds.Map_), which represent partial functions from one type (the key) to another (the value).
 
All collection are immutable, support arbitrary element types, and are unifed via a <code>Collection</code> interface, which provides access to functionality that is universally available across all kinds of collections (<code>add()</code>, <code>addAll()</code>, <code>remove()</code>, <code>removeAll()</code>, <code>size</code>,  <code>contains()</code>, and <code>iterator()</code>).

Collections implement the <code>Foldable</code> interface, so it's possible to gain access to more advanced functionality by using the <code>Foldable</code> extensions:

<pre><code>using stx.functional.FoldableExtensions;</code></pre>

Collections can be created through a static factory method on the collection classes named _create_. This function typically requires access to equal, hash, or ordering type classes for the specified element type(s).

h2. Stax JavaScript

Stax has a fully-typed representation of the vast majority of the DOM, including the latest W3C standards and widely supported non-standards.

You can import this representation and helper functions with the following two lines of code:

<pre><code>import stx.js.Env;
import stx.js.Dom;</code></pre>

The first line imports a <code>Env</code> class that provides access to top-level JavaScript objects and functions.  The second line imports the external declarations that inform HaXe how every element in the DOM is typed.