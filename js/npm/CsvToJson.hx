package js.npm;

import haxe.Json;
import js.Error;
import js.node.events.EventEmitter;
import js.node.stream.Transform;

typedef CsvToJsonOptions = {
	?constructResult : Bool,
	?delimiter : String,
	?quote: String,
	?trim: Bool,
	?checkType: Bool,
	?toArrayString: Bool,
	?ignoreEmpty: Bool,
	?workerNum: Int,
	?noheader: Bool,
	?headers: Null<Array<String>>,
	?flatKeys: Bool,
	?maxRowLength: Int,
	?checkColumn: Bool,
	?eol: String
}

// Events: end_parsed, record_parsed
@:native("Converter")
extern class CsvToJson extends Transform<CsvToJson>
implements IEventEmitter
implements npm.Package.RequireNamespace<"csvtojson", "^0.5.2">
{
	@:overload(function() : Void {})
	public function new(options : CsvToJsonOptions);
	
	public function fromFile<T>(file : String, cb : Error -> T -> Void) : Void;
	public function fromString<T>(string : String, cb : Error -> T -> Void) : Void;
	
	public var transform(null, default) : Dynamic -> Dynamic -> Int -> Void;
}
