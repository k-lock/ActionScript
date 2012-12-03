package klock.gameEngine
{
	import klock.gameEngine.unit.*

	public class EngineUnits
	{

		public static var VEHICLE:Array = new Array()
		
		public function EngineUnits()
		{
			initUnits()
		}
		private function initUnits():void{

			VEHICLE.push(new QWER({x:200, y:50}))
			VEHICLE.push(new QW(null))
		}
		
		
		
		

	}
}