package klock.simpleMenu
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextFieldType;

	import klock.text.TXT;
	
	/** Create a menu item with Numeric Stepper( int values ).*/
	public class MenuInt extends MenuChild
	{
		private var 		 tf2			 :TXT

		private var 		 key		 	:uint;
		public  function get Key()	 		:uint  		  	{ return  key;  } 
		public  function set Key( value		:uint ):void  	{ key = value;  }
		
		private var 		 value		 	:int;
		public  function get Value()	 	:int  		  	{ return  value;  } 
		public  function set Value( values	:int ):void  	{ value = values; }
		
		private var 		 PLUS			:Sprite
		private var 		 MINUS			:Sprite
		public var 		 	 MAXCOUNT		:int = 100
		public var 		 	 MINCOUNT		:int = 0
		
		public function MenuInt( intObject:Object )
		{
			super( intObject )
		}
		
		protected override function addChildren():void
		{			
			var g:Graphics
			
			var x1:uint = 50
			var x2:uint = x1+HEIGHT-2
			var w1:uint = (WIDTH-HEIGHT)-x2
	
			addChild( PLUS = new Sprite())
		 	g = PLUS.graphics 
			g.lineStyle( .5, MenuHelper.COLOR_ROLL)
			g.beginFill( 	 MenuHelper.COLOR_ROLL , 1 )
			g.drawRect( WIDTH-HEIGHT, 1, HEIGHT-2, HEIGHT-2 )
			
			addChild( MINUS = new Sprite())
			g = MINUS.graphics 
			g.lineStyle( .5, MenuHelper.COLOR_ROLL)
			g.beginFill( 	 MenuHelper.COLOR_ROLL , 1 )
			g.drawRect( x1, 1, HEIGHT-2, HEIGHT-2 )
				
			addChild(  tf = new TXT( label, {name :"LABEL", x:5,  y:0, width:x1-5, height: HEIGHT }, MenuHelper.TXT_FORMAT_10, "left"))	
			addChild( tf2 = new TXT( Value.toString(), {x:x2, y:1, width: w1, height: HEIGHT-2 }, MenuHelper.TXT_FORMAT_9, "none",{border:true,background:true,borderColor:MenuHelper.COLOR_ROLL }))
			
			tf2.TXT_Align( "CENTER" )
			tf2.selectable = true
			tf2.type = TextFieldType.INPUT
				
			MenuHelper.DRAW_TRIANGLE(  PLUS.graphics, 3, HEIGHT, MenuHelper.TXT_MENU_ACT, 1, WIDTH-HEIGHT )
			MenuHelper.DRAW_TRIANGLE( MINUS.graphics, 2, HEIGHT, MenuHelper.TXT_MENU_ACT, 1, x1-2 )
				
			PLUS.name = "PLUS"
			MINUS.name = "MINUS"
	
		}
		
		protected override function Element_Events( mode:Boolean ) : void
		{
			if( mode )
			{	
				MINUS.addEventListener( MouseEvent.CLICK , ITEM_PLUS, false, 0, true )
				PLUS.addEventListener ( MouseEvent.CLICK , ITEM_PLUS, false, 0, true )
			}else{
				MINUS.removeEventListener( MouseEvent.CLICK , ITEM_PLUS )
				PLUS.removeEventListener ( MouseEvent.CLICK , ITEM_PLUS )
			}
		}
		
		
		protected function ChangeText():void
		{
			tf2.text = Value.toString(); 
			tf2.TXT_Align( "CENTER" );
			
		}
		
		protected function ITEM_PLUS( event:Event ):void
		{
			if( event.target.name == "MINUS" ) {
				Value = ( --value > MINCOUNT )? value-- : 0
			}else{
				Value = ( ++value < MAXCOUNT )? value++ : 0
			}
			dispatchEvent( new Event("CHILD_CLICK", true ))
			ChangeText()
		}
		
	}
}