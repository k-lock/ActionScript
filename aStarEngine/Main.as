package
{
	import flash.display.Sprite;
	
	import klock.astar.editor.PathEditor;
	import klock.simpleComponents.fonts.FontManager;
	
	
	[SWF(width="1000", height="700", frameRate="90", backgroundColor="#000000")]
	public class Main extends Sprite
	{
		public function Main()
		{
			var fm:FontManager = new FontManager()
			
			addChild( new PathEditor() )
			
		}
		
	}
}