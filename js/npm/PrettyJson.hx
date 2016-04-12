package js.npm;

typedef PrettyJsonOptions = {
	?noColor : Bool,
	?keysColor: String,
	?dashColor: String,
	?stringColor: String
}

extern class PrettyJson
implements npm.Package.Require<"prettyjson","1.1.3">
{
	@:overload(function(data: Dynamic) : String {})
	static function render(data: Dynamic, options : PrettyJsonOptions) : String;
}
