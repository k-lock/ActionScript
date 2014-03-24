package klock.liveobject.utils {

public class StringUtils {

	public function StringUtils() {}

	/** String command to cut to length of an string string to a given count.*/
	public static function cutStringValue(nStr:String, cutIndex:int = 15):String {
		if( nStr.length > cutIndex ){
			nStr = nStr.slice(0,cutIndex)
		}
		return nStr;
	}
	/** String command to replace value of '[object Sprite]' to 'Sprite'  */
	public static function clearType(nStr:String):String {
		nStr = nStr.replace("[object", "");
		nStr = nStr.replace("]", "");
		return nStr;
	}
	/** String command to cut to length of an string string to a given count.*/
	private function cutStringValue(nStr:String, cutIndex:int = 15):String {
		if( nStr.length > cutIndex ){
			nStr = nStr.slice(0,cutIndex)
		}
		return nStr;
	}

}
}
