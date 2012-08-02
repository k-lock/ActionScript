package klock.simpleMenu
{
	import flash.display.*;
	import flash.events.*;

	import klock.text.TXT;

	/** Create a menu item with a combobox.*/
	public class MenuComBo extends MenuChild
	{
		public var ACT:Boolean = false
		
		public var LABELS:Vector.<String> 
		public function get SelectedItem():String{ return LABELS[selectedIndex];}
		
		private var selectedIndex:uint = 0
		public function get SelectedIndex()			   :uint{ return selectedIndex;}
		public function set SelectedIndex( value:uint ):void{ selectedIndex = value;}

		protected var 	LIST		:Sprite
		protected var 	HEAD		:TXT
		private var 	layerTemp	:int = -1
		
		public function MenuComBo(intObject:Object)
		{
			super(intObject);
		}
		protected override function addChildren():void
		{
			
			this.name = "CBOX"
			addChild( LIST = new Sprite())
			LIST.y = HEIGHT

			var i:uint = 0
			for each( var s:String in LABELS )
			{				
				var tf:TXT;				
				LIST.addChild(  tf = new TXT( String(s) , 		{x:1,  y:(i*HEIGHT), width:WIDTH, height: HEIGHT}, MenuHelper.TXT_FORMAT_9, "none"))	
				tf.TXT_Align( "CENTER" )
				i++
			}

			addChild( HEAD = new TXT( LABELS[ selectedIndex ] , {x:1,  y:1, width:WIDTH-HEIGHT, height: HEIGHT}, MenuHelper.TXT_FORMAT_9, "none"))
			HEAD.TXT_Align( "CENTER" )		
		}
		
		protected override function Element_Events( mode:Boolean ) : void
		{
			if( mode )
			{					
				addEventListener( MouseEvent.CLICK , LIST_EVENT, false, 0, true )

			}else{

				removeEventListener( MouseEvent.CLICK , LIST_EVENT )
			}	
		}
		
		private function LIST_EVENT( event:Event ):void
		{			
			ACT = ( ACT ) ? false : true
			Element_Draw( 0 )
		
			if( layerTemp == -1 ) layerTemp = this.parent.getChildIndex( this )
			this.parent.setChildIndex( this, ( ACT ) ? this.parent.numChildren-1 : layerTemp )
				
		}
		
		public override function Element_Draw( mode:uint, outline:Boolean = true ):void
		{
			
			LIST_EVENTS( ACT ) 
			LIST.visible = ACT
		
			var g:Graphics = this.graphics
				g.clear()
				g.lineStyle( 1,0,0 )
				
				g.beginFill( MenuHelper.COLOR_NORMAL, 1 )
				g.drawRect(0,0, WIDTH+2, HEIGHT)
					
			if(  ACT )
			{	
				g.beginFill( 0xeaeaea, 1 )
				g.drawRect(1,1, WIDTH, HEIGHT-2)
				
				g.beginFill( 	MenuHelper.COLOR_NORMAL, 1 )
				g.drawRect(0,HEIGHT-1, WIDTH+2,  (HEIGHT)*(LABELS.length)+2)
					
				g.beginFill( 0xeaeaea, 1 )
				g.drawRect(1,HEIGHT, WIDTH, (HEIGHT)*(LABELS.length))
	
				g.beginFill( 0xB5B5B5, 1 )
				g.drawRect( 1+WIDTH-HEIGHT, 1, HEIGHT, HEIGHT-2)
				g.endFill()
						
			}else{

				g.beginFill( 0xeaeaea, 1 )
				g.drawRect(1,1, WIDTH, HEIGHT-2)
	
				g.beginFill( 0xB5B5B5, 1 )
				g.drawRect( 1+WIDTH-HEIGHT, 1, HEIGHT, HEIGHT-2)
				g.endFill()

			}
			MenuHelper.DRAW_TRIANGLE( g, (ACT)?0:1, HEIGHT-2, 0x000000, 1, WIDTH-HEIGHT+2)
		}
		
		private function LIST_EVENTS( mode:Boolean ) : void
		{			
			var n:uint = LABELS.length
			for( var i:uint = 0; i<n; i++ ){
				
				var tf:TXT = LIST.getChildAt( i )as TXT
				
				if( mode ){
					
					tf.addEventListener( 	MouseEvent.CLICK, 	    ListMouseDown, false, 0, true );
					tf.addEventListener( 	MouseEvent.MOUSE_OUT,  	ListMouseLeave, false, 0, true );
					tf.addEventListener( 	MouseEvent.MOUSE_OVER, 	ListMouseEnter, false, 0, true );
				}else{
					tf.removeEventListener( MouseEvent.CLICK, 	   	ListMouseDown );
					tf.removeEventListener( MouseEvent.MOUSE_OUT,  	ListMouseLeave );
					tf.removeEventListener( MouseEvent.MOUSE_OVER, 	ListMouseEnter );
				}
				
				tf.background  = false	
				tf.backgroundColor = 0xFFFFFF
			}
		}
		
		private function ListMouseDown( event:Event ):void
		{
			var tf	:TXT = event.target as TXT
		//	var s	:String = tf.text.toLowerCase()
			var id	:uint = LIST.getChildIndex( tf )
	
			selectedIndex = id
			HEAD.text = LABELS[ tf.parent.getChildIndex(tf) ]
			HEAD.TXT_Align( "CENTER" )
			
			//dispatchEvent( new Event( "CHANGE_TYPE_EVENT", true))
			dispatchEvent( new Event( "CHILD_CLICK", true))

		}
		
		private function ListMouseEnter( event:Event ):void
		{	
			var tf:TXT = event.target as TXT
				tf.background  = true	
				tf.backgroundColor = MenuHelper.COLOR_ROLL
		}
		
		private function ListMouseLeave( event:Event ):void
		{ 
			TXT(event.target).background  = false 
		}	
		
	}
}