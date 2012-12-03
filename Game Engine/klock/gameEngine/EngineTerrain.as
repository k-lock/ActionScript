package klock.gameEngine
{
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class EngineTerrain
	{

		private var WORLD:Sprite
		
		public function EngineTerrain()
		{
	
			initWORLD()
			initGRID()
			
		}
		private function initWORLD():void{
			
			WORLD = new Sprite()
				
			main.STAGE.addChild(WORLD)		
		}
		private function initGRID():void{
			
			var g:Graphics = WORLD.graphics
			g.beginFill(0xcc44ee)
			g.drawRect( -EngineSetup.Level_Width*.5, -EngineSetup.Level_Height*.5, EngineSetup.Level_Width, EngineSetup.Level_Height )	
			
			WORLD.rotationX= -90
				
			WORLD.x = EngineSetup.Level_Width*.5
			WORLD.y = EngineSetup.Level_Height*.65
			
		}
		
	}
}