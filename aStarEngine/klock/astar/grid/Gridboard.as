package klock.astar.grid
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import klock.astar.bot.Bot;
	import klock.astar.route.Pathfinder;
	import klock.astar.tile.Tile;
	import klock.astar.tile.TileState;
	import klock.astar.tile.TileType;
	
	public class Gridboard extends Sprite
	{
		public static var 	tiles  	:Vector.<Vector.<Tile>> = null //new Vector.<Vector.<Tile>>()
		public static var 	bots	:Vector.<Bot> 		    = new Vector.<Bot>()
		
		/** Container Object for all Tiles 		*/ public  static var 	TILES		:Sprite = null
		/** Container Object for all Critters 	*/ private static var 	CRITTERS	:Sprite = null
		
			
		public static var BOOM:Boolean = false
	//	public var 			LAYERS		:Sprite = null
		
	//	private static var 	logic		:RouteLogic = null;
		
		public function Gridboard()
		{
			trace( "Gridboard -- " , GRID.TYPE, GRID.SIZE, GRID.CountX, GRID.CountY)
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage);
		}		
		/** Called when the component is added to the stage. */
		private function onAddedToStage( event:Event ):void
		{
	//		_stage = stage;
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage);
			
			addChild( TILES    = new Sprite() )
			addChild( CRITTERS = new Sprite() )
			//		addChild( LAYERS   = new Sprite() )
			
		//	TILES.x  = TILES.y		= 150
		//	CRITTERS.x = CRITTERS.y = 150;
			//		LAYERS.x = LAYERS.y	    = 50;
			
			//INIT()
		}
		
		public static function INIT():void{
			TilesInit()
		}
		public static var startTile	:Tile
		public static var endTile	:Tile
		
		public static function set TilesPosition( value:Point ) : void { TILES.x  = value.x; TILES.y = value.y; }
		public static function get TilesPosition()				: Point{ return new Point(  TILES.x,  TILES.y ) }
		
		public static function TilesInit():void{
	
			if( tiles != null )while( TILES.numChildren > 0 ) TILES.removeChildAt( 0 )
	
			tiles = new Vector.<Vector.<Tile>>()
			for (var _x:uint = 0; _x < GRID.CountX; ++_x) {
				
				var row:Vector.<Tile> = new Vector.<Tile>();
				tiles.push(row);
				
				for (var _y:uint = 0; _y < GRID.CountY; ++_y) {
					
					var tile:Tile = new Tile( _x, _y );
					row.push(tile);
					
					TILES.addChild(tile);
				}
			}
		
	
	//		logic = new RouteLogic( endTile );
			
			//	this.CreateCritter( )
			
		//	
			SetupRoute()
			InitializeTiles()
		//	RandomTowers()
		}
		
//---------------------------------------------------------------------------------- GAME TICK / TIMER	
		
		private static var gameTimer:Timer

		public static function StartGameTick():void
		{
			var _interval:uint = 25
			gameTimer = new Timer( _interval )
			gameTimer.addEventListener(TimerEvent.TIMER, GameTick )
			gameTimer.start()
		}
		
		public static function StopGameTick():void
		{
			gameTimer.removeEventListener(TimerEvent.TIMER, GameTick )
			gameTimer.stop()
		}
		
		public static function GameTick( event:Event ):void
		{
//			trace("GameTick", Gridboard.bots.length )
			
			for each( var bot:Bot in Gridboard.bots)
			{
				if( bot != null )
				{
					if( !bot._change )bot.UPDATE_Position()				
				}
				
			}
		}

		
