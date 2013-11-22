import stx.Log.*;

//import stx.Future;
using stx.UnitTest;

import Stax.*;

class Test{
  @:bug('#0b1kn00b: UnitTest currently relies on rtti which is empty at macro time.')
  macro static function macros(e:Expr){
  /*    var rig                     = UnitTest.rig();
      var tests : Array<TestCase> = 
      [
        new stx.mcr.TypesTest(),
      ];
      rig.append(tests#if select ,'devtest' #end).run();*/
    return e;
  }
  function new(){
    trace(debug('entry point'));
    Stax.init();//bootstrap bug 
    var rig                     = UnitTest.rig();
    var tests : Array<TestCase> = 
    //#if development
      [
        new stx.TimeTest(),
        /*      
        new HaxeTest(),
        new stx.MonoidTest(),
        new stx.ContinuationTest(),
        new stx.UnitTestTest(),  
        new hx.rct.ReactorTest(),
        new hx.rct.DispatchersTest(),
        new stx.utl.SelectorTest(),
        new hx.rct.ReactorTest(),
        new hx.rct.ReactorTest(),
                
        new stx.plus.CloneTest(),
        new stx.StateTest(),
        new stx.PositionsTest(),
        new stx.LogTest(),
        
        new stx.iteratee.IterateeTest(),
        new stx.log.prs.LogListingParserTest(),
        new rx.RxTest(),
        new hx.sch.TaskTest(),
        

        new stx.mcr.TypesTest(),
        new stx.mcr.LensesMacroTest(),

        
        new stx.prs.JsonTest(),
        
        
        
        new stx.ObjectsTest(),
        new stx.plus.MetaTest(),
        
        new stx.OutcomeTest(),
        new stx.ArrowTest(),
        new stx.ds.MapTest(),
        new stx.ds.SetTest(),
        new stx.PartialFunctionTest(),
        new stx.plus.OrderTest(),
        new stx.ds.LispListTest(),
        new stx.MapsTest(),
        new hx.ds.PriorityQueueTest(),
              
        new stx.ioc.IocTest(),
        new stx.ReflectsTest(),
        new stx.TypesTest(),    
        new stx.ds.ListNewTest(),
        new stx.mcr.SelfTest(),new SubclassTest(),
        new stx.math.geom.Point2dTest(),
        new stx.ds.ZipperTest(),
        new stx.plus.HashTest(),
        new stx.ArraysTest(),
        new stx.plus.CloneTest(),
        
        new stx.PredicatesTest(),
        new stx.EventualTest(),
        new stx.ds.ListTest(),
        new stx.ds.LinkTest(),


        new stx.mcr.MacrosTest(),
        new stx.ReturnTest(),
        new stx.MethodTest(),
        new stx.rtti.IntrospectTest(),
        new stx.ErrorTest(),
        
        new stx.ifs.MonadTest(),
        new stx.rtti.RTypeTest(),
        new stx.ifs.IdentityTest(),
        new stx.ifs.PureTest(),
        new stx.ifs.SemiGroupTest()*/
      ];
    rig.append(tests#if select ,'devtest' #end).run();
  }
  static public function main(){
    var app = new Test();
  }
}
