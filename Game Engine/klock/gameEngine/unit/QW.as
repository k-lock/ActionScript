package klock.gameEngine.unit
{
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class QW extends Unit
	{
		public function QW(position:Object)
		{
			var instance:Sprite = initUnit()
			
			super( instance, (position == null)? {x:300, y:300  , z:0, rotationX:0, rotationY:0, rotationZ:0, alpha:1} : position );
			
		}
		private function initUnit():Sprite{
			
			var unit:Sprite = new Sprite()
			unit.name = "UNIT_0"
			
			var g:Graphics = unit.graphics
			g.beginFill(0xcc3399, .8)
			g.drawRect( -25, -50, 50, 100)
			
			g.lineStyle(1, 0x999999, 0.8)
			g.moveTo(-25,0)
			g.lineTo(25,0)
			g.moveTo(0,-50)
			g.lineTo(0,50)
			
			return unit
		}
	}
}