//---------------------------------------------------------------------------------- PUBLIC METHODS		
		
		public static function CreateBot( typ:uint ):void
		{

			Gridboard.tiles[GRID.START.x][GRID.START.y].parentNode = null
			var path:Vector.<Tile> = Pathfinder.findPath( Gridboard.tiles[GRID.START.x][GRID.START.y], Gridboard.tiles[GRID.FINISH.x][GRID.FINISH.y] )

			var bot:Bot = new Bot( typ, path )
			
			CRITTERS.addChild( bot ) 
			bots.push( bot )
		}
		
		public static function RemoveBot( bot:Bot ):void {
			
			CRITTERS.removeChild( bot );
			bots.splice( bots.indexOf( bot ), 1)
			
		}
				
		public static function SetupRoute():void
		{

			tiles[ GRID.START.x][ GRID.START.y].State = TileState.START
			tiles[GRID.FINISH.x][GRID.FINISH.y].State = TileState.FINISH	
				
			tiles[  GRID.START.x ][  GRID.START.y ].DRAW();
			tiles[ GRID.FINISH.x ][ GRID.FINISH.y ].DRAW();

		}
			
		/** Return a Vector Array contain all Tiles.*/
		public static function get AllTiles():Vector.<Tile> {
			
			var v:Vector.<Tile> = new Vector.<Tile>()
			
			for each( var row:Vector.<Tile> in tiles)
			for each( var tile:Tile in row )
			v.push( tile )
			
			return v
		}
		
		/** Check if coordinates in valid space.*/
		public static function ValidCoordinates( _x:int , _y:int ):Boolean
		{
			if ( _x < 0 )  { return false; }
			if ( _y < 0 )  { return false; }
			if ( _x > GRID.CountX-1  ) { return false; }
			if ( _y > GRID.CountY-1 ) { return false; }
			
			return true;
		}
		
		/** Return a Vector Array with Move Directions.*/
		public static function Movements( typ:uint ):Vector.<Point> 
		{ 
			var MOVEMENTS:Vector.<Point> = new Vector.<Point>()	
			if( typ==0 ){
				MOVEMENTS.push( new Point( 0, -1), new Point( 1,  0), new Point( 1,  1), new Point( 0,  1), new Point(-1,  1), new Point(-1,  0) );
			}else if( typ ==1 ){
				MOVEMENTS.push( new Point( 0, -1), new Point( 1, -1), new Point( 1,  0), new Point( 0,  1), new Point(-1,  0), new Point(-1, -1) );				
			}else if( typ ==2 ){
				MOVEMENTS.push( new Point( 0, -1), new Point( 1,  0), new Point( 0,  1), new Point( -1,  0) );				
			}
			return MOVEMENTS
		}
		/** Draw all Tiles in AllTiles.*/
		public static function DrawAllTiles():void {
			for each ( var tile:Tile in AllTiles ) if ( tile.State != TileState.ENROUTE ) tile.DRAW();
		}
		/** Initialize all Tiles in AllTiles.*/
		public static function InitializeTiles():void {
			for each ( var tile:Tile in AllTiles ) tile.Initialize();
		}		
		/** Reset all Tiles in AllTiles to TileState.NONE .*/
		public static function InvalidateTiles():void {
			for each ( var tile:Tile in AllTiles ) tile.State = TileState.NONE;
		}
		/** Reset all Tiles on the current Route to TileState.NONE .*/
		public static function InvalidateRoute():void { 
			for each ( var tile:Tile in AllTiles )
			{	
				if (tile.State == TileState.ENROUTE){ tile.State = TileState.NONE;  tile.DRAW(); }
			}
		}
		
		/** Draw a Path from the current Bot*/
		public static function DrawBotPath( p:Vector.<Tile> ):void {
			for each ( var tile:Tile in p ) if (tile.State == TileState.ENROUTE)tile.DRAW(); 
		}
		
		/** Invalidate Bot.Route for each Bot in Container*/
		public static function InvalidateBotRoutes():void {
			
			InvalidateRoute()

			for each ( var bot:Bot in bots ) bot.SetRoute();
			
		}
		/** Reset all Tiles on the current Route to TileState.NONE .*/
		public static function InvalidateTowers():void {
			for each ( var tile:Tile in AllTiles ) if (tile.State == TileState.TOWER){  tile.State = TileState.NONE;  tile.DRAW(); }
		}
		/** Sets random generated towers in the grid*/
		public static function RandomTowers():void {
			InvalidateTowers()
			for each (  var tile:Tile in AllTiles )
			{
				if( uint((Math.random()*100)/10) == 0 )
				{ 
					if( tile.State == TileState.FINISH || tile.State == TileState.START ) continue; 
					tile.State = TileState.TOWER;
					tile.DRAW();
					
					//trace( tile.Position, tile.State)
				}
			}
			DrawAllTiles()
		}
	//	public static function get RouteTiles():Array{ return [ tiles[GRID.START.x][GRID.START.y], tiles[GRID.FINISH.x][GRID.FINISH.y] ];}
		
		//---------------------------------------------------------------------------------- GETTER / SETTERS	
		
	}
}