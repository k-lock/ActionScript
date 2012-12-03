package klock.astar.editor
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	
	import klock.astar.grid.*;
	import klock.astar.route.Pathfinder;
	import klock.astar.tile.*;
	import klock.utils.DrawHexagon;

	public class PathEditor extends Sprite
	{
		
		private var 		editor		:EditorUI
		public static var 	board		:Gridboard

		public function PathEditor()
		{
			
		//	GRID.START  = new Point(  0, uint( GRID.CountY*.5) )
		//	GRID.FINISH = new Point(  GRID.CountX, uint( GRID.CountY*.5) ) 
			
			addChildren()
			
		}
		
		private function addChildren():void{
			
			addChild( board = new Gridboard()  )
			addChild( editor  = new EditorUI())
			
			board.x = 120
			board.y = 40
				
		//	editor.addEventListener( "FIND_PATH" , FIND_PATH_EVENT )
				
			
		}
		public static function Random_Towers():void{
			for each ( var tile:Tile in Gridboard.AllTiles )if( uint((Math.random()*100)/10) == 0 ) tile.State = TileState.TOWER;
		}
		public function FIND_PATH_EVENT( event:Event ):void
		{
			
			
			
		}
	}
}








/*		
private function setPanelVisibility( mode : Boolean ):void{
var i:uint = 0 
for each( var p:Panel  in  PANELS ) 
{
p.visible = mode
p.y = 20 + i * 20
i++
}
i=0;
for each( var b:Button in BUTTONS )
{
b.y = i * 20
i++
}
}


private function onTileSetup( event:Event ):void
{
//	var parent:Sprite = Button(event.target).parent.parent as Sprite
var panel:Panel 

if( event.target.parent.name == "BTN1" ) 
{
panel = LAYER_menu.getChildByName("TILE_PANEL") as Panel

}else if( event.target.parent.name == "BTN2" ) 
{
panel = LAYER_menu.getChildByName("GRID_PANEL") as Panel
}else{ return }


var id:uint = PANELS.indexOf( panel )
var i:uint = 0
var p:uint = 0
for each(var b:Button in BUTTONS ) 
{
if( i-1 >= 0 ) {
if( Panel( PANELS[ i-1 ]).visible ) p += Panel( PANELS[ i-1 ]).height+20
}
if( b != event.target.parent ) Button(BUTTONS[ i ]).y = (i * 20)+p
i++
}

panel.y = Button(BUTTONS[ id ]).y+19			
panel.visible = !panel.visible;

if( panel.visible ) LAYER_menu.setChildIndex( panel, LAYER_menu.numChildren-1)

}
*/