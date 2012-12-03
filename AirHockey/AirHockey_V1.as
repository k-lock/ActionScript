package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import klock.simpleComponents.fonts.FontManager;
	
	[SWF( framerate=60, width="460", height="700")]
	
	public class AirHockey_V1 extends Sprite
	{
		public function AirHockey_V1()
		{
			var f:FontManager = new FontManager()
			addEventListener( Event.ADDED_TO_STAGE , Init)
		}
		
		private function Init(event:Event):void {	
			
			removeEventListener( Event.ADDED_TO_STAGE , Init)
			
			addChild( new GameMain_Server2()) 
		}
	}
}