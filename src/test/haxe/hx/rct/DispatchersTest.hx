package hx.rct;

import stx.Strings;

import Stax.*;
import stx.Compare.*;
import stx.Log.*;

using stx.UnitTest;

import stx.utl.Selector;

class DispatchersTest extends TestCase{
  public function testDispatchers(u:UnitArrow):UnitArrow{
    var tsts = [];
    var a : Selector<String> = 'a';
    var b : Selector<String> = 'b';
    var c     = new Dispatchers();
    var eq    = Strings.equals;
    var hdl   = function(x){};
    var d     = c.addWith(a,hdl,eq);
    var e     = c.addWith(a,hdl,eq);
    var hdl0  = function(y){};
    var f     = c.addWith(a,hdl0,eq);

    tsts.push(isTrue(d));
    tsts.push(isFalse(e));
    tsts.push(isTrue(f));

    return u.append(tsts);
  }
}

