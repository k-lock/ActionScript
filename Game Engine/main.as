package
{
	import flash.display.Sprite;
	import klock.gameEngine.GameEngine
		
	[SWF(width="600", height="600", frameRate="30", backgroundColor="#444444")]
	public class main extends Sprite
	{
		
		public static var STAGE:Object
		
		public function main()
		{
			STAGE = stage
			
			GameEngine.startEngine()
		}
	}
}