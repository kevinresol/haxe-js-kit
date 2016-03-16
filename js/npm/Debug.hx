package js.npm;

import haxe.Log;
import haxe.PosInfos;
import js.Lib;
import js.support.Either;

typedef DebugFunction = Dynamic -> haxe.extern.Rest<Dynamic> -> Void;
typedef DebugHaxeLogTraceFunction = Dynamic -> ?PosInfos -> Void;

extern class Debug
implements npm.Package.RequireNamespace<"debug","^2.2.0">
{
	public static inline function construct(name : String) : DebugInstance {
		return new DebugInstance(name);
	}
	
	public static inline function enable(name : String) : Void {
		untyped Lib.require("debug").enable(name);
	}
	public static inline function disable() : Void {
		untyped Lib.require("debug").disable();
	}
	public static inline function log(log : Either<DebugInstance, DebugHaxeLogTraceFunction>) : Void {
		untyped Lib.require("debug").log = log;
	}
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
	
	@:to public function haxeLogTrace() {
		// Need a wrapper to avoid logging the whole PosInfos structure.
		return function(d : Dynamic, ?p : PosInfos) this(d);
	}
}
