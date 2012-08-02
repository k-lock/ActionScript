package klock.simpleMenu
{
	import flash.display.Graphics;

	/** Class to hold ui layout parameters and functions.*/
	public class MenuHelper
	{
		public static const TXT_FORMAT_10:Object = { color:0x000000,  size:10, font:"MY Arial"}
		public static const TXT_FORMAT_9 :Object = { color:0x000000,  size: 9, font:"MY Arial"}

		public static var WIDTH 			:uint = 100
		public static var HEIGHT			:uint = 15
	
		public static const TXT_MENU_NORMAL	: uint = 0x333333
		public static const TXT_MENU_ACT	: uint = 0x000000
			
		public static const COLOR_NORMAL	:uint = 0xD6D4D5
		public static const COLOR_ROLL  	:uint = 0xADADAD
		public static const COLOR_ACT   	:uint = 0x828282
			
		public function MenuHelper() {  }
		
		public static function SETUP_PARAM  ( o1:Object, o2:Object ):void{ for(var n:String in o1) if (n in o1) o2[n] = o1[n]; }
		
		public static function DRAW_CHECKER( graphic:Graphics, size:uint = 20, color:uint = 0xFFFFFF, alpha:uint = 1, xOffset:uint = 0):void
		{			
			graphic.lineStyle( 2, color )
	
			graphic.moveTo( xOffset + size*.3,  size*.50 )
			graphic.lineTo( xOffset + size*.50, size*.65 )	
			graphic.lineTo( xOffset + size*.60, size*.3 )	

		}
		
		public static function DRAW_TRIANGLE( graphic:Graphics, dir:uint = 0, size:uint = 20, color:uint = 0xFFFFFF, alpha:uint = 1, xOffset:uint = 0):void
		{			
			graphic.beginFill( color, 1 )
			
			if( dir == 0 ) {
				//// up	
				graphic.moveTo( xOffset + size*.50, size*.25 )
				graphic.lineTo( xOffset + size*.75, size*.75 )	
				graphic.lineTo( xOffset + size*.25, size*.75 )	
				graphic.lineTo( xOffset + size*.50, size*.25 )
				
			}else if( dir == 1 ) {
				//// down 			
				graphic.moveTo( xOffset + size*.25, size*.25 )
				graphic.lineTo( xOffset + size*.75, size*.25 )	
				graphic.lineTo( xOffset + size*.50, size*.75 )	
				graphic.lineTo( xOffset + size*.25, size*.25 )
			}else if( dir == 2 ) {
				// left
				graphic.moveTo( xOffset + size*.25, size*.50 )
				graphic.lineTo( xOffset + size*.75, size*.25 )	
				graphic.lineTo( xOffset + size*.75, size*.75 )	
				graphic.lineTo( xOffset + size*.25, size*.50 )
			}else if( dir == 3 ) {
				// right
				graphic.moveTo( xOffset + size*.25, size*.25 )
				graphic.lineTo( xOffset + size*.75, size*.50 )	
				graphic.lineTo( xOffset + size*.25, size*.75 )	
				graphic.lineTo( xOffset + size*.25, size*.25 )
			}		
		}
		
		public static function AddItem( libary:Vector.<Vector.<MenuItem>>, item:Object, ...parameters ):Vector.<Vector.<MenuItem>>
		{

			var r:Vector.<MenuItem> = new Vector.<MenuItem>()
			if( parameters.length>0 )
			{
				r.push( item )
				
				var n:uint = parameters.length
				for(var i:uint= 0; i<n; i++)r.push( parameters[i] )

				libary.push( r )
				
			}else{
			
				r = new Vector.<MenuItem>()
				r.push( item )
						
				libary.push( r )
				
			}
				
			return libary;
		}
	
	}
}