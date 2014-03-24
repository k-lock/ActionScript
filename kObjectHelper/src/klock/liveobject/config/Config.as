package klock.liveobject.config {
import flash.display.BlendMode;
import flash.text.TextFieldType;

public class Config {

	public function Config() {}


	//------------------------------------------------------------------------------------------------------------------
	//
	//                                                                                       STATIC CONST LIST OBJECTS
	//
	//------------------------------------------------------------------------------------------------------------------

	public static const BLEND_MODE_LIST:Array = [BlendMode.ADD, BlendMode.ALPHA, BlendMode.DARKEN, BlendMode.DIFFERENCE, BlendMode.ERASE, BlendMode.HARDLIGHT, BlendMode.INVERT, BlendMode.LAYER, BlendMode.LIGHTEN, BlendMode.MULTIPLY, BlendMode.NORMAL, BlendMode.OVERLAY, BlendMode.SCREEN, BlendMode.SHADER, BlendMode.SUBTRACT];
	public static const TXT_TYPE_LIST:Array = [TextFieldType.DYNAMIC, TextFieldType.INPUT ];


	/*public static const OBJECT_PROPERTY_FILTER:Vector.<String> = new <String> [
		"name",
		"type"
	];*/

	//------------------------------------------------------------------------------------------------------------------
	//
	//                                                                                       UI PROPERTY FILTER
	//
	//------------------------------------------------------------------------------------------------------------------

	public static var PROPERTY_FILTER:Vector.<String> = new <String>[];

	public static const PROPS_PROPERTY_FILTER:Vector.<String> = new <String> [

	];


	public static const TXT_PROPERTY_FILTER:Vector.<String> = new <String> [
		"text",
		"border",
		"embedFonts",
		"multiline",
		"selectable",
		"type",
		"wordWrap"
	];
	public static const SP_PROPERTY_FILTER:Vector.<String> = new <String> [
		"visible",
		"cacheAsBitmap",
		"blendMode",
		"alpha"//,
		//    "enabled"
	];
	public static const MC_PROPERTY_FILTER:Vector.<String> = new <String> [
		"currentFrame",
		"currentFrameLabel",
		"stop",
		"blendMode",
		"alpha"//,
		//    "enabled"
	];

	public static const VISUAL_PROPERTY_FILTER:Vector.<String> = new <String> [
		"visible",
		"cacheAsBitmap",
		"blendMode",
		"alpha"//,
		//    "enabled"
	];
	public static const TRANS_PROPERTY_FILTER:Vector.<String> = new <String> [
		"x",
		"y",
		"z",
		"width",
		"height",
		"rotation",

		/* "rotationY",
		 "rotationZ",
		 "rotationX",*/
		"scaleY",
		"scaleX",
		"scaleZ"];

	public static const BOUNDS_PROPERTY_FILTER:Vector.<String> = new <String> [
		"showBounds",
		"showChildBounds",
		"showPivot"
	];
}
}
