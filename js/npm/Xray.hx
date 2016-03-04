package js.npm;

import haxe.Timer;
import js.Error;
import js.Lib;
import js.node.stream.Readable.IReadable;
import js.npm.Xray.XrayDriverContext;
import js.npm.Xray.XrayHttpDriver;
import js.support.Either;

typedef XrayCallback = Error -> Dynamic -> Void;

// Type the selector, similar to https://github.com/fponticelli/doom/blob/master/src/doom/core/VNode.hx
typedef XraySelector = Dynamic -> Dynamic -> ?Dynamic -> (XrayCallback -> Void);

typedef XrayDriver = XrayDriverContext -> (Error -> XrayDriverContext -> Void) -> Void;

@:callable
abstract Xray(XraySelector) from XraySelector to XraySelector
{
	inline public function new(?xray : XraySelector) {
		this = if (xray == null) XrayPackage.construct() else xray;
	}

	/**
	 * Overload of driver()
	 */
	public function getDriver() : XrayDriver {
		return untyped this.driver();
	}

	public function driver(driver : XrayDriver) : Xray {
		return untyped this.driver(driver);
	}

	/**
	 * Overload of write()
	 */
	public function readableStream() : IReadable {
		return untyped this.write();
	}

	public function write(path : String) : Xray {
		return untyped this.write(path);
	}

	public function paginate(selector : String) : Xray {
		return untyped this.paginate(selector);
	}

	public function limit(n : Int) : Xray {
		return untyped this.limit(n);
	}
	
	public function delay(from : Int, ?to : Int) : Xray {
		return to == null ? untyped this.delay(from) : untyped this.delay(from, to);
	}

	public function concurrency(n : Int) : Xray {
		return untyped this.concurrency(n);
	}

	public function throttle(n : Int, ms : Int) : Xray {
		return untyped this.throttle(n, ms);
	}

	public function timeout(ms : Int) : Xray {
		return untyped this.timeout(ms);
	}
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

///////////////////////////////////////////////////////////////////////////////////

private extern class XrayPackage
implements npm.Package.RequireNamespace<"x-ray", "^2.0.3">
implements npm.Package.RequireNamespace<"superagent", "^1.7.2">
implements npm.Package.RequireNamespace<"superagent-charset", "^0.1.1">
{
	public static inline function construct() : Xray {
		return new Xray(cast Lib.require("x-ray")());
	}
}

private enum DriverAuthStatus {
	NotAuthenticated;
	Pending;
	AuthCompleted;
}

/**
 * A more powerful version of the default http-driver.
 */
class XrayHttpDriver 
{
	public function new(?superagentOpts : {}) {
		if(superagentOpts == null) superagentOpts = {};
		_agent = Lib.require("superagent-charset").agent(superagentOpts);
	}

	public function getAgent() return _agent;
	public function agent(agent : Dynamic) {
		_agent = agent;
		return this;
	}

	public function getEncoding() return _encoding;
	public function encoding(encoding : String) {
		_encoding = encoding;
		return this;
	}
	
	public function authenticateWith(url : String, postData : {}, timeoutMs : Int = 5000) {
		_authUrl = url;
		_authData = postData;
		_authTimeout = timeoutMs;
		return this;
	}
	
	public function getDriver() : XrayDriver {	
		return function(ctx : XrayDriverContext, cb : Error -> XrayDriverContext -> Void) : Void {			
			// Keep this method up-to-date with 
			// https://github.com/lapwinglabs/x-ray-crawler/blob/master/lib/http-driver.js
			function makeRequest() {
				_agent
				.get(ctx.url)
				.charset(_encoding)
				.set(ctx.headers)
				.end(function(err, res) {
					if (err != null && !Reflect.hasField(err, "status")) return cb(err, null);
					
					ctx.status = res.status;
					ctx.set(res.headers);
					
					ctx.body = ctx.type == 'application/json' ? res.body : res.text;
					
					// update the URL if there were redirects
					ctx.url = res.redirects.length ? res.redirects.pop() : ctx.url;
					
					return cb(null, ctx);
				});				
			}

			function waitForAuth() {
				if (_authStatus != AuthCompleted) Timer.delay(waitForAuth, 50);
				else makeRequest();
			}
			
			switch _authStatus {
				case NotAuthenticated if (_authUrl != null):
					_authStatus = Pending;				
					_agent
					.post(_authUrl)
					.timeout(_authTimeout)
					.type('form')
					.send(_authData)
					.end(function(err, res) {
						_authStatus = AuthCompleted;
						if (err != null) return cb(err, ctx);
						else makeRequest();
					});
				case Pending if (_authUrl != null): 
					waitForAuth();
				case _: 
					makeRequest();
			}
		}
	}

	private var _agent : Dynamic;	
	private var _encoding : String = 'utf-8';

	private var _authUrl : String;
	private var _authData : {};
	private var _authTimeout : Int;
	private var _authStatus : DriverAuthStatus = NotAuthenticated;
}
