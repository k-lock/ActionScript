package
{
    import flash.display.Bitmap;
    import flash.display3D.textures.Texture;
    import flash.media.Sound;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;

    public class Assets
    {
        // Bitmaps
		[Embed(source = "media/textures/PLAYER.png")]
		private static const Player2:Class;
		
		[Embed(source = "media/textures/PLAYER.png")]
		private static const Player:Class;
		
		[Embed(source = "media/textures/BALL.png")]
		private static const Puck:Class;
        
        [Embed(source = "media/textures/FIELD.png")]
        private static const Field:Class;
        
        [Embed(source = "media/textures/egg_closed.png")]
        private static const EggClosed:Class;
        
        [Embed(source = "media/textures/egg_opened.png")]
        private static const EggOpened:Class;
        
        [Embed(source = "media/textures/Logo_AH.png")]
        private static const Logo:Class;
        
        [Embed(source = "media/textures/button_back.png")]
        private static const ButtonBack:Class;
        
        [Embed(source = "media/textures/button_big.png")]
        private static const ButtonBig:Class;
        
        [Embed(source = "media/textures/button_normal.png")]
        private static const ButtonNormal:Class;
        
        [Embed(source = "media/textures/button_square.png")]
        private static const ButtonSquare:Class;

        // Sounds
        
        [Embed(source="media/audio/step.mp3")]
        private static const StepSound:Class;
        
        // Texture cache
        
        private static var sTextures			:Dictionary = new Dictionary();
        private static var sSounds				:Dictionary = new Dictionary();

        private static var sBitmapFontsLoaded	:Boolean;
        
        public static function getTexture( name:String ):Bitmap
        {
			if (sTextures[name] == undefined)
			{
				var data:Object = new Assets[name]();
				
				if (data is Bitmap) sTextures[name] =  data as Bitmap;
				//else if (data is ByteArray)
				//sTextures[name] = Texture.fromAtfData(data as ByteArray);
			}
			
			return sTextures[name];
        }
        
        public static function getSound(name:String):Sound
        {
            var sound:Sound = sSounds[name] as Sound;
            if (sound) return sound;
            else throw new ArgumentError("Sound not found: " + name);
        }
   
        public static function prepareSounds():void
        {
            sSounds["Step"] = new StepSound();   
        }
    }
}