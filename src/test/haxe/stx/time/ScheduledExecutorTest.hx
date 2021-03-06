  package stx.time;

import Prelude;
import stx.test.Assert;
import stx.test.Suite;
import stx.time.ScheduledExecutor;

using stx.framework.Injector;

import stx.Eventual;

class ScheduledExecutorTest extends Suite {
  var _executor: ScheduledExecutor;
  
  override public function beforeAll() {
    _executor = ScheduledExecutor.inject();
  }
  
  public function testOnce(): Void {
    var future = _executor.once(function() {
      return 12;
    }, 1);
    
    Assert.delivered(future,
      function(v) {
        Assert.equals(12, v);
      }
    );
  }
  
  public function testOnceCanBeCanceled(): Void {
    var future = _executor.once(function() {
      return 12;
    }, 1);
    
    Assert.notDelivered(future);
    
    future.cancel();
  }
  
  public function testRepeat(): Void {
    var future = _executor.repeat(0, function(count) {
      return count + 1;
    }, 1, 3);
    
    Assert.delivered(future,
      function(v) {
        Assert.equals(3, v);
      }
    );
  }
  
  public function testRepeatCanBeCanceled(): Void {
    var future = _executor.repeat(0, function(count) {
      return count + 1;
    }, 1, 3);
    
    Assert.notDelivered(future);
    
    future.cancel();
  }
  
  public function testForeverCanBeCanceled(): Void {
    var future = _executor.forever(function() { }, 1);
    
    Assert.notDelivered(future);
    
    future.cancel();
  }
  
  public function testForever(): Void {
    var future: Eventual<Void> = null;
    var count = 0;
    
    future = _executor.forever(function() { 
      ++count;
      
      future.cancel();
    }, 1);
    
    Assert.canceled(future,
      function() {
        Assert.equals(1, count);
      }
    );
  }
}