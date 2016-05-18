package js.npm;

import haxe.Log;
import haxe.PosInfos;
import js.Lib;
import js.support.Either;

typedef DebugFunction = Dynamic -> haxe.extern.Rest<Dynamic> -> Void;
typedef DebugHaxeLogTraceFunction = Dynamic -> ?PosInfos -> Void;

extern class Debug
implements npm.Package.Require<"debug","^2.2.0">
{
	public static inline function construct(name : String) : DebugInstance 
		return new DebugInstance(name);	
	
	public static function enable(name : String) : Void;
	public static function disable() : Void;
	public static var log : Either<DebugInstance, DebugHaxeLogTraceFunction>;
}

@:callable
abstract DebugInstance(DebugFunction) from DebugFunction to DebugFunction
{
	inline public function new(name : String) {
		this = cast Lib.require("debug")(name);
	}
	
	public function log(log : Either<DebugInstance, DebugHaxeLogTraceFunction>) : Void {
		untyped this.log = log;
	}
	
	@:to public function toHaxeLogTrace() : DebugHaxeLogTraceFunction {
		// Need a wrapper to avoid logging the whole PosInfos structure.
		return function(d : Dynamic, ?p : PosInfos) this(d);
	}
}
