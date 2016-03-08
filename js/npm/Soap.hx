package js.npm;

import js.Error;
import js.node.http.Server;
import js.node.http.ClientRequest;

typedef SoapClient = Dynamic;

typedef SoapServer<T> = {
	log: SoapLogType -> T -> Void,
	authenticate: SoapSecurity -> Bool,
	authorizeConnection: ClientRequest -> Bool
}

interface SoapSecurity {
	public function addOptions(options : {}) : Void;
	public function toXML() : String;
}

@:enum abstract SoapLogType(String) from String to String {
	var received = "received";
	var replied = "replied";
}

extern class Soap
implements npm.Package.Require<"soap","^0.13.0"> {
	@:overload(function<T>(url : String, options : {}, cb : Error -> T -> Void) : Void {})
	public static function createClient<T>(url : String, cb : Error -> T -> Void) : Void;

	@:overload(function<T>(server : Server, options : {}) : SoapServer<T> {})
	public static function listen<T, T2>(server : Server, path : String, services : T, wsdl : String) : SoapServer<T2>;

	public static inline function describe(client : SoapClient) : {} {
		return untyped client.describe();
	}

	public static inline function setSecurity(client : SoapClient, security : SoapSecurity) : Void {
		untyped client.setSecurity(security);
	}	
}

extern class BasicAuthSecurity 
implements SoapSecurity 
implements npm.Package.RequireNamespace<"soap","^0.13.0"> {
	public function new(username : String, password : String);
	public function addOptions(options : {}) : Void;
	public function toXML() : String;
}

extern class WSSecurity 
implements SoapSecurity 
implements npm.Package.RequireNamespace<"soap","^0.13.0"> {
	public function new(username : String, password : String);
	public function addOptions(options : {}) : Void;
	public function toXML() : String;
}

extern class BearerSecurity 
implements SoapSecurity 
implements npm.Package.RequireNamespace<"soap","^0.13.0"> {
	public function new(token : String);
	public function addOptions(options : {}) : Void;
	public function toXML() : String;
}

extern class ClientSSLSecurity
implements SoapSecurity 
implements npm.Package.RequireNamespace<"soap","^0.13.0"> {
	@:overload(function(pathToKey : String, pathToCert : String, options : {}) : Void {})
	public function new(pathToKey : String, pathToCert : String);
	public function addOptions(options : {}) : Void;
	public function toXML() : String;
}
