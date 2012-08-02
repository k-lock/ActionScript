package klock.text.fonts
{
	import flash.events.EventDispatcher;
	import flash.text.Font;
	
	public class FONTS extends EventDispatcher	{
		
		[Embed(source="klock/text/fonts/arial.ttf", 	fontName="MY Arial", embedAsCFF="false")]
		public static var arialRegular:Class;

		/*[Embed(source="klock/text/fonts/arialbd.ttf", 	fontName="MY Arial Bold", fontWeight="bold", embedAsCFF="false")]
		public static var arialBold:Class;
		
		[Embed(source="klock/text/fonts/bankgthd.ttf", fontName="MY Bank", embedAsCFF="false")]
		private var bankg:Class;
		
		[Embed(source="klock/text/fonts/badaboom.ttf", fontName="MY Badaboom")]
		private var badaboom:Class;
		
		[Embed(source="klock/text/fonts/umberto.ttf", fontName="MY Umberto")]
		private var umberto:Class;

*/
		public function FONTS() {
		    //trace("Fonts loaded");
		  
		    Font.registerFont(arialRegular);
/*		    Font.registerFont(arialBold);
	    	Font.registerFont(bankg);
				Font.registerFont(badaboom);
			Font.registerFont(umberto);
*/
		}

	}
}

