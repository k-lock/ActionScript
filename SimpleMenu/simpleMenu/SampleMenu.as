package klock.simpleMenu
{
	import flash.display.*;
	import flash.events.*;
	
	import klock.simpleMenu.*;

	/**
	 * Sample menu.
	 * 
	 * Show the using of kSimpleMenu package.
	 * 
	 */
	public class SampleMenu extends Sprite
	{
		public  var ComboIndex	:uint 	 = 0
		public  var CountX		:uint 	 = 12
		public  var CountY		:uint 	 = 8
		public  var Size		:uint 	 = 8
		public  var Type_A		:Boolean = true;
		public  var Type_B		:Boolean = false;


		private var MENU		:Sprite
		private var MenuBlocks	:Vector.<MenuBlock>	
		private var BLOCK_1		:MenuBlock
		private var BLOCK_2		:MenuBlock
		private var BLOCK_3		:MenuBlock	
		
		public function SampleMenu( intObject:Object=null )
		{
			if( intObject != null ) MenuHelper.SETUP_PARAM( intObject, this )

			addChild( BLOCK_1 = new MenuBlock( { x:0, 				   name: "MENU I" ,  Label: "Datei"} ))
			addChild( BLOCK_2 = new MenuBlock( { x:MenuHelper.WIDTH,   name: "MENU II",  Label: "Route"} ))
			addChild( BLOCK_3 = new MenuBlock( { x:MenuHelper.WIDTH*2, name: "MENU III", Label: "Tiles"} ))	
			addChild( MENU = new Sprite())
			
			MenuBlocks = new Vector.<MenuBlock>()
			MenuBlocks.push( BLOCK_1, BLOCK_2, BLOCK_3)
			
			BLOCK_EVENTS( true )
			
			addEventListener( MouseEvent.ROLL_OUT, CLOSE_MENU, false, 0, true )

		}

		private function BLOCK_EVENTS( mode:Boolean ):void{
			
			for each( var block:MenuBlock in MenuBlocks )
			{
				if( mode ){
					block.addEventListener( "OPEN_MENU", 	OPEN_MENU,  false, 0, true )
					block.addEventListener( "CLOSE_MENU",  	CLOSE_MENU, false, 0, true )
				}else{
					block.removeEventListener( "OPEN_MENU", 	OPEN_MENU  )
					block.removeEventListener( "CLOSE_MENU", CLOSE_MENU )
				}
			}
		}
	
		private function OPEN_MENU( event:Event ):void{

			CLEAR_MENU()
			
			var SEPERART:String ="----------------------------"
			var menu	:MenuList
			var LIBARY	:Vector.<Vector.<MenuItem>> = new Vector.<Vector.<MenuItem>>
			var row		:Vector.<MenuItem> = new Vector.<MenuItem>()
			
			if( event.target.name == "MENU I")  {
				
				BLOCK_1.State = true
				LIBARY = MenuHelper.AddItem( LIBARY, new MenuItem( "New", 		MenuItem.CHILD ))
				LIBARY = MenuHelper.AddItem( LIBARY, new MenuItem( "Save", 		MenuItem.CHILD ))
				LIBARY = MenuHelper.AddItem( LIBARY, new MenuItem( "Export", 	MenuItem.CHILD ))
				LIBARY = MenuHelper.AddItem( LIBARY, new MenuItem( SEPERART,	MenuItem.CHILD ))
				LIBARY = MenuHelper.AddItem( LIBARY, new MenuItem( "Exit", 		MenuItem.CHILD ))	
			
			}else if( event.target.name == "MENU II") { 
				
				BLOCK_2.State = true
				LIBARY = MenuHelper.AddItem( LIBARY, new MenuItem( "Recalc Path",MenuItem.CHILD ))
				LIBARY = MenuHelper.AddItem( LIBARY, new MenuItem( "Show Path",	MenuItem.CHILD ))
				LIBARY = MenuHelper.AddItem( LIBARY, new MenuItem( SEPERART, 	MenuItem.CHILD ))
				LIBARY = MenuHelper.AddItem( LIBARY, new MenuItem( "Start End", MenuItem.PARENT ), 
													 new MenuItem( "Start", 	MenuItem.ITEM_UINT, CountX ), 
													 new MenuItem( "End", 		MenuItem.ITEM_UINT, CountY ) )
		
			}else if( event.target.name == "MENU III"){

				BLOCK_3.State = true
				LIBARY = MenuHelper.AddItem( LIBARY, new MenuItem( "Tile Type",	MenuItem.PARENT ),
													 new MenuItem( "Quad", 		MenuItem.ITEM_BOOL, (Type_A)? 1 : 0 ),
													 new MenuItem( "Hexagon", 	MenuItem.ITEM_BOOL,  (Type_A)? 0 : 1 ))
				LIBARY = MenuHelper.AddItem( LIBARY, new MenuItem( "Size", 		MenuItem.PARENT ), new MenuItem( "Tile Size", MenuItem.ITEM_UINT, Size ))
				LIBARY = MenuHelper.AddItem( LIBARY, new MenuItem( "Grid Count", MenuItem.PARENT ),  new MenuItem( "CountX", MenuItem.ITEM_UINT, CountX), new MenuItem( "CountY", MenuItem.ITEM_UINT, CountY) )
				LIBARY = MenuHelper.AddItem( LIBARY, new MenuItem( "Type Combo", MenuItem.PARENT ),  new MenuItem( "Combo", MenuItem.ITEM_CBOX, ComboIndex,  "quad", "hexagon" ) )
						
			}
			
			BLOCK_1.Element_Draw( ( BLOCK_1.State ) ? 2 : 0 )
			BLOCK_2.Element_Draw( ( BLOCK_2.State ) ? 2 : 0 )
			BLOCK_3.Element_Draw( ( BLOCK_3.State ) ? 2 : 0 )
			
			MENU.addChild( menu = new MenuList({ x: event.target.x, visible:true, LIBARY:LIBARY }))			
			MENU.addEventListener( "CHILD_CLICK", ITEM_CLICK, false, 0 , true )

		}

		private function ITEM_CLICK( event:Event ):void{
	
			//trace( "CLICK ON : ", MenuChild(event.target).label)
			var close:Boolean = true;
			var ml:MenuList =  MENU.getChildAt(0) as MenuList
			
			switch( MenuChild(event.target).label )
			{
				///--------------------- MENU BLOCK I
				case "New":
					MENU_ACTION("- New")
				break;
				case "Save":
					MENU_ACTION("- Save")
				break;
				case "Export":
					MENU_ACTION("- Export")
				break;
				case "Exit":
					MENU_ACTION("- Exit")
				break;
				///--------------------- MENU BLOCK II
				case "Recalc Path":
					MENU_ACTION("- Recalc Path")
					close = false;
				break;
				case "Show Path":
					MENU_ACTION("- Show Path")
				break;
				case "Start":
					CountX = MenuInt(event.target).Value
					close = false;
				break;
				case "End":
					CountY = MenuInt(event.target).Value
					close = false;
				break;
				///--------------------- MENU BLOCK III
				case "Quad":
					
					Type_A = MenuBoolean( ml.Child(0)).State = true
					Type_B = MenuBoolean( ml.Child(1)).State = false;
					close  = false;

				break;
				case "Hexagon":
					
					close  = false;
					Type_A = MenuBoolean( ml.Child(0)).State = false
					Type_B = MenuBoolean( ml.Child(1)).State = true;
					
				break;
				case "Tile Size":
					Size = MenuInt( ml.Child( 0 )).Value
					close  = false;
				break;
				case "CountX":
					CountX = MenuInt( ml.Child( 0 )).Value
					close  = false;
					break;
				case "CountY":
					CountY = MenuInt( ml.Child( 0 )).Value
					close  = false;
					break;
				case "Combo":
					ComboIndex = MenuComBo(event.target).SelectedIndex
					break;
			}
			
			if( close )CLEAR_MENU()
		}
	
		private function CLOSE_MENU( event:Event ):void
		{
			CLEAR_MENU()
		}
		
		private function CLEAR_MENU():void
		{			
			if( MENU.numChildren > 0 ){
				MENU.removeChildAt( 0 )
			}
			BLOCK_1.State = false
			BLOCK_2.State = false
			BLOCK_3.State = false
			
			BLOCK_1.Element_Draw( 0 )
			BLOCK_2.Element_Draw( 0 )
			BLOCK_3.Element_Draw( 0 )
				
			MENU.removeEventListener( "CHILD_CLICK", ITEM_CLICK )
		} 
		
		private function MENU_ACTION( m:String):void
		{
			trace( "MENU_ACTION " + m)
		}
	}
}