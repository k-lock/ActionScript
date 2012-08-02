package klock.simpleMenu
{
	import flash.display.*;
	import flash.events.*;

	/** Create a base menu block element.*/
	public class MenuBlock extends MenuSprite
	{
		private var 			state		:Boolean = false;
		public function get 	State()		:Boolean			{ return this.state; }
		public function set 	State( value:Boolean )	:void   { state = value;	 }

		public function set 	Label( value:String )	:void 	{ label = value;} 
	
		public function MenuBlock( intObject:Object  )
		{
			super( intObject )
		}
		
		protected override function MouseListener( event:Event ):void
		{
			if( event.type == "mouseOut" && state == false)
			{
				Element_Draw( 0 )
			}else if( event.type == "mouseOver" && state == false)
			{
				Element_Draw( 1 )
				this.parent.setChildIndex( this, this.parent.numChildren-1 )
					
			}else if( event.type == "click")
			{
				Element_Draw( 2 )
				if( !state ){
					dispatchEvent( new Event("OPEN_MENU", true ))
				}else{
					dispatchEvent( new Event("CLOSE_MENU", true ))
				}
			}
			
		}
	}
}