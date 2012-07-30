package klock.simpleComponents.fonts
{
	import flash.text.Font
	import flash.events.EventDispatcher;

	/** Class to load and register external fonts. */
	public class FontManager extends EventDispatcher
	{
		[Embed(source = "/klock/simpleComponents/fonts/tahoma.ttf",	embedAsCFF="false", fontName="MY Tahoma", mimeType="application/x-font")]
		public static var tahoma:Class;
	
		public function FontManager()
		{
			Font.registerFont( tahoma );
		}
		
	}
}