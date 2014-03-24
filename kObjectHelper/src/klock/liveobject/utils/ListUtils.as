package klock.liveobject.utils {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;

public class ListUtils {

	public function ListUtils() {}

	//------------------------------------------------------------------------------------------------------------------ vector.<string> -> index key array

	public static function swapVectorByValue( vs:Vector.<String>, watchObject:DisplayObject ):Array {

		var vn:Array = [];
		var value:*;
		for each(var objectProp:String in vs) {
			if( objectProp == "type"){
				value = StringUtils.clearType( watchObject.toString() );
			}else if( objectProp == "showBounds" ||objectProp == "showChildBounds" || objectProp == "showPivot"){
				value = false;
			}else{
				value = watchObject[objectProp];
			}
			vn.push({key: objectProp, value: value });
		}
		return vn;
	}

	//------------------------------------------------------------------------------------------------------------------ display object stack search

	public static var objectz:Array = [];
	public static function traceDisplayList(displayObject:DisplayObject, maxDepth:int = 100, skipClass:Class = null, levelSpace:String = " ", currentDepth:int = 0):void
	{
		if (skipClass != null) if (displayObject is skipClass) return;
		//trace(levelSpace + displayObject.name, currentDepth, 'parent ', currentDepth-1);  // or any function that clean instance name
		objectz.push({ obj:displayObject, par:displayObject.parent, cde:currentDepth})
		if (displayObject is DisplayObjectContainer && currentDepth < maxDepth)
		{
			for (var i:int = 0; i < DisplayObjectContainer(displayObject).numChildren; i++)
			{
				traceDisplayList(DisplayObjectContainer(displayObject).getChildAt(i), maxDepth, skipClass, levelSpace + "    ", currentDepth + 1);
			}
		}
	}

	//------------------------------------------------------------------------------------------------------------------

	/*public static function tracerDisplayList(container:DisplayObjectContainer, indentString:String = ""):void {
	 var child:DisplayObject;

	 for (var i:uint=0; i <container.numChildren; i++) {
	 child = container.getChildAt(i);
	 trace(indentString, child.parent.name + " " + indentString + " " + child.name);

	 objectz.push({ obj:child, par:child.parent})

	 if (container.getChildAt(i) is DisplayObjectContainer) {
	 tracerDisplayList(DisplayObjectContainer(child), indentString + "");
	 }
	 }
	 }*/
	//------------------------------------------------------------------------------------------------------------------ dict sort -> indexkey array
	/*
	 public static function sortDictionaryByValue(d:Dictionary, onlyTransform:Boolean = false):Array {
	 var a:Array = new Array();
	 for (var dictionaryKey:Object in d) {
	 a.push({key: dictionaryKey, value: d[dictionaryKey]});
	 }
	 if(!onlyTransform) a.sortOn("key", [Array.CASEINSENSITIVE]);
	 return a;
	 }
	 */
	//------------------------------------------------------------------------------------------------------------------
	/*public static function fillVectorByValue( vs:Vector.<String>, watchObject:DisplayObject ):Array {
	 var vn:Array = [];
	 var value:*;
	 for each(var objectProp:String in vs) {
	 value = watchObject[objectProp];
	 if( value == null || value == ""){
	 if( objectProp == "type"){
	 var nStr:String = watchObject.toString().replace("[object", ""); nStr = nStr.replace("]", "");
	 value = nStr;
	 }
	 if( objectProp == "showBounds" ||objectProp == "showChildBounds" || objectProp == "showPivot"){
	 value = false;
	 }
	 }
	 vn.push({key: objectProp, value: value });
	 }
	 return vn;
	 }*/
}
}
