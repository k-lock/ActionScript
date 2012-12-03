package klock.gameEngine.controller
{
	
	import flash.display.DisplayObject;
	import flash.ui.Keyboard
	import klock.key.KeyPoll;
	
	public class HumanController
	{

		private var controlObject	:Object
		private var lastMouseX		:Number
		private var lastMouseY		:Number
		private var key				:KeyPoll
		
		public function HumanController()
		{
			lastMouseX = main.STAGE.mouseX
			lastMouseY = main.STAGE.mouseY
			
			key = new KeyPoll( main.STAGE as DisplayObject )
		}
		
		public function getControl():Object { return controlObject }
		
		public function updateControl():void {
			// getting up, down, left, right from keyboard
			var v:Number = 0
			var h:Number = 0
	
			if (key.isDown(Keyboard.UP))trace("KEY UP")	//v++
			if (key.isDown(Keyboard.DOWN))	v-- 
			if (key.isDown(Keyboard.LEFT)) 	h--
			if (key.isDown(Keyboard.RIGHT)) h++
				
			// calculating movement of mouseX and mouseY
			var mouseXdist:Number = lastMouseX-main.STAGE.mouseX
			var mouseYdist:Number = lastMouseY-main.STAGE.mouseY
			
			lastMouseX = main.STAGE.mouseX
			lastMouseY = main.STAGE.mouseY
			
			// creates new controlObject
			controlObject = {x:mouseXdist , y:mouseYdist}// , mouseDistX:mouseXdist , mouseDistY:mouseYdist , newLastPosition:false}
		}
		
		
	}
}