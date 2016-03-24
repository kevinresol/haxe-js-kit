package js.npm.commonmark;

extern class HtmlRenderer
implements npm.Package.RequireNamespace<"commonmark", "^0.24.0">
{
	@:overload(function() : Void {})
	public function new(options : RendererOptions);

	public function render(nodetree : Node) : String;

	public var softbreak : String;
	public var escape : String -> Bool -> String;
}
