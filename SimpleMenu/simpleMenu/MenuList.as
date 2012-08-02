package klock.simpleMenu
{
	import flash.display.*;
	import flash.events.*;

	/** Class to create the current selected menu block.*/
	public class MenuList extends Sprite
	{
		public  var LIBARY	:Vector.<Vector.<MenuItem>> = new Vector.<Vector.<MenuItem>>

		private var WIDTH 	:uint = MenuHelper.WIDTH
		private var HEIGHT	:uint = MenuHelper.HEIGHT
			
		private var PARENTS	:Sprite
		private var CHILDS	:Sprite
		public function Child( index:uint ):MenuChild
		{
			return CHILDS.getChildAt( index ) as MenuChild
		}

		public function MenuList( intObject:Object )
		{
			if( intObject != null ) MenuHelper.SETUP_PARAM( intObject, this )
			
			this.y = HEIGHT
			this.addChild( PARENTS = new Sprite())
			this.addChild( CHILDS  = new Sprite())

			DRAW()

			PARENTS.name = "PARENTS"
			CHILDS.name = "CHILDS"
		}
		
		private function DRAW():void
		{
			var rowIndex:uint = 0
			var _parent:MenuParent;
			
			for each( var row:Vector.<MenuItem> in LIBARY )
			{
				if( row[0].TYPE == MenuItem.PARENT )
				{
					PARENTS.addChild(_parent = new MenuParent( {x:0,  y:(rowIndex*HEIGHT), label: row[0].LABEL, TYPE: row[0].LABEL, DRAW_TRI: ( row.length > 1 )? true : false } ))
					_parent.addEventListener( "OPEN_CHILDS",   OPEN_CHILD_LAYER, false, 0, true )
					_parent.addEventListener( "CLOSE_CHILDS", CLOSE_CHILD_LAYER, false, 0, true )
				
				}else{
					
					PARENTS.addChild( new MenuChild( {x:0,  y:(rowIndex*HEIGHT), label: row[0].LABEL, TYPE: row[0].LABEL } ))
						
				}
				
				rowIndex++
			}		
		}
		
		private function CLOSE_CHILD_LAYER( event:Event ):void
		{	
			CLEAR_CHILDS()
		}
		
		private function OPEN_CHILD_LAYER( event:Event ):void
		{
			CLEAR_CHILDS()

			var rowIndex:uint = PARENTS.getChildIndex( MenuParent(event.target))
			var _y	 	:uint = (rowIndex*HEIGHT)
			var n		:uint = LIBARY[rowIndex].length
				
			for (var i:uint = 1; i<n; i++ ){
				
				if( LIBARY[rowIndex][i].TYPE == MenuItem.ITEM_BOOL ){
					
					CHILDS.addChild( new MenuBoolean( 
					{
						x:		WIDTH,  
						y:		_y+(i*HEIGHT)-HEIGHT, 
						label: 	LIBARY[rowIndex][i].LABEL, 
						TYPE: 	LIBARY[rowIndex][i].TYPE, 
						State:	( LIBARY[rowIndex][i].VALUE == 0 )? true : false  
					} ))
						
				}else if( LIBARY[rowIndex][i].TYPE == MenuItem.ITEM_UINT ){
				
					CHILDS.addChild( new MenuInt( 
					{
						x:WIDTH,  
						y:_y+(i*HEIGHT)-HEIGHT,
						label: LIBARY[rowIndex][i].LABEL, 
						TYPE: LIBARY[rowIndex][i].TYPE, 
						Value:LIBARY[rowIndex][i].VALUE
					} ))
				
				}else if( LIBARY[rowIndex][i].TYPE == MenuItem.ITEM_CBOX ){
			
					CHILDS.addChild( new MenuComBo(
					{
						x:				WIDTH,  
						y:				_y+(i*HEIGHT)-HEIGHT, 
						label: 			LIBARY[rowIndex][i].LABEL, 
						TYPE: 			LIBARY[rowIndex][i].TYPE, 
						LABELS:			LIBARY[rowIndex][i].VALUE_OBJECT,
						SelectedIndex:	LIBARY[rowIndex][i].VALUE
					} ))	
						
				}else{	

					CHILDS.addChild( new MenuChild( 
					{
						x:		WIDTH, 
						y:		_y+(i*HEIGHT)-HEIGHT, 
						label: 	LIBARY[rowIndex][i].LABEL, 
						TYPE: 	LIBARY[rowIndex][i].TYPE 
					} ))
				}
			}
		}
		
		private function CLEAR_CHILDS():void
		{
			var n:uint = CHILDS.numChildren
			for(var i:uint=0; i<n; i++ ) CHILDS.removeChildAt( 0 )
		}
						
	}
}