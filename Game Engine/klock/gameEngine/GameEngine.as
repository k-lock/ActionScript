package klock.gameEngine
{
	import flash.display.Stage;

	public class GameEngine
	{
		
		private static var engineSetup	:EngineSetup
		private static var engineUnits	:EngineUnits
		private static var engineTerrain:EngineTerrain
		private static var engineCore	:EngineCore
		
		
		public function GameEngine();		
		public static function startEngine():void{
		
			engineSetup   = new EngineSetup()
			engineUnits   = new EngineUnits()
			engineTerrain = new EngineTerrain()
			
			engineCore = new EngineCore()	
			engineCore.INIT()
		}
		
	}
}