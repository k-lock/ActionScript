/**Copyright (c) 2011 Paul Knab - Version 0.0.1*/

package klock.simpleComponents.components.base
{
	import flash.display.*;
	
	public class BaseLayout
	{
		public function BaseLayout() { }
		public static const TXT_FORMAT_10	:Object = { color:0x222222,  size:10, font:"MY Tahoma" }
	//	public static const TXT_FORMAT_8 	:Object = { color:0x8C8C8C,  size: 8, font:"MY Arial" }
			
		
		public static const USE_OUTLINE		: Boolean = true
		public static const OUTLINE_SIZE	: Number  = 2
	
		// STYLE COLORS 
			
			public static const DROPSHADOW 		:uint = 0x000000
			public static const PANELGRID 		:uint = 0xDBDBDB
			public static const NORMAL_LIST		:uint = 0xffffff;
			public static const SELECTED_LIST	:uint = 0xdddddd;
			public static const ROLL_LIST		:uint = 0xeeeeee;	
			public static const SLIDER_BACK		:uint = 0x999999;
			public static const SLIDER_BTN		:uint = 0x666666;
			
		// NORMAL	
			
			public static const NORMAL_FILL 	: uint = 0xDBDBDB
			public static const NORMAL_LINE 	: uint = 0x999999
			public static const NORMAL_TXT  	: uint = 0x555555
		
		// OVER
			
			public static const OVER_FILL 		: uint = 0xEEEEEE
			public static const OVER_LINE 		: uint = 0xBBBBBB
			public static const OVER_TXT  		: uint = 0x555555
	
		// SELECTED
			
			public static const SELECT_FILL 	: uint = 0xFFFFFF
			public static const SELECT_LINE 	: uint = 0xCCCCCC
			public static const SELECT_TXT  	: uint = 0x333333

		
		/**
		 * Return the outline width. If(!outline)return 0  
		 * @return Number */
		public static function get LEFT():Number 
		{ 
			return (USE_OUTLINE) ? OUTLINE_SIZE : 0 
		} 
		
		public static function LINECOLOR_CODE( mode:uint ):uint
		{
			switch( mode )
			{
			case 0 : return BaseLayout.NORMAL_LINE 
				break
			case 1 : return BaseLayout.OVER_LINE
				break
			case 2 : return BaseLayout.SELECT_LINE
				break
			case 3 : return BaseLayout.NORMAL_LINE 
				break
			case 4 : return SLIDER_BTN
				break
			case 5 : return SLIDER_BACK
				break
			}	
			return 0		
		}
	
		public static function FILLCOLOR_CODE( mode:uint ):uint
		{			
			switch( mode )
			{
				case 0 : return BaseLayout.NORMAL_FILL 
					break
				case 1 : return BaseLayout.OVER_FILL
					break
				case 2 : return BaseLayout.SELECT_FILL
					break
				case 3 : return BaseLayout.NORMAL_FILL 
					break
				case 4 : return SLIDER_BTN
					break
				case 5 : return SLIDER_BACK
					break
			}	
			return 0		
		}
		
		/**
		 * Draws a filled and outlined - or only a filled circle.
		 * @param g The Graphics object to draw.
		 * @param w The width for the draw rect.
		 * @param h The height for the draw rect.
		 * @param mode The mode to draw. [ 0 - fillin and outline, 1 - only fillin ] */
		public static function DRAW_ROUNDFIELD( g:Graphics, r:Number, mode:uint = 0, clear:Boolean = true )	:void
		{
			if( clear )g.clear()
			if( mode == 0){ // Draws a filled and outlined Circle"
				var r1:Number = r*.25
				var color1:uint = BaseLayout.NORMAL_LINE 
				g.beginFill( color1, 1 )
				g.drawCircle( r*.5,r*.5, r1 )
					
				var r2:Number = ( r-LEFT*2 )*.25
				var color2:uint = BaseLayout.NORMAL_FILL 
				g.beginFill( color2, 1 )
				g.drawCircle(  r*.5,r*.5, r2 )
					
			}else{ // Draws only a filled Circle.
				var r3:uint = ( r-LEFT*2 )*.2
				var color:uint = BaseLayout.NORMAL_LINE 
				g.beginFill( color, 1 )
				g.drawCircle( r3, r3, r3 )
				
			}
		}
		
		/**
		 * Draws a filled and outlined rectangle. width the option to change the outline or fillin color.
		 * @param g The Graphics object to draw. 
		 * @param w The width for the draw rect.
		 * @param h The height for the draw rect.
		 * @param color1 [ Extra ] To set the outlines in a different color. 
		 * @param color2 [ Extra ] To set the fillins in a different color. 
		 * @param clear  [ Extra ] To clear the base graphics object before beginn drawing. */
		public static function DRAW_FIELD( g:Graphics, w:Number, h:Number, color1:int = -1, color2:int = -1, clear:Boolean = true )	:void
		{
			if( clear )g.clear()
			g.beginFill( LINECOLOR_CODE( ( color1 != -1 ) ? color1 : 0) , 1 )
			DRAW_RECT( g, w, h, 0, 0 )
			
			g.beginFill( FILLCOLOR_CODE( ( color2 != -1 ) ? color2 : 0) , 1 )
			DRAW_RECT( g, w-LEFT*2, h-LEFT*2, LEFT, LEFT )
		}
		
		/**
		 * Draw a filled rectangle used in a element as outline. 
		 * @param g The Graphics object to draw.
		 * @param w The width for the draw rect.
		 * @param h The height for the draw rect.
		 * @param mode The mode to draw. 
		 * @param color [ Extra ] To fill in a different color. 
		 * @param clear [ Extra ] To clear the base graphics object before beginn drawing. */	
		public static function DRAW_OUTLINE( g:Graphics, w:Number, h:Number, mode:uint = 0, color:int = -1, clear:Boolean = true )	:void
		{
			if( clear )g.clear()
			g.beginFill(  ( color != -1 )? color : LINECOLOR_CODE( mode ), ( mode == 3 ) ? .8 : 1 )
	
			DRAW_RECT( g, w, h, 0,0 )
		}
		
		/**
		 * Draw a filled rectangle used in a element as fillIn.  
		 * @param g The Graphics object to draw.
		 * @param w The width for the draw rect.
		 * @param h The height for the draw rect.
		 * @param mode The mode to draw.
		 * @param color [ Extra ] To fill in a different color. 
		 * @param clear [ Extra ] To clear the base graphics object before beginn drawing. */		
		public static function DRAW_FILLIN( g:Graphics, w:Number, h:Number, mode:uint = 0, color:int = -1, clear:Boolean = true )	:void
		{
			if( clear )g.clear()
			g.beginFill(  ( color != -1 )? color : FILLCOLOR_CODE( mode ), ( mode == 3 ) ? .8 : 1 )
				
			DRAW_RECT( g, w-LEFT*2, h-LEFT*2, 0, 0 )
		}		
		
		/**
		 * The Main Rectangle Draw function. Used in all graphics elements to draw. 
		 * @param g The Graphics object to draw.
		 * @param w The width for the draw rect.
		 * @param h The height for the draw rect.
		 * @param x The position of X.
		 * @param y The position of Y. */
		public static function DRAW_RECT( g:Graphics, w:Number, h:Number, x:Number = 0, y:Number = 0 )	:void
		{
			g.drawRect( x, y, w, h )
		}
	
		/** 
		 * Draw a filled triangle.
		 * @param g The Graphics object to draw.
		 * @param dir The direction for the tri [ 0 - up, 1 - down, 2 - left, 3 - right].
		 * @param size The width and height.
		 * @param color The color to draw.
		 * @param alpha The alpha for the color.
		 * @param xOffset The move amount of X.
		 * @param yOffset The move amount of Y.
		 * @param clear [ Extra ] To clear the base graphics object before beginn drawing. */		
		public static function DRAW_TRIANGLE( graphic:Graphics, dir:uint = 0, size:uint = 20, color:uint = 0xFFFFFF, alpha:uint = 1, xOffset:int = 0, yOffset:int = 0, clear:Boolean = true):void{
			if( clear )graphic.clear()
			graphic.beginFill( color, 1 )
			
			if( dir == 0 ) { 		//// up	
				
				graphic.moveTo( xOffset + size*.50, yOffset + size*.25 )
				graphic.lineTo( xOffset + size*.75, yOffset + size*.75 )	
				graphic.lineTo( xOffset + size*.25, yOffset + size*.75 )	
				graphic.lineTo( xOffset + size*.50, yOffset + size*.25 )
				
			}else if( dir == 1 ) { 	//// down 		
				
				graphic.moveTo( xOffset + size*.25, yOffset + size*.25 )
				graphic.lineTo( xOffset + size*.75, yOffset + size*.25 )	
				graphic.lineTo( xOffset + size*.50, yOffset + size*.75 )	
				graphic.lineTo( xOffset + size*.25, yOffset + size*.25 )
			}if( dir == 2 ) { 		/// left
				graphic.moveTo( xOffset + size*.25, yOffset + size*.50 )
				graphic.lineTo( xOffset + size*.75, yOffset + size*.25 )	
				graphic.lineTo( xOffset + size*.75, yOffset + size*.75 )	
				graphic.lineTo( xOffset + size*.25, yOffset + size*.50 )
			}if( dir == 3 ) { 		//// right
				graphic.moveTo( xOffset + size*.25, yOffset + size*.25 )
				graphic.lineTo( xOffset + size*.75, yOffset + size*.50 )	
				graphic.lineTo( xOffset + size*.25, yOffset + size*.75 )	
				graphic.lineTo( xOffset + size*.25, yOffset + size*.25 )
			}
		}
		
	} // --> class end
}