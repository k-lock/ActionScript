package klock.simpleComponents.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import klock.simpleComponents.components.base.BaseElement;
	import klock.simpleComponents.components.base.BaseLayout;

	[Event(name="resize", type="flash.events.Event")]
	public class Label extends BaseElement
	{
		protected var _autoSize		:Boolean = false;
		protected var _tf			:TextField;
		protected var _label		:String = "LabelText";
		protected var _textAlign	:String = "center"
		
		/**
		 * Constructor 
		 * @param initObject		A Object contains all init properties.
		 * @param label 	 		The string to use for the label.
		 * @param parent 	 		The parent DisplayObjectContainer on which to add this element. 
		 * @param defaultHandler	The event handling function to handle the default event for this component.  */	
		public function Label( initObject:Object, label:String, parent:DisplayObjectContainer = null,  defaultListener:Function = null )
		{
			_label = label
			super( initObject, parent );

			if( defaultListener != null ) addEventListener( Event.CHANGE, defaultListener );
			
		}
		
		/** Initilizes the component. */
		override protected function Init():void
		{			
			super.Init();
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
		}

		/** Create child display objects. */
		override protected function AddChilds():void
		{
			//_height = BaseLayout.TXT_FORMAT_10.size;
			_tf = new TextField();
			_tf.height = _height = 18;
			_tf.embedFonts = true;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			_tf.defaultTextFormat = new TextFormat(BaseLayout.TXT_FORMAT_10.font, BaseLayout.TXT_FORMAT_10.size, BaseLayout.TXT_FORMAT_10.color);
			_tf.text = _label;
	
			addChild(_tf);
	
			Draw()
		}
		/** Setup the TextFormatAlign for the textfield. */
		private function TextFormatAligment():void{	
						
			var f:TextFormat = _tf.getTextFormat()
			switch( _textAlign ){
				case "left"  : f.align = TextFormatAlign.LEFT 
					break;
				case "right" : f.align = TextFormatAlign.RIGHT
					break				
				case "center": f.align = TextFormatAlign.CENTER
					break
			}
			_tf.setTextFormat( f )
		}
		/** Intern setup function the TextFormatAlign for the textfield. */
		private function TextFieldBounds():void{

			if(_tf.text == "") {
				_tf.text = "X";
				_tf.height = Math.min( _tf.textHeight +4, _height );
				_tf.text = "";

			}else{
				var t:String = _label
				_tf.text = "X"
				_tf.height = Math.min( _tf.textHeight +4, _height );
				_tf.text = t
			}
			
			if( _autoSize ){
				_tf.autoSize = _textAlign;
				_width = _tf.width;
				
			} else {
				_tf.autoSize = TextFieldAutoSize.NONE;
				_tf.width = _width;
			}
			
			_height =_tf.height
			_tf.y = Math.round( _height / 2 - _tf.height / 2);
			_tf.y = ( _tf.y < 0 ) ? 0 : _tf.y

		}

///////////////////////////////////
// public methods
///////////////////////////////////

		/** Draws the visual ui of the component.*/
		override public function Draw( ):void
		{	

			if( _tf == null ) return
			_tf.text = _label;

			TextFieldBounds()
			TextFormatAligment()
			
		//	trace("LABEL : ", _tf.height)
		}
		
		/** Change the color of the textfield component.
		 * @param color 	The Color for the label.
		 * @param alpha 	The Alpha for the Label.
		 * @param start 	The start Index.
		 * @param end 		The end Index for change.*/
		public function setColor( color:uint, alpha:Number = 1, start:int=-1, end:int=-1):void{
			
			var f:TextFormat = _tf.getTextFormat()
			f.color = color
			
			_tf.alpha = alpha
			
			_tf.setTextFormat( f, start, _tf.length)	
			_tf.textColor = color
			Draw()
		}
		
		/** Draws a border around textfield the component.
		 * @param show 		Draw the border.
		 * @param color 	The Color for the border.*/
		public function setBorder( show:Boolean, color:uint = 0xffffff ):void 
		{ 
			_tf.border = show
			_tf.borderColor = color
		}	
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/** Gets / sets the text of this Label.  */
		public function set text( t:String ):void
		{
			_label = t;
			Draw();
		}
		public function get text():String { return _label; }
		
		/** Gets / sets whether or not this Label will autosize. */
		public function set autoSize( b:Boolean ):void 	{ _autoSize = b; }
		public function get autoSize():Boolean 			{ return _autoSize; }
		
		/** Gets / sets whether or not this Label will autosize. */
		public function set textAlign( p:String ):void   
		{ 
			_textAlign = p; 		
			Draw();
		}
		public function get textAlign():String { return _textAlign; }
		
		/** Gets the internal TextField of the label if you need to do further customization of it.  */
		public function get textField():TextField { return _tf; }


	}
}