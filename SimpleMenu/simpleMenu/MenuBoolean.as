package klock.simpleMenu
{
	import flash.display.*;
	import flash.events.*;

	/** Create a menu item with a bool toggle.*/
	public class MenuBoolean extends MenuChild
	{

		private var 		 state		 :Boolean = true;
		public  function get State()	 :Boolean  		  { return  state;  } 
		public  function set State( value:Boolean ):void  { state = value; Element_Draw(0);} 
		
		public function MenuBoolean( intObject:Object )
		{
			super( intObject )	
		}
		protected override function Element_Events( mode:Boolean ) : void
		{
			if( mode ){	
				tf.addEventListener( 	MouseEvent.CLICK, 	    MouseListener, false, 0, true );
			}else{
				tf.removeEventListener( MouseEvent.CLICK, 	   	MouseListener );
			}
		}
		protected override function MouseListener( event:Event ):void
		{
			if( event.type == "click"){
				state = ( state ) ? false: true
				
				Element_Draw( 0 )
				dispatchEvent( new Event("CHILD_CLICK", true ))
			}
		}
		
		public override function Element_Draw( mode:uint, outline:Boolean = true ):void
		{
			var g:Graphics = this.graphics
				g.clear()
				g.lineStyle(.5, MenuHelper.COLOR_NORMAL, 1 )
				g.beginFill( 	MenuHelper.COLOR_NORMAL, 1 )
				g.drawRect( 0,0, WIDTH, HEIGHT )
				g.endFill()
		
				g.lineStyle( 1, MenuHelper.COLOR_ACT, 1 )
				g.drawRect( WIDTH-HEIGHT+2, 2, HEIGHT-5, HEIGHT-5 )
			
			if( tf != null )tf.TXT_Color( MenuHelper.TXT_MENU_NORMAL )	
			if( state || mode == 1 ) MenuHelper.DRAW_CHECKER( g, HEIGHT, MenuHelper.TXT_MENU_NORMAL, 1, (WIDTH-HEIGHT))

		}
		
	}
}