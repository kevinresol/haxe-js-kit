package js.npm.arangojs;

import js.support.Either;
import js.support.Either.Either3;
import js.node.http.Agent;

typedef DatabaseOptions = {
	?url : String,
	?databaseName : String,
	?arangoVersion : Int,
	?headers : {},
	?agent : Agent,
	?agentOptions : {},
	?promise : Dynamic
}

typedef Aqb = Either<String, { function toAQL() : String }>;

extern class Database
implements npm.Package.RequireNamespace<"arangojs", "^4.3.0">
{
	@:overload(function() : Database {})
	@:overload(function(config : String) : Database {})
	public function new(config : DatabaseOptions);

	// Manipulating databases

	public function useDatabase(databaseName : String) : Database;
	@:overload(function(databaseName : String, cb : ArangoCallback<Dynamic>) : Void {})
	public function createDatabase(databaseName : String, users : Array<Dynamic>, cb : ArangoCallback<Dynamic>) : Void;
	public function get(cb : ArangoCallback<Dynamic>) : Void;
	public function listDatabases(cb : ArangoCallback<Array<String>>) : Void;
	public function listUserDatabases(cb : ArangoCallback<Array<String>>) : Void;
	public function dropDatabase(databaseName : String, cb : ArangoCallback<Dynamic>) : Void;
	@:overload(function(cb : ArangoCallback<Dynamic>) : Void {})
	public function truncate(excludeSystem : Bool, cb : ArangoCallback<Dynamic>) : Void;

	// Accessing collections
	
	public function collection(collectionName : String) : DocumentCollection;
	public function edgeCollection(collectionName : String) : EdgeCollection;
	@:overload(function(cb : ArangoCallback<Array<Dynamic>>) : Void {})
	public function listCollections(excludeSystem : Bool, cb : ArangoCallback<Array<Dynamic>>) : Void;
	@:overload(function(cb : ArangoCallback<Array<Collection>>) : Void {})
	public function collections(excludeSystem : Bool, cb : ArangoCallback<Array<Collection>>) : Void;
	
	// Accessing graphs

	public function graph(graphName : String) : Graph;
	public function listGraphs(cb : ArangoCallback<Array<Dynamic>>) : Void;
	public function graphs(cb : ArangoCallback<Array<Graph>>) : Void;

	// Transactions
	
	@:overload(function(collections : Either3<String, {}, Array<String>>, action : String, cb : ArangoCallback<Dynamic>) : Void {})
	@:overload(function(collections : Either3<String, {}, Array<String>>, action : String, params : Array<{}>, cb : ArangoCallback<Dynamic>) : Void {})
	public function transaction(collections : Either3<String, {}, Array<String>>, action : String, params : Array<{}>, lockTimeout : Int, cb : ArangoCallback<Dynamic>) : Void;
	
	// Queries
	// aqlQuery macro

        @:overload(function<T>(query : { query: Either<String, Aqb>, ?bindVars : {} }, opts : {}, cb : ArangoCallback<Cursor<T>>) : Void {})
	@:overload(function<T>(query : { query: Either<String, Aqb>, ?bindVars : {} }, cb : ArangoCallback<Cursor<T>>) : Void {})
	@:overload(function<T>(query : Either<String, Aqb>, bindVars : {}, opts : {}, cb : ArangoCallback<Cursor<T>>) : Void {})
	@:overload(function<T>(query : Either<String, Aqb>, bindVars : {}, cb : ArangoCallback<Cursor<T>>) : Void {})
	public function query<T>(query : Either<String, Aqb>, cb : ArangoCallback<Cursor<T>>) : Void;

	// Managing AQL user functions
	
	public function listFunctions(cb : ArangoCallback<Array<Dynamic>>) : Void;
	public function createFunction(name : String, code : String, cb : ArangoCallback<Dynamic>) : Void;
	@:overload(function(name : String, cb : ArangoCallback<Dynamic>) : Void {})
	public function dropFunction(name : String, group : String, cb : ArangoCallback<Dynamic>) : Void;
	
	// Arbitrary HTTP routes
	
	@:overload(function() : Route {})
	@:overload(function(headers : {}) : Route {})
	@:overload(function(path : String) : Route {})
	public function route(path : String, headers : {}) : Route;
}
