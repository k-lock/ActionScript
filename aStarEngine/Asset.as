package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	public class Asset
	{
		
		[Embed(source = "/assets/sprites/Cannon_A_Atlas.png")]
		private static const cannons	:Class
		
		[Embed(source = "/assets/sprites/Enemy_A_Atlas.png")]
		private static const enemys		:Class
		
		private static var sTextures	:Dictionary = new Dictionary()
		
		public function Asset()
		{
		}
		
		public static function getTexture( name:String ):Bitmap
		{
			if ( sTextures[name] == undefined )
			{
				var data:Object = new Asset[name]();
				
				if (data is Bitmap) sTextures[name] =  data as Bitmap;

			}
			
			return sTextures[name];
		}
		
	}
}