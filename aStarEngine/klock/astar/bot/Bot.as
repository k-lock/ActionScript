package klock.astar.bot
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import klock.astar.grid.GRID;
	import klock.astar.grid.Gridboard;
	import klock.astar.route.Pathfinder;
	import klock.astar.tile.Tile;
	import klock.astar.tile.TileState;
	import klock.simpleComponents.components.Label;

	public class Bot extends BitmapAtlas
	{
	
		private var _path			:Vector.<Tile>
		private var _pathIndex		:int = 0 

		public function Bot( _type:uint, path_:Vector.<Tile> )
		{
			name = "NORMAL"
			_path = path_

				
			this.x = _path[0].Position.x*GRID.SIZE
			this.y = _path[0].Position.y*GRID.SIZE

			AWAKE		( Asset.getTexture( "enemys").bitmapData )	
			
			SetSpriteRectangles( _type );
	
			CHANGE_TILE()
			UPDATE_Position()

		}
	//	private var 	_currentTile					:Tile
	//	public function set 	CurrentTile( tile:Tile ):void { _currentTile = tile }
		public function get 	CurrentTile()			:Tile { return  _path[ _pathIndex ] }
		public function get 	NextTile()				:Tile {
			if ( _path != null && _pathIndex < _path.length - 1)
				
				return _path[ _pathIndex+1 ];
			else
				return null;
		}

		public function UPDATE_Position():void
		{
			if ( _path == null || this == null ){ 
				if  ( NextTile == null ) OnCompleted();
				return;
			}
			if( _change )
			{
				var distance :Number =  Point.distance( new Point(x,y ), new Point( CurrentTile.x,  CurrentTile.y));

				var tile:Tile = ( distance > 50 ) ? NextTile : CurrentTile
				distance =  Point.distance( new Point(x,y ), new Point( tile.x,  tile.y));
				
				if( distance > 5 ){
				
				var yDistance	:Number = (tile.y) - y;
				var xDistance	:Number = (tile.x ) - x;
				var radian		:Number = Math.atan2( yDistance, xDistance );
				
				x += Math.cos(radian) * speed;
				y += Math.sin(radian) * speed;
				
				}else{
					_change = false
				}
				
			}else{
				if ( _path == null || this == null ){ 
					if  ( NextTile == null ) OnCompleted();
					return;
				}
				var distanceToNext	:Number =  Point.distance( new Point(x,y ), new Point( NextTile.x,  NextTile.y));
	
				if( distanceToNext < 5 ){
					
					_path[ _pathIndex ].State = TileState.NONE
					_path[ _pathIndex ].DRAW()
	
					++_pathIndex;
										
					if ( _pathIndex >= _path.length - 1) {
						OnCompleted();
						return;
					}
					
				}
									
			MoveControler()
			CHANGE_TILE()
			
			}
		}
		
		private var 			speed				:uint;
		public function get 	Speed()	    		:uint		{ return  speed; } 
		public function set 	Speed( value		:uint ):void{ speed = value; } 
		
		private function MoveControler( ):void {  
			
			var yDistance	:Number = (NextTile.y) - y;
			var xDistance	:Number = (NextTile.x ) - x;
			var radian		:Number = Math.atan2( yDistance, xDistance );
			
			x += Math.cos(radian) * speed;
			y += Math.sin(radian) * speed;
			
		//	if( y > 535 ) y = 535
			
		//	var rotDelta:Number = Number( (radian * 180 / Math.PI) )
		//	rotation = rotDelta 
			
		}
		
		private function OnCompleted():void {
			
			//ClearRoute();
			//_path = null
		
			Gridboard.RemoveBot(this);
		}
		
		public function Die():void {
			OnCompleted();
		}
		
		public var _change:Boolean = false
		public function SetRoute():void
		{
			var ts:uint = Speed
			
			var distance :Number =  Point.distance( new Point(x,y ), new Point( NextTile.x,  NextTile.y));	
			var tile:Tile = ( distance < 25 ) ? NextTile : CurrentTile
			//distance =  Point.distance( new Point(x,y ), new Point( tile.x,  tile.y));
				
				
				
			//var tp:Tile = CurrentTile
			tile.parentNode = null
			Speed = 0
			_change = true

			_path = Pathfinder.findPath( tile, Gridboard.tiles[16][11] )
		//	_path.unshift( tp) 
			
			if( _path != null )
			{
				_pathIndex  = 0
					
			
				Speed = ts					
				Gridboard.DrawBotPath( _path )
				_change = false
			}
	
			
		}
	
		
		private function ClearRoute():void {
			for each ( var tile:Tile in _path) if( tile.State == TileState.ENROUTE )  tile.State = TileState.NONE;
		}
	
		private function SetSpriteRectangles( _type:uint ):void
		{
			var v:Vector.<Rectangle> = new Vector.<Rectangle>()
			if( _type == 0) {
				Speed = 5
				SIZER.push(new Rectangle(  10,10,44,46 ),
								new Rectangle(  65,10,44,47 ),
								new Rectangle( 120,10,46,47 ),
								new Rectangle( 175,10,47,47 ),
								new Rectangle( 230,10,51,47 ),
								new Rectangle( 285,10,45,44 ),
								new Rectangle( 340,10,44,49 ),
								new Rectangle( 395,10,44,46 ));
			}else if( _type == 1)
			{
				Speed = 10
				SIZER.push(new Rectangle(  10,90,32,39 ),
								new Rectangle(  65,90,33,34 ),
								new Rectangle( 120,90,31,40 ),
								new Rectangle( 175,90,32,35 ),
								new Rectangle( 230,90,32,40 ),
								new Rectangle( 285,90,32,39 ),
								new Rectangle( 340,90,32,36 ),
								new Rectangle( 395,90,33,41 ));
			}else if( _type == 2 )
			{
				Speed = 7
				SIZER.push(new Rectangle(  10,160,27,24 ),
								new Rectangle(  65,160,26,24 ),
								new Rectangle( 120,160,29,26 ),
								new Rectangle( 175,160,26,23 ),
								new Rectangle( 230,160,27,26 ),
								new Rectangle( 285,160,26,25 ),
								new Rectangle( 340,160,25,24 ),
								new Rectangle( 395,160,24,24 ));
			}
			
		}
		
		//---------------------
	}
}
