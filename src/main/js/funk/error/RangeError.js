funk.error = funk.error || {};
funk.error.RangeError = (function(){
    "use strict";
    var RangeErrorImpl = function(msg){
        Error.apply(this, arguments);

        if(funk.isDefined(msg)) {
            this.message = msg;
        }
    };
    RangeErrorImpl.prototype = new Error();
    RangeErrorImpl.prototype.constructor = RangeErrorImpl;
    RangeErrorImpl.prototype.name = "RangeError";
    return RangeErrorImpl;
})();