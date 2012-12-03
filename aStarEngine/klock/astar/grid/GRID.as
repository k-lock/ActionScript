package klock.astar.grid
{
	
	import flash.geom.Point;
	
	import klock.astar.tile.TileType;
		
	
	public class GRID
	{	

		public static var ALTERNATECOLOR	:Boolean	= true;
		public static var SHOWTXT			:Boolean	= true;
		

		/** Tile Element Symboltype [ QUAD, HEXAGON ]*/
		public static var 	TYPE 		:String	= TileType.QUAD;
		/** Tile Element Symbolsize */
		public static var 	SIZE		:Number	= 50
		
		/** Horizontal width of the grid */
		public static var 	CountX		:uint  	= 17;
		/** Vertical height of the grid */
		public static var 	CountY		:uint  	= 12;
		
		/** The start position for enemy bots in grid space. */
		public static var 	START		:Point  	= new Point(0,0);
		/** The finish position for enemy bots in grid space. */
		public static var 	FINISH		:Point  	= new Point(16,11);

		public function GRID()
		{}
	}
}