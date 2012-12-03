package klock.astar.tile
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import klock.astar.bot.Cannon;
	import klock.astar.grid.GRID;
	import klock.astar.grid.Gridboard;
	import klock.astar.route.Pathfinder;
	import klock.simpleComponents.components.Label;
	import klock.utils.DrawHexagon;
	
	
	public class Tile extends Sprite
	{
	
		private var _f:Number;
		public function get f():Number{ return _f;}
		public function set f(value:Number):void{ _f = value; }
				
		private var _g:Number;
		public function get g():Number{ return _g;}
		public function set g(value:Number):void{ _g = value; }
		
		private var _h:Number;
		public function get h():Number{ return _h;}
		public function set h(value:Number):void{ _h = value; }
		
		private var _parentNode:Tile;		
		public function get parentNode():Tile{ return _parentNode;}
		public function set parentNode( value:Tile ):void{ _parentNode = value;}
	
		public  var LABEL		:Label				= null;
		public  var NEIGHBORS	:Array  			= null;
//		private var GAMEBOARD	:Gridboard			= null;
	
		private var CONTAINER	:Sprite 			= null;
		public  function get container():Sprite  			{ return  CONTAINER; } 
		public  function set container( value:Sprite ):void { CONTAINER = value; } 
		
		private var POSITION 	:Point;
		public  function get Position()		   		:Point  { return POSITION;  } 
		public  function set Position( value:Point ):void   { POSITION = value; } 
		public function  setPosition( _x:Number, _y:Number ):void { this.x = _x; this.y = _y;}
		
		private var STATE		:String;
		public function get State()		:String{ return STATE; }
		public function set State( value:String ):void{ STATE = value; }	
		
		public function Tile( _x:uint, _y:uint )	
		{		

			Position = new Point( _x,_y )
				
			if( GRID.TYPE == TileType.QUAD ) {	
				// Setup ----------  Quad Tile		
				
				setPosition( _x * GRID.SIZE, _y * GRID.SIZE );
				
			}else{
				// Setup ----------  Hexagon Tile	
				setPosition( _x * ( DrawHexagon.HEXAGON.c+DrawHexagon.HEXAGON.a ), _y * ( DrawHexagon.HEXAGON.b*2) )
				this.y +=( _x%2 == 0 )? 0 : +( DrawHexagon.HEXAGON.b )
			}
			State = TileState.NONE
			HandleMouseEvents( true )	
			
			LABEL = new Label({ textAlign:"center"}, _x+" | "+ _y, this )
			LABEL.setSize( GRID.SIZE, GRID.SIZE )
			LABEL.setColor( 0xFFFFFF, .5)
				
			addChild( CONTAINER = new Sprite() )
	
		}
			
		public function Initialize():void
		{	
	
			this.NEIGHBORS = []//new Vector.<Tile>();
			
			var n:Vector.<Point> = Gridboard.Movements( GRID.TYPE == "quad" ? 2 : ( Position.x%2==0 ) ? 1 : 0 )	
			for each( var p:Point in n ){
				
				var _x:Number = p.x + Position.x; 
				var _y:Number = p.y + Position.y ; 
				
				if( Gridboard.ValidCoordinates( _x, _y) ) NEIGHBORS.push( Gridboard.tiles[ _x ][ _y ])
				
			}	

			DRAW()
		}	
		public function DRAW_TEXTURE():void
		{
			if( CONTAINER != null ) return 
			
				CONTAINER.addChild( new Cannon( POSITION.x, POSITION.y, 0 ) )
		}
		
		public function DRAW():void
		{ 
			if( GRID.TYPE == TileType.QUAD ){
				
				// Draw ----------  Quad Tile	
				
				var g:Graphics = this.graphics
				g.clear()
				g.beginFill( TileColor, 1 )
				g.drawRect( 0, 0 , GRID.SIZE, GRID.SIZE)
				
			}else{
				// Draw ----------  Hexagon Tile	
				
				DrawHexagon.DRAW( this.graphics, TileColor, 1, true )//alpha )		
			}	
			LABEL.visible = GRID.SHOWTXT
		}
			
		private function get TileColor():uint
		{
			switch ( State ) {
				case TileState.NONE:
					//if( LABEL )LABEL.alpha = .2
					return ( GRID.ALTERNATECOLOR ) ? ( Position.x%2 != Position.y%2 )?  0x444444 : 0x393939 :  0x444444
					
				break
				case TileState.SELECTED:
					//if( LABEL )LABEL.alpha = .5
					return  0xF79C0A 
					
				break 
				case TileState.ENROUTE:	
					return	0x0AA4F7
				break 
				case TileState.TOWER:
					//trace( "TOWER COLOR")
					return	0x63130F
				break 
				case TileState.START: 	
					return	0x7620BD
				break 
				case TileState.FINISH:	
					return	0xB51F7E 
				break 
			}
			
			return 0
		}
		public function HandleMouseEvents( mode:Boolean ):void
		{
			this.mouseEnabled = mode
			if( mode ){
				addEventListener( MouseEvent.CLICK, 	    HandleMouseDown,  false, 0, true );
			//	addEventListener( MouseEvent.MOUSE_OUT, 	HandleMouseLeave, false, 0, true );
			//	addEventListener( MouseEvent.MOUSE_OVER, 	HandleMouseEnter, false, 0, true );
			}else{
				removeEventListener( MouseEvent.CLICK, 	    HandleMouseDown );
			//	removeEventListener( MouseEvent.MOUSE_OUT, 	HandleMouseLeave );
			//	removeEventListener( MouseEvent.MOUSE_OVER, HandleMouseEnter );
			}	
		}
		
		private function HandleMouseDown(event:Event ):void
		{
			//		trace( "CLICK ON : " , Position)
			//		for each( var t:Tile in NEIGHBORS ) trace( t.Position )
			Gridboard.tiles[ GRID.START.x ][GRID.START.y ].parentNode = null
			var np:Vector.<Tile>
			if( this.State == TileState.TOWER ){
				
				//this.TOWER  = null;
				this.State  = TileState.NONE;
				np = Pathfinder.findPath( Gridboard.tiles[ GRID.START.x ][GRID.START.y ], Gridboard.tiles[ GRID.FINISH.x ][ GRID.FINISH.y ] )
				//if( np != null ) Gridboard.InvalidateBotRoutes( np )
			}else{
				
				if( this.State == TileState.START || this.State == TileState.FINISH ) return 
				//this.TOWER = new Sprite();
				this.State = TileState.TOWER;
		//		trace( "----------------------------------------------------------------------->1 KLICK")
				np = Pathfinder.findPath( Gridboard.tiles[0][0], Gridboard.tiles[16][11] )
				if( np == null ){
					// No valid path to calc Tower along the way
					
					this.State  = TileState.NONE;
					
					//Gridboard.InvalidateRoute()
					return
				}
		//		trace( "----------------------------------------------------------------------->1 PATH OKAY")
				Gridboard.InvalidateBotRoutes()
			}
			
			
		//	if( this.State == TileState.TOWER) DRAW_TEXTURE(); 
			
			DRAW()
		}
			
		
	}
}