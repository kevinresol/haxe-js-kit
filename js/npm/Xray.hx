package js.npm;

import js.Error;
import js.Lib;
import js.node.stream.Readable.IReadable;
import js.node.stream.Writable.IWritable;
import js.npm.Xray.XrayDriverContext;
import js.support.Either;

typedef XrayCallback = Error -> Dynamic -> Void;

typedef XrayDriver = XrayDriverContext -> (Error -> XrayDriverContext -> Void) -> Void;

extern class Xray
implements npm.Package.Require<"x-ray", "^2.0.3">
{
	@:selfCall function new() : Void;

	// Type the selector, similar to https://github.com/fponticelli/doom/blob/master/src/doom/core/VNode.hx
	@:overload(function(url : Either<String, Array<String>>, selector : Dynamic) : Xray {})
	@:selfCall public function x(url : Either<String, Array<String>>, scope : Either<String, Array<String>>, selector : Dynamic) : Xray;

	@:selfCall public function done(cb : XrayCallback) : Void;
	
	@:overload(function() : XrayDriver {})
	public function driver(driver : XrayDriver) : Xray;

	public function stream() : IReadable;
	
	@:overload(function() : IReadable {})
	public function write(path : String) : IWritable;

	public function paginate(selector : String) : Xray;

	public function limit(n : Int) : Xray;
	
	@:overload(function(from : Int) : Xray {})
	public function delay(from : Int, to : Int) : Xray;

	public function concurrency(n : Int) : Xray;

	public function throttle(n : Int, ms : Int) : Xray;

	public function timeout(ms : Int) : Xray;	
}

extern class XrayDriverContext {
	// Request delegation

	public function acceptsLanguages(types : Either<String, Array<String>>) : Dynamic;
	public function acceptsEncodings(types : Either<String, Array<String>>) : Dynamic;
	public function acceptsCharsets(types : Either<String, Array<String>>) : Dynamic;
	public function accepts(types : Either<String, Array<String>>) : Dynamic;
	public function get(field : String) : String;
	public function is(types : Either<String, Array<String>>) : Dynamic;

	public var querystring(default, default) : String;
	public var idempotent(default, null) : Bool;
	public var socket(default, default) : Dynamic;
	public var search(default, default) : String;
	public var method(default, default) : String;
	public var query(default, default) : Dynamic;
	public var path(default, default) : String;
	public var url(default, default) : String;

	public var href(default, null) : String;
	public var subdomains(default, null) : String;
	public var protocol(default, null) : String;
	public var host(default, null) : String;
	public var hostname(default, null) : String;
	public var header(default, null) : Dynamic;
	public var headers(default, null) : Dynamic;
	public var secure(default, null) : Bool;
	public var stale(default, null) : String;
	public var fresh(default, null) : Bool;
	public var ips(default, null) : String;
	public var ip(default, null) : String;

	// Response delegation	

	public function attachment(filename : String) : Void;
	public function redirect(url : String, alt : String) : Void;
	public function remove(field : String) : Void;
	public function vary(field : String) : Void;
	@:overload(function(field : {}) : Void {})
	@:overload(function(field : Array<String>) : Void {})
	public function set(field : String, val : Either<String, Array<String>>) : Void;
	public function append(field : String, val : Either<String, Array<String>>) : Void;
	
	public var status(default, default) : Int;
	public var message(default, default) : String;
	public var body(default, default) : Dynamic;
	public var length(default, default) : Int;
	public var type(default, default) : String;
	public var lastModified(default, default) : String;
	public var etag(default, default) : String;
	public var headerSent(default, null) : Bool;
	public var writable(default, null) : Bool;
}
