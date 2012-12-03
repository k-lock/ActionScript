package klock.utils
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import klock.astar.grid.GRID;

	/**
	 * 
	 * 2010 <b>Paul Knab - DrawHexagon V.1.0</b>
	 * 
	 */	
	
	public class DrawHexagon
	{
		private static const 		SIZE		:Number = 50
		public  static function get HEXAGON()	:Object { return { a: (SIZE*.5)*.5, b:SIN60D*(SIZE*.5), c:(SIZE*.5) }} 
		private static const 		SIN60D 		:Number = 0.866 // Math.sin( 60 degree ) -> 0.8660239036822421
	
		public function DrawHexagon() { }
		public static function DRAW( graphics:Graphics, color:uint = 0xffffff, alpha:Number = 1, clear:Boolean = false, onlyOutline:Boolean = false ):void
		{
			var c:Number = HEXAGON.c
			var a:Number = HEXAGON.a		
			var b:Number = HEXAGON.b		
			var g:Graphics = graphics
			var o:Point = new Point(0,0)
 		
			if( clear )g.clear()
			if( !onlyOutline )g.beginFill( color, alpha )
			g.lineStyle( .1, color, 0.5 )
			
			// DRAW HEAGON	
			
			/*
			// North-South
			g.moveTo( 0,	a+c )
			g.lineTo( 0, 	a )
			g.lineTo( b, 	0 )
			g.lineTo( 2*b,	a )
			g.lineTo( 2*b, 	a+c )
			g.lineTo( b, 	2*c )
			g.lineTo( 0,	a+c )
			g.endFill()*/
			
			// East-West
			g.moveTo( 0		+o.x,	b 		+o.y)
			g.lineTo( a		+o.x, 	0 		+o.y )
			g.lineTo( a+c	+o.x, 	0 		+o.y )
			g.lineTo( 2*c	+o.x,	b 		+o.y )
			g.lineTo( a+c	+o.x, 	2*b 	+o.y )
			g.lineTo( a		+o.x, 	2*b 	+o.y )
			g.lineTo( 0		+o.x,	b 		+o.y )
			g.endFill()	
				

		}
		
	}
}