package klock.simpleMenu
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import klock.text.TXT;
	
	/** Base element.*/
	public class MenuSprite extends Sprite
	{
		protected var WIDTH 	:uint = 100
		protected var HEIGHT	:uint = 15
			
		public var 	label 		:String
		public var 	tf			:TXT

		public function MenuSprite( intObject:Object )
		{
			if( intObject != null ) setupObjects( intObject, this )
				
			addChildren()
			
			Element_Draw( 0 )
			Element_Events( true )
		}
		
		protected function addChildren():void{
			
			addChild(  tf = new TXT( label , {x:0,  y:0, width:WIDTH, height: HEIGHT }, MenuHelper.TXT_FORMAT_10, "none"))	
			tf.TXT_Align( "CENTER" )
			
		}
		
		protected function Element_Events( mode:Boolean ) : void
		{
			if( mode ){	
				tf.addEventListener( 	MouseEvent.CLICK, 	    MouseListener, false, 0, true );
				tf.addEventListener( 	MouseEvent.MOUSE_OUT,  	MouseListener, false, 0, true );
				tf.addEventListener( 	MouseEvent.MOUSE_OVER, 	MouseListener, false, 0, true );
			}else{
				tf.removeEventListener( MouseEvent.CLICK, 	   	MouseListener );
				tf.removeEventListener( MouseEvent.MOUSE_OUT,  	MouseListener );
				tf.removeEventListener( MouseEvent.MOUSE_OVER, 	MouseListener );
			}
		}
		
		protected function MouseListener( event:Event ):void
		{
			if( event.type == "mouseOut")
			{
				Element_Draw( 0 )
			}else if( event.type == "mouseOver")
			{
				Element_Draw( 1 )
			}else if( event.type == "click")
			{
				Element_Draw( 2 )
				
				dispatchEvent( new Event("MENUSPRITE_CLICK", true ))
			}
			
		}
		
		public function Element_Draw( mode:uint, outline:Boolean = true ):void
		{
			var g:Graphics = this.graphics
				g.clear()
			
			if( mode  > 0 ) tf.TXT_Color( MenuHelper.TXT_MENU_ACT )
			if( mode == 0 )
			{
				g.beginFill(	MenuHelper.COLOR_NORMAL, 1 )
				g.drawRect( 0,0, WIDTH, HEIGHT )	
					
				tf.TXT_Color( 	MenuHelper.TXT_MENU_NORMAL )
				
			}else if( mode == 1 ){
				
				g.beginFill( 	MenuHelper.COLOR_ROLL, 	1 )
				g.drawRect( 0,0, WIDTH, HEIGHT )	
				
			} else if( mode == 2 ){
				
				g.beginFill( 	MenuHelper.COLOR_ACT, 	1 )
				g.drawRect( 0,0, WIDTH, HEIGHT )	
				
			}	
			
			
	
		}
		protected static function setupObjects( o1:Object, o2:Object ):void{ for(var n:String in o1) if (n in o1) o2[n] = o1[n]; }
		
	}
}