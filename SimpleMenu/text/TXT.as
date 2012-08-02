package klock.text
{	
	import flash.text.*;
	
	/** Extended TextField class.*/
	public class TXT extends TextField {

		public function TXT( _text:String, position:Object, format:Object, _autoSize:String = "left", border:Object = null){
			
			super();
			
			var f : TextFormat = new TextFormat();

			setupObjects( position, this )
			setupObjects( format, f )
			
			this.antiAliasType 		= AntiAliasType.ADVANCED
			this.defaultTextFormat  = f;
			this.embedFonts 		= true;
			this.selectable			= false;
			this.text 				= _text;	
			this.autoSize 			= _autoSize
			
			if(border) setupObjects( border, this )
		}
		public function TXT_Size( width:Number, height:Number ):void{
			
			this.width = width
			this.height = height
		}
		public function TXT_Color(color:uint, alpha:Number = 1, start:int=-1, end:int=-1):void{
			
			var f:TextFormat = this.getTextFormat()
				f.color = color
			
			this.alpha = alpha
			this.setTextFormat(f, start, end)		
		}
		public function TXT_Align( typ:String = "LEFT" ):void{
			
			var f:TextFormat = this.getTextFormat()
			
			switch(typ){
				case "LEFT" :
					f.align = TextFormatAlign.LEFT
					break
				case "RIGHT" :
					f.align = TextFormatAlign.RIGHT
					break				
				case "CENTER" :
					f.align = TextFormatAlign.CENTER
					break
			}
			
			this.setTextFormat(f)
		}
		public function TXT_Space(letterSpace:Number, leading:Number, size:Number):void{
			
			var f : TextFormat = this.getTextFormat();
			
			f.letterSpacing	= letterSpace;
			f.size			= size;
			f.leading		= leading;
			
			this.defaultTextFormat = f;
		}
		public function TXT_InputTyp(_maxChars:uint=5, borderBack:uint=1):void{
			
			if (borderBack == 1)
			{
				this.background = true
				this.border = true
			}
			
			this.type = TextFieldType.INPUT;
			this.maxChars = _maxChars
			this.selectable = true
		}
		private function setupObjects( o1:Object, o2:Object ):void{ for (var n:String in o1) if (n in o1) o2[n] = o1[n]; }

	}
}