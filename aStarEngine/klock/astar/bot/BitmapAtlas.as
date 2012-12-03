
package klock.astar.bot
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import klock.astar.grid.GRID;
	import klock.astar.tile.Tile;

	
	public class BitmapAtlas extends Sprite
	{
		private var SPRITE				:Shape
		private var CANVAS				:BitmapData;

		private  var Sizer				:Vector.<Rectangle>	= null;
		public function get SIZER()		:Vector.<Rectangle> 		{ return  Sizer; } 
		public function set SIZER( value:Vector.<Rectangle> ):void 	{ Sizer = value; } 
		
		private  var Atlas 				:BitmapData
		public function get ATLAS()		:BitmapData 		{ return  Atlas; } 
		public function set ATLAS( value:BitmapData ):void 	{ Atlas = value; } 

		protected  var Index				:int = 0;
		public function get INDEX	()	:int 				{ return  Index; } 
		public function set INDEX	( value:int )	:void	{ Index = value; } 

		public function BitmapAtlas() 
		{ 
		 addChild( SPRITE = new Shape())
		}
	
		/**
		 * 	Initialize method
		 */
		public function AWAKE(  atlas:BitmapData, autoDraw:uint = 1 ):void{
			
			ATLAS = atlas
			CANVAS = new BitmapData( ATLAS.width, ATLAS.height , true, 0x000000);
			SIZER  = new Vector.<Rectangle>()
		
		}
		
		/**
		 * 	Render current tile from Atlas Picture
		 */
		private function DRAW_CURRENT_TILE():void{
	
			CANVAS.fillRect( new Rectangle(0, 0, ATLAS.width, ATLAS.height), 0x000000 );
			CANVAS.copyPixels( ATLAS, SIZER[ INDEX ],  new Point( 0,0 ), null, null, true);

			var g:Graphics = SPRITE.graphics
				g.clear()
				g.beginBitmapFill( CANVAS, null ) 
				g.drawRect( 0 ,0, SIZER[INDEX].width,SIZER[INDEX].height) 
				g.endFill()
				
	
			SPRITE.x = -SIZER[INDEX].width*.5 + ( GRID.SIZE * .5 )
			SPRITE.y = GRID.SIZE - SIZER[INDEX].height

		}
		/**
		 * 	Setup the tile index 
		 */
		public function CHANGE_TILE():void
		{
			Index = VALID_INDEX( ++Index );
			DRAW_CURRENT_TILE();
		}
		
		/**
		 * 	Check if the value is right 
		 */
		private function VALID_INDEX( value:int ):int
		{
			if( value < 0  || value > SIZER.length-1 ) { value = 0; }

			return value;
		}
		
		
		
	}
}