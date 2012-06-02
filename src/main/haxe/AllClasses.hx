package ;

import Dom;
import js.detect.BrowserSupport;
import js.detect.Host;
import js.dom.DomExtensions;
import js.dom.HTMLDocumentExtensions;
import js.dom.HTMLElementExtensions;
import js.dom.HTMLEventExtensions;
import js.dom.Quirks;
import js.Env;
import js.io.IFrameIO;
import js.text.html.HTMLParser;
import Prelude;
import Stax;
import stx.Arrays;
import stx.Bools;
import stx.concurrent.Actor;
import stx.core.Initializable;
import stx.data.transcode.Transcode;
import stx.data.transcode.TranscodeJValue;
import stx.data.transcode.TranscodeJValueExtensions;
import stx.Dates;
import stx.ds.Collection;
import stx.ds.Group;
import stx.ds.List;
import stx.ds.Map;
import stx.ds.plus.Equal;
import stx.ds.plus.Hasher;
import stx.ds.plus.Meta;
import stx.ds.plus.Order;
import stx.ds.plus.Show;
import stx.ds.Set;
import stx.ds.Zipper;
import stx.Dynamics;
import stx.Eithers;
import stx.Enums;
import stx.error.AbstractMethodError;
import stx.error.AssertionError;
import stx.error.Error;
import stx.error.IllegalOverrideError;
import stx.error.NullReferenceError;
import stx.error.OutOfBoundsError;
import stx.framework.Injector;
import stx.functional.Foldable;
import stx.functional.FoldableExtensions;
import stx.functional.PartialFunction;
import stx.functional.PartialFunctionExtensions;
import stx.functional.Predicate;
import stx.functional.PredicateExtensions;
import stx.Functions;
import stx.Future;
import stx.Hashes;
import stx.io.file.File;
import stx.io.http.Http;
import stx.io.http.HttpJValue;
import stx.io.http.HttpString;
import stx.io.http.HttpTransformer;
import stx.io.http.HttpXml;
import stx.io.log.Logger;
import stx.Iterables;
import stx.Iterators;
import stx.math.geom.Point;
import stx.math.geom.PointExtensions;
import stx.math.geom.Vector;
import stx.math.geom.VectorExtensions;
import stx.math.tween.Easing;
import stx.math.tween.Tween;
import stx.math.tween.TweenExtensions;
import stx.Maths;
import stx.Methods;
import stx.net.HttpHeader;
import stx.net.HttpHeaderExtensions;
import stx.net.HttpResponseCode;
import stx.net.HttpResponseCodeExtensions;
import stx.net.Url;
import stx.net.UrlExtensions;
import stx.Objects;
import stx.Options;
import stx.Promise;
import stx.reactive.Arrows;
import stx.reactive.Collections;
import stx.reactive.Reactive;
import stx.reactive.SignalBool;
import stx.reactive.SignalCollection;
import stx.reactive.SignalCollectionExtensions;
import stx.reactive.SignalFloat;
import stx.reactive.SignalInt;
import stx.reactive.Signals;
import stx.reactive.SignalSignal;
import stx.reactive.StreamBool;
import stx.reactive.Streams;
import stx.reactive.StreamStream;
import stx.rtti.RTypes;
import stx.Strings;
import stx.test.Assert;
import stx.test.Assertation;
import stx.test.Dispatcher;
import stx.test.mock.Mock;
import stx.test.MustMatcherExtensions;
import stx.test.MustMatchers;
import stx.test.resources.BCollectionTester;
import stx.test.Runner;
import stx.test.TestCase;
import stx.test.TestFixture;
import stx.test.TestHandler;
import stx.test.TestResult;
import stx.test.ui.common.ClassResult;
import stx.test.ui.common.FixtureResult;
import stx.test.ui.common.HeaderDisplayMode;
import stx.test.ui.common.IReport;
import stx.test.ui.common.PackageResult;
import stx.test.ui.common.ReportTools;
import stx.test.ui.common.ResultAggregator;
import stx.test.ui.common.ResultStats;
import stx.test.ui.Report;
import stx.test.ui.text.HtmlReport;
import stx.test.ui.text.PlainTextReport;
import stx.test.ui.text.PrintReport;
import stx.text.json.CollectionsJValue;
import stx.text.json.Json;
import stx.text.json.JValue;
import stx.text.json.JValueExtensions;
import stx.text.json.PrimitivesJValue;
import stx.time.Clock;
import stx.time.ScheduledExecutor;
import stx.Tuples;
import stx.util.Guid;
import stx.util.ObjectExtensions;
import stx.util.OrderExtension;
import stx.util.StringExtensions;

@IgnoreCover
class AllClasses
{
@IgnoreCover
	public static function main():AllClasses {return new AllClasses();}
@IgnoreCover
	public function new(){trace('This is a generated main class');}
}

