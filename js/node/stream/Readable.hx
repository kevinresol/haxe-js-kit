package js.node.stream;

import js.node.Buffer;
import js.node.events.EventEmitter;
import js.node.events.IEventEmitter;
import js.node.stream.Writable;

extern class Readable 
implements IReadable
extends EventEmitter
implements npm.Package.RequireNamespace<"stream","*">
{

  public static inline var EVENT_READABLE = "readable";
  public static inline var EVENT_END = "end";
  public static inline var EVENT_DATA = "data";
  public static inline var EVENT_ERROR = "error";
  public static inline var EVENT_CLOSE = "close";

  var readable:Bool;
  function read<T>(?buffer:Int) : Null<T>;
  function pause():Void;
  function resume():Void;
  function destroy():Void;
  function destroySoon():Void;
  function setEncoding(enc:String):Void;
  function pipe(dest:IWritable,?opts:{end:Bool}):Void;
  function unpipe(?dest:IWritable):Void;
  function new(?opt:Dynamic):Void;

  @:overload(function(chunk:Buffer) : Bool {})
  @:overload(function(chunk:Null<String>) : Bool {})
  function push(chunk:String, encoding:String):Bool;
}

interface IReadable 
extends IEventEmitter 
{
  function read<T>(?buffer:Int) : Null<T>;
  function pause():Void;
  function resume():Void;
  function destroy():Void;
  function destroySoon():Void;
  function setEncoding(enc:String):Void;
  function pipe(dest:IWritable,?opts:{end:Bool}):Void;
  function unpipe(?dest:IWritable):Void;
}
