package klock.astar.editor
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	import klock.astar.bot.Bot;
	import klock.astar.grid.*;
	import klock.astar.route.*;
	import klock.astar.tile.*;
	import klock.simpleComponents.components.*;
	
	public class EditorUI extends Sprite
	{
		
		private var GAMETICK	:Boolean = false
		
	//	private var _stage		:Stage
		private var _back		:Shape
		private var _container	:Sprite
			
		private var BUTTON_changeGrid	:Button
		private var BUTTON_findRoute  	:Button
		private var STEP_size		:NumStep
		private var STEP_cx			:NumStep
		private var STEP_cy			:NumStep
		private var STEP_px			:NumStep
		private var STEP_py			:NumStep
		private var RADIO_quad		:RadioButton
		private var RADIO_hexa		:RadioButton
		//-------------
		private var CHECK_srou		:CheckBox
		private var CHECK_acol		:CheckBox
		private var CHECK_itxt		:CheckBox
		private var CHECK_bran		:CheckBox
		//-------------
		private var INPUT_sx		:IntField
		private var INPUT_sy		:IntField
		private var INPUT_ex		:IntField
		private var INPUT_ey		:IntField
		//------------
		private var COMBO_routFu	:ComboBox
		private var LABEL_waypoints :Label
		
		public function EditorUI()
		{
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage);
		}		
		/** Called when the component is added to the stage. */
		private function onAddedToStage( event:Event ):void
		{
	//		this.x = stage.stageWidth - 100
			INIT()
			this.alpha = .4
		}
	
		private function INIT():void{
			
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage);
			
			addChild( _back      = new  Shape() )
			addChild( _container = new Sprite() )

			_container.name = "EditorUI"
			_container.y = 0
			
			var plus:uint = 0	
		//TILE SETUP ----------------		
		var p1:Panel  = new Panel			( {x:0,  y: 20, name:"TILE_PANEL"}, _container ); p1.setSize( 100, 70 ); p1.color = 0xEDEDED;
			var b1:Button = new Button		( {x:0,  y:	 0, name:"BTN1" },"Tile", _container)	
			
			// GRID SIZE
			var l:Label  = new Label		( {x:0,	 y:5, textAlign:"left" }, "Size", p1 )
			STEP_size 	 = new NumStep		( {x:40, y:5, _width:58, _height:15 }, GRID.SIZE, p1, onChangeSetup )
		
			// GRID TYPE
			var l1:Label  = new Label		( {x: 0,  y:20, textAlign:"left" },"Type", p1 )
			RADIO_quad    = new RadioButton	( {x: 25, y:20 }, "quad",    p1, onChangeSetup );RADIO_quad.selected = true;
			RADIO_hexa 	  = new RadioButton	( {x: 25, y:32 }, "hexagon", p1, onChangeSetup )
		
		//GRID SETUP ----------------	
		var p2:Panel  = new Panel     		( {x:0,  y: p1.y+p1.height, name:"GRID_PANEL" }, _container ); p2.setSize( 100, 140 ); p2.color = 0xEDEDED;
			var b2:Button = new Button 		( {x:0,  y:p2.y-19,     name:"BTN2" },"Grid", _container)	
			// COUNT X
			var l2:Label  = new Label  		( {x:0,  y:4, textAlign:"right", _width:40 },"Count X", p2)
			STEP_cx 	  = new NumStep		( {x:40, y:4, _width:57, _height:15 }, GRID.CountX	 , p2, onChangeSetup )
			// COUNT Y
			var l3:Label  = new Label  		( { x:0, y:20, textAlign:"right", _width:40},"Count Y", p2)
			STEP_cy 	  = new NumStep		( {x:40, y:20, _width:57, _height:15 }, GRID.CountY	 , p2, onChangeSetup )

			// POSITION GRID X
			var l4:Label  = new Label  		( {x:0,  y:40, textAlign:"right", _width:40 },"Pos X"	 , p2)
			STEP_px 	  = new NumStep		( {x:40, y:40, _width:57, _height:15 }, PathEditor.board.x , p2, onChangeSetup )
			// POSITION GRID Y
			var l5:Label  = new Label  		( {x:0,  y:56, textAlign:"right", _width:40},"Pos Y"	 , p2)
			STEP_py 	  = new NumStep		( {x:40, y:56, _width:57, _height:15 }, PathEditor.board.y , p2, onChangeSetup )	
				
			// ALTERNATE COLOR
			CHECK_acol = new CheckBox  		( {x: 0, y:70 }, "Alternate Color",  p2, onChangeSetup );  CHECK_acol.selected = GRID.ALTERNATECOLOR;
			// SHOW INDEX TEXTFIELD IN TILE
			CHECK_itxt = new CheckBox  		( {x: 0, y:84 }, "Show Index Text",  p2, onChangeSetup );  CHECK_itxt.selected = GRID.SHOWTXT;
			// BUILD RANDOM TOWERS
			CHECK_bran = new CheckBox		( {x: 0, y:98 }, "Build Rnd Tower", p2, onChangeSetup );CHECK_bran.selected = false;
		
		//ROUTE SETUP ----------------	
			var p3:Panel  	  = new Panel   ( {x:0, y:  p2.y+p2.height, name:"ROUTE_PANEL" }, _container ); p3.setSize( 100, 90 ); p3.color = 0xEDEDED;		
			var b9:Button = new Button 		( {x:0, y:p3.y-19,     name:"BTN3" },"ROUTE" , _container)	

			// POSITION START
			var l6:Label  = new Label 	( {x:0,  y:5 , textAlign:"left" },"Start"	, p3 )
			INPUT_sx 	  = new IntField( {x:40, y:4, _width:20, _height:15 }, GRID.START.x, p3 , onChangeSetup )
			var l7:Label  = new Label   ( {x:61, y:5, textAlign:"left"},"|"			, p3 )
			INPUT_sy 	  = new IntField( {x:70, y:4, _width:20, _height:15 }, GRID.START.y, p3 , onChangeSetup )
			// POSITION END
			var l8:Label  = new Label   ( {x:0,  y:20, textAlign:"left"},"Finish"	, p3 )
			INPUT_ex 	  = new IntField( {x:40, y:21, _width:20, _height:15 }, GRID.FINISH.x, p3 , onChangeSetup )
			var l9:Label = new Label    ( {x:61, y:20, textAlign:"left"},"|"		, p3 )
			INPUT_ey 	  = new IntField( {x:70, y:21, _width:20, _height:15 }, GRID.FINISH.y, p3 , onChangeSetup )
			
				// ROUTE STYLE
			var l11:Label  = new Label 	( {x:0,  y:38 , textAlign:"left" },"Type"	, p3 )
			COMBO_routFu = new ComboBox ( {x:25, y:40, name:"ROUTE_FUNCT" }, "", p3, [ "diagonal", "euclidian", "manhattan"], ChangeRouteFunction ); 
			COMBO_routFu.setSize( 70, 16 )	
			COMBO_routFu.numVisibleItems = 3
			COMBO_routFu.selectedIndex = 0
			COMBO_routFu.autoHideScrollBar = true
			
			var l12:Label  = new Label 	( {x:0,  y:55 , textAlign:"left" },"Waypoints   [       ]"	, p3 )
			LABEL_waypoints = new Label ( {x:58,  y:55 , textAlign:"center", _width: 25 }, "", p3 )
	
		//ENEMY SETUP ----------------	
		var p4:Panel  	  = new Panel  ( {x:0, y:p3.y+p3.height, name:"BOT_PANEL" }, _container ); p4.setSize( 100, 20 ); p4.color = 0xEDEDED;		
			var b8:Button = new Button ( {x:0, y:p4.y-19,     name:"BTN3" },"Enemy" , _container)	
			
			// BOT TYPE
			var l10:Label  = new Label 	( {x:0,  y:2 , textAlign:"left" },"Type"	, p4 )
			var cb1:ComboBox = new ComboBox( {x:25, y:2 }, "", p4, [ "BOT I","BOT II", "BOT III"], onBotTypeChange); 
				cb1.setSize( 70, 16 )	
				cb1.numVisibleItems = 3
				cb1.selectedIndex = 0
				cb1.autoHideScrollBar = true
	
		// BUTTON BOARD ---------------------------------------				
			
			plus = p4.y+p4.height	
			BUTTON_changeGrid = new Button( { name:"BTN3", x:0, y:plus }	,"Use new Settings"	, _container, onCopyTo )	
			BUTTON_findRoute  = new Button( { name:"BTN4", x:0, y:plus+=BUTTON_changeGrid.height },"Find Route"		, _container, onFindRoute )
			var b20:Button    = new Button( { name:"BTN5", x:0, y:plus+=BUTTON_findRoute.height  },"Create Bot"		, _container, onCreateBot )
			var b21:Button    = new Button( { name:"BTN6", x:100, y:0, Toggled:true },"Start GameTick"		, _container , onGameTick)
			b1.Enabled = b2.Enabled = b9.Enabled = b8.Enabled = false
			var g:Graphics = _back.graphics
			g.beginFill( 0xDEDEDE, 1)
			g.drawRect( 0,0, 100, _container.height +20)
			g.lineStyle( 1, 0x454444 ) 
		
			
			ActivatedChangeBTN( false )

		}
		
		//---------------------------------------------------------------------------------- EVENTS
		private function onCreateBot( event:Event ):void
		{
			Gridboard.CreateBot( BOT_TYPE )
		}
		
		private var BOT_TYPE:uint = 0
		private function onBotTypeChange( event:Event ):void
		{
			BOT_TYPE = ComboBox(event.target).selectedIndex
		}
		
		private function onGameTick( event:Event ):void
		{
			GAMETICK = !GAMETICK;
			
			if( GAMETICK )
				Gridboard.StartGameTick()
			else
				Gridboard.StopGameTick()
		}
		
		private function onFindRoute( event:Event ):void
		{
			
			Gridboard.InvalidateRoute();
	
			SetRouteFunct()
			
			var np:Vector.<Tile> = Pathfinder.findPath( Gridboard.tiles[GRID.START.x][GRID.START.y], Gridboard.tiles[GRID.FINISH.x][GRID.FINISH.y] )
			
			if( np == null ){
				// No valid path to calc Tower along the way
				trace( "PATH == null")
				return
			}
			
			Gridboard.InvalidateRoute();
			
			for each( var tile:Tile in np ){
				if( tile.State != TileState.FINISH && tile.State != TileState.START )tile.State = TileState.ENROUTE;
				tile.DRAW()	
			}
	
			LABEL_waypoints.text = uint(np.length).toString()
				
		}
		
		private function onChangeSetup( event:Event ):void
		{

			var parent:Sprite = Sprite(event.target).parent as Sprite
			
			if( event.target == RADIO_quad )
			{
				RADIO_quad.selected = true
				RADIO_hexa.selected = false
		
			}else if( event.target == RADIO_hexa ){
				
				RADIO_quad.selected = false
				RADIO_hexa.selected = true
			
			}else if( event.target == CHECK_acol ){ 
				
				GRID.ALTERNATECOLOR = CHECK_acol.selected
				Gridboard.DrawAllTiles()
				return
				
			}else if( event.target == CHECK_itxt ){
				
				GRID.SHOWTXT = CHECK_itxt.selected
				for each( var tile:Tile in Gridboard.AllTiles ) tile.LABEL.visible = CHECK_itxt.selected
				return
	
		  	}else if( event.target == INPUT_sx ){ SetupInputValues( INPUT_sx, GRID.CountX-1 )	
		  	}else if( event.target == INPUT_sy ){ SetupInputValues( INPUT_sy, GRID.CountY-1 )
			}else if( event.target == INPUT_ex ){ SetupInputValues( INPUT_ex, GRID.CountX-1 )	
			}else if( event.target == INPUT_ey ){ SetupInputValues( INPUT_ey, GRID.CountY-1 )
				
			}else if( event.target == STEP_px ) { PathEditor.board.x = STEP_px.value 
			}else if( event.target == STEP_py ) { PathEditor.board.y = STEP_py.value 
			}else if( event.target == STEP_cx ) {
				if(INPUT_sx.value <0 || INPUT_sx.value > STEP_cx.value-1 ) INPUT_sx.value = STEP_cx.value-1
				if(INPUT_ex.value <0 || INPUT_ex.value > STEP_cx.value-1 ) INPUT_ex.value = STEP_cx.value-1
			}else if( event.target == STEP_cy ) {
				if(INPUT_sy.value <0 || INPUT_sy.value > STEP_cy.value-1 ) INPUT_sx.value = STEP_cy.value-1
				if(INPUT_ey.value <0 || INPUT_ey.value > STEP_cy.value-1 ) INPUT_ey.value = STEP_cy.value-1
			}else if( event.target == CHECK_bran ){
				if( CHECK_bran.selected )
				{
					Gridboard.RandomTowers()
				}else{
					Gridboard.InvalidateTowers()
				}
				
				return
					trace( "HELLO")
			}
		
			ActivatedChangeBTN( true )
		}
		
		private function ChangeRouteFunction(event:Event):void
		{
			SetRouteFunct()
		}
		private function SetRouteFunct():void
		{
			switch( COMBO_routFu.selectedIndex )
			{
				case 0: Pathfinder.heuristic = Pathfinder.diagonalHeuristic
					break
				case 1: Pathfinder.heuristic = Pathfinder.euclidianHeuristic
					break
				case 2: Pathfinder.heuristic = Pathfinder.manhattanHeuristic
					break
			}
		}
		
		private function SetupInputValues( comp:IntField, gridValue:uint ):void
		{
			var p1:Point = new Point(INPUT_sx.value, INPUT_sy.value)
			var p2:Point = new Point(INPUT_ex.value, INPUT_ey.value)
			
			comp.value = ( p1.x == p2.x && p1.y == p2.y ) ? gridValue : CheckInputValues( comp.value, gridValue );
			comp.Draw()

		}

		private function CheckInputValues( v1:int, v2:int ):int
		{
			if( v1 < 0 ) v1 = 0
			if( v1 > v2) v1 = v2
			
			return v1
		}

		private function onCopyTo( event:Event ):void
		{
			trace( "WRITE TO")	
			GRID.CountX = STEP_cx.value
			GRID.CountY = STEP_cy.value
			GRID.SIZE   = STEP_size.value
			GRID.TYPE   = ( RADIO_quad.selected ) ? TileType.QUAD : TileType.HEXAGON
			GRID.START.x   = INPUT_sx.value
			GRID.START.y   = INPUT_sy.value
			GRID.FINISH.x  = INPUT_ex.value
			GRID.FINISH.y  = INPUT_ey.value
			

			ActivatedChangeBTN( false )

		}
		//---------------------------------------------------------------------------------- PRIVATE METHODS	
		
		
		
		private function ActivatedChangeBTN( mode :Boolean = true ) :void {

			BUTTON_changeGrid.Enabled = (mode) ? CHECK_PORTS() : false
			//if( BUTTON_changeGrid.Enabled )BUTTON_drawGrid.Enabled = true
			Gridboard.INIT()
		}
		
		private function CHECK_PORTS():Boolean{
			
			var _type:String = ( RADIO_quad.selected ) ? TileType.QUAD : TileType.HEXAGON
		
			if( GRID.TYPE   != _type )						return true;
			if( GRID.CountX != new uint(STEP_cx.value) )	return true;
			if( GRID.CountY != new uint(STEP_cy.value) )	return true;
			if( GRID.SIZE   != new uint(STEP_size.value) )	return true;
			if( GRID.SIZE   != new uint(STEP_size.value) )	return true;
			if( GRID.START.x  != INPUT_sx.value )		return true;
			if( GRID.START.y  != INPUT_sy.value )		return true;
			if( GRID.FINISH.x != INPUT_ex.value )		return true;
			if( GRID.FINISH.y != INPUT_ey.value )		return true;
			
			
			return false
		}
		
		//---------------------------------------------------------------------------------- PUBLIC METHODS
		//---------------------------------------------------------------------------------- GETTER / SETTERS
		
		public function get SHOW_INDEX_TXT():Boolean { return CHECK_itxt.selected }
		public function get SHOW_ALT_COLOR():Boolean { return CHECK_acol.selected }
		
		private var gridPos:Point = new Point(0,0)
		public function get GRID_POSITION():Point{ return gridPos }
		
		public function set START_POS( p:Point ):void { INPUT_sx.value = p.x; INPUT_sy.value = p.y;  }
		public function set   END_POS( p:Point ):void { INPUT_ex.value = p.x; INPUT_ey.value = p.y;  }
	}
}