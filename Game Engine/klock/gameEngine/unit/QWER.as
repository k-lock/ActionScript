package klock.gameEngine.unit
{
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class QWER extends Unit{
		
		
		public function QWER( position:Object = null ) {
			
			var instance:Sprite = initUnit()

			super( instance, (position == null)? {x:50, y:50, z:0, rotationX:0, rotationY:0, rotationZ:0, alpha:1} : position );

		}
		private function initUnit():Sprite{
			
			var unit:Sprite = new Sprite()
			unit.name = "UNIT_0"
			
			var g:Graphics = unit.graphics
			g.beginFill(0xFF6600, .8)
			g.drawRect( -25, -25, 50, 50)
			
			g.lineStyle(1, 0x999999, 0.3)
			g.moveTo(-25,0)
			g.lineTo(25,0)
			g.moveTo(0,-25)
			g.lineTo(0,25)
			
			return unit
		}
		
		
		
		
		//
	}
}