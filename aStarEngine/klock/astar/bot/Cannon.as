package klock.astar.bot
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;

	public class Cannon extends BitmapAtlas
	{
		
		
		public function Cannon( _x:Number, _y:Number, type:uint = 0 )
		{
	
			this.name = "NORMAL"
			this.x = _x
			this.y = _y
			this.AWAKE		( 	Asset.getTexture( "cannons").bitmapData )			
			this.SIZER.push ( 	new Rectangle(  10,10,54,56 ),
								new Rectangle(  65,10,54,56 ),
								new Rectangle( 120,10,54,56 ),
								new Rectangle( 175,10,54,55 ),
								new Rectangle( 230,10,54,56 ),
								new Rectangle( 285,10,54,55 ),
								new Rectangle( 340,10,54,56 ),
								new Rectangle( 395,10,54,55 ));			
			this.scaleX = -1
		}
		
		
		
		
		
		public function ResetRoute():void{
			
		}
	}
}

/* 

cannon A - 

new Rectangle(  10,10,54,56 ),
new Rectangle(  65,10,54,56 ),
new Rectangle( 120,10,54,56 ),
new Rectangle( 175,10,54,55 ),
new Rectangle( 230,10,54,56 ),
new Rectangle( 285,10,54,55 ),
new Rectangle( 340,10,54,56 ),
new Rectangle( 395,10,54,55 ));

cannon B -

new Rectangle(  10,90,50,65 ),
new Rectangle(  65,90,51,67 ),
new Rectangle( 120,90,51,67 ),
new Rectangle( 175,90,52,63 ),
new Rectangle( 230,90,50,66 ),
new Rectangle( 285,90,52,67 ),
new Rectangle( 340,90,51,66 ),
new Rectangle( 395,90,52,67 ));

cannon C - 

new Rectangle(  10,190,53,79 ),
new Rectangle(  65,190,46,79 ),
new Rectangle( 120,190,43,78 ),
new Rectangle( 175,190,48,80 ),
new Rectangle( 230,190,53,83 ),
new Rectangle( 285,190,50,86 ),
new Rectangle( 340,190,43,85 ),
new Rectangle( 395,190,46,81 ));

*/