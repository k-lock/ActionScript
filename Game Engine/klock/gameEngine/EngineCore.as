package klock.gameEngine
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import klock.gameEngine.controller.HumanController;
	import klock.gameEngine.unit.Unit;

	public class EngineCore extends Sprite {
		
		
		private var BOX:Sprite
		private var HC:HumanController = new HumanController()
	
		public function EngineCore(  ) {

			
		}
		
		public function INIT():void{
trace("[ INIT ] 		GAME ENGINE CORE ---------------------")	
			
			BOX = new Sprite()
			main.STAGE.addChild( BOX )

			
			
			ADD_RenderList()
			
			main.STAGE.addEventListener(Event.ENTER_FRAME, RenderTick)
		}
		
		private function ADD_RenderList():void{
trace("[ ADD_RenderList ] 	GAME ENGINE CORE ---------------------")			
trace("EngineUnits.VEHICLE" ,EngineUnits.VEHICLE.length)
			var vehicleList:Array = EngineUnits.VEHICLE
			var n:uint = EngineUnits.VEHICLE.length
			
			for(var i:uint=0;i<n;i++){
	
				var unit:DisplayObject = Object(EngineUnits.VEHICLE[i]).instance

trace(i, EngineUnits.VEHICLE[i],  unit.name)	
				BOX.addChild( unit  ) 	
					
			}
			
				
			
			
		}
		private function RenderTick(event:Event = null):void
		{
	
		//		trace(i, EngineUnits.VEHICLE[i],  Object(EngineUnits.VEHICLE[i]).instance)	
				
				HC.updateControl()
				Unit(EngineUnits.VEHICLE[1]).transform(HC.getControl())

		}
		
		
		//
	}
}