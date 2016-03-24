package js.npm.commonmark;

extern class Parser
implements npm.Package.RequireNamespace<"commonmark", "^0.24.0">
{
	@:overload(function() : Void {})
	public function new(options : {});

	public function parse(markdown : String) : Node;
}
