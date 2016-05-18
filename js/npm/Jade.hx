package js.npm;

import js.npm.express.ViewEngine;
import js.support.Either;

typedef JadeOptions = {
	?filename : String,
	?doctype : String,
	?pretty : Either<Bool, String>,
	?self : Bool,
	?debug : Bool,
	?compileDebug : Bool,
	?cache : Bool,
	?compiler : {},
	?parser : {},
	?globals : Array<String>
}

typedef CompiledJade = ?{} -> String;

extern class Jade
implements npm.Package.Require<"jade","^1.11.0"> 
{
	public static var __express : ViewEngine;
	
	@:overload(function(jade : String) : CompiledJade {})
	public static function compile(jade : String, options : JadeOptions) : CompiledJade;

	@:overload(function(filename : String) : CompiledJade {})
	public static function compileFile(filename : String, options : JadeOptions) : CompiledJade;

	@:overload(function(jade : String) : String {})
	public static function compileClient(jade : String, options : JadeOptions) : String;

	@:overload(function(jade : String) : {body: String, dependencies: Array<String>} {})
	public static function compileClientWithDependenciesTracked(jade : String, options : JadeOptions) : {body: String, dependencies: Array<String>};

	@:overload(function(filename : String) : String {})
	public static function compileFileClient(filename : String, options : {}) : String;

	@:overload(function(jade : String) : String {})
	public static function render(jade : String, options : {}) : String;

	@:overload(function(filename : String) : String {})
	public static function renderFile(filename : String, options : {}) : String;
}
