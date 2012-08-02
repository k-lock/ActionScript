package klock.simpleMenu
{
	import flash.display.*;
	import flash.events.*;

	import klock.text.TXT;
	
    /** Create a base menu child element.*/ 
	public class MenuChild extends MenuSprite
	{
		public var TYPE:String
		
		public function MenuChild( intObject:Object )
		{
			this.name = "MChild"
			super( intObject )
			
		}
		
		protected override function addChildren():void
		{			
			addChild(  tf = new TXT( label , {name :"LABEL", x:5,  y:0, width:WIDTH, height: HEIGHT }, MenuHelper.TXT_FORMAT_10, "none"))	
			tf.TXT_Align( "LEFT" )
	
		}	
		
		protected override function MouseListener( event:Event ):void
		{
			if( event.type == "mouseOut"){
				Element_Draw( 0 )
			}else if( event.type == "mouseOver"){
				Element_Draw( 1 )
			}else if( event.type == "click"){
				Element_Draw( 2 )
			
				dispatchEvent( new Event("CHILD_CLICK", true ))
			}
		}
		
		public override function Element_Draw( mode:uint, outline:Boolean = true ):void
		{
			var g:Graphics = this.graphics
				g.clear()
				
				if( mode == 0 )
				{
					g.beginFill( 	MenuHelper.COLOR_NORMAL, 1 )
					tf.TXT_Color( 	MenuHelper.TXT_MENU_NORMAL )
						
				}else if( mode >= 1 ){

					g.beginFill( 	MenuHelper.COLOR_ROLL, 1 )
					tf.TXT_Color( 	MenuHelper.TXT_MENU_ACT )

					
				} else if( mode == 2 ){
				
				g.lineStyle(.5, MenuHelper.COLOR_ACT, 1 )
				g.beginFill( 	MenuHelper.COLOR_ACT, 1 )
				
				}	
			
			g.drawRect( 0,0, WIDTH, HEIGHT )
			g.endFill()

		}
	}
}