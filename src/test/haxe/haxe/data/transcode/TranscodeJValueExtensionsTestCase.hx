package haxe.data.transcode;

import haxe.Stack;
import Prelude;

import stax.plus.Equal;

import Type;
import stax.Tuples;
import Prelude;
import haxe.test.TestCase;
import haxe.text.json.JValue;
import haxe.data.collections.Set;
import haxe.data.collections.Map;
import haxe.data.collections.List;
import haxe.data.transcode.TranscodeJValue;
import haxe.data.transcode.TranscodeJValueExtensions;



typedef UnionOfSimpleFeedTypes = Dynamic

class TranscodeJValueExtensionsTestCase extends TestCase {
  public function new() {
    super();
  }

  public function testBool() {
    doTest([true, false]);
  }

  public function testInt() {
    doTest([-1234, 9231]);
  }

  public function testFloat() {
    doTest([0.25, 0.5]);
  }

  public function testString() {
    doTest(["boo", "baz"]);
  }

  public function testDate() {
    doTest([Date.now(), Date.fromTime(0.0)]);
  }

  public function testOption() {
    var a: Array<Option<Int>> = [Some(123), None];

    doTest(a, [TranscodeJValue.getExtractorFor(TInt)]);
  }

  public function testTuple2() {
    var a = [Tuples.t2(123, "foo"), Tuples.t2(0, "bar")];

    doTest(a, [TranscodeJValue.getExtractorFor(TInt), TranscodeJValue.getExtractorFor(TClass(String))]);
  }

  public function testTuple3() {
    var a = [Tuples.t3(123, "foo", true), Tuples.t3(0, "bar", false)];

    doTest(a, [TranscodeJValue.getExtractorFor(TInt), TranscodeJValue.getExtractorFor(TClass(String)), TranscodeJValue.getExtractorFor(TBool)]);

  }

  public function testTuple4() {
    var a = [Tuples.t4(123, "foo", true, 0.25), Tuples.t4(0, "bar", false, 0.5)];

    doTest(a, [TranscodeJValue.getExtractorFor(TInt), TranscodeJValue.getExtractorFor(TClass(String)), TranscodeJValue.getExtractorFor(TBool), TranscodeJValue.getExtractorFor(TFloat)]);
  }

  public function testTuple5() {
    var a = [Tuples.t5(123, "foo", true, 0.25, "biz"), Tuples.t5(0, "bar", false, 0.5, "bop")];

    doTest(a, [TranscodeJValue.getExtractorFor(TInt), TranscodeJValue.getExtractorFor(TClass(String)), TranscodeJValue.getExtractorFor(TBool), TranscodeJValue.getExtractorFor(TFloat), TranscodeJValue.getExtractorFor(TClass(String))]);
  }

  public function testArray() {
    var a: Array<Array<Int>> = [[123, 9, -23], []];

    doTest(a, [TranscodeJValue.getExtractorFor(TInt)]);
  }

  public function testSet() {
    var a: Array<Set<Int>> = [Set.create().addAll([123, 9, -23]), Set.create()];

    doTest(a, [TranscodeJValue.getExtractorFor(TInt)]);
  }

  public function testList() {
    var a: Array<List<Int>> = [List.create().addAll([123, 9, -23]), List.create()];

    doTest(a, TClass(List), [TranscodeJValue.getExtractorFor(TInt)]);
  }

  public function testMap() {
    var a: Array<Map<Int, String>> = [Map.create().addAll([Tuples.t2(123, "foo"), Tuples.t2(-23, "bar"), Tuples.t2(0, "baz")]), Map.create()];
		
		doTest(a, [TranscodeJValue.getExtractorFor(TInt), TranscodeJValue.getExtractorFor(TClass(String))]);
  }

  public function testJValue() {
    var a = [JNull, JString("foo"), JNumber(123.0), JBool(false), JObject([JField("foo", JString("bar"))]), JArray([JNull, JString("baz")])];
    doTest(a);
  }

  public function testEnum() {
    var a: Array<TestEnum> = [Second(123), First];

    doTest(a, [TranscodeJValue.getExtractorFor(TInt)]);
  }


  private function doTest<T>(values: Array<T>, ?valueType: ValueType, ?extractors: Array<JExtractorFunction<T>>): Void {
		for (value in values) {
      if (valueType == null)
        valueType = Type.typeof(value);
      var decomposed = TranscodeJValue.getDecomposerFor(valueType)(value);
      var actual     = TranscodeJValue.getExtractorFor(valueType, extractors)(decomposed);
			var equal      = Equal.getEqualFor(value)(value, actual);
      if (!equal) {
        throw "Expected " + value + " but was " + actual;
      }

      assertTrue(equal);
    }
  }
}


enum TestEnum {
  First;
  Second(v: Int);
}