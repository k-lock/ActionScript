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
	public class IntField extends BaseElement
	{
		protected var _autoSize		:Boolean = false;
		protected var _tf			:TextField;
//		protected var _label		:String = "LabelText";
		protected var _textAlign	:String = "center"
		protected var _maximum		:Number = Number.POSITIVE_INFINITY;
		protected var _minimum		:Number = Number.NEGATIVE_INFINITY;			
		protected var _value		:int = 0;
		
		public function IntField( initObject:Object, value_:int, parent:DisplayObjectContainer = null,  defaultListener:Function = null )
		{
			_value = value_
			super( initObject, parent );

			if( defaultListener != null ) addEventListener( Event.CHANGE, defaultListener );
			
		}
		
		/** Initilizes the component. */
		override protected function Init():void
		{//trace( "BASE-INIT")
			
			super.Init();
			
		//	this.mouseEnabled = false;
		//	this.mouseChildren = false;
			
		}

		/** Create child display objects. */
		override protected function AddChilds():void
		{
			//_height = BaseLayout.TXT_FORMAT_10.size;
			_tf = new TextField();
			_tf.height = _height = 18;
			_tf.embedFonts = true;
			_tf.selectable = true;
			_tf.mouseEnabled = true;
			_tf.defaultTextFormat = new TextFormat(BaseLayout.TXT_FORMAT_10.font, BaseLayout.TXT_FORMAT_10.size, BaseLayout.TXT_FORMAT_10.color);
			_tf.type = TextFieldType.INPUT
			_tf.addEventListener( Event.CHANGE, onChange )
			_tf.restrict = "-0123456789."
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
		
		private function TextFieldBounds():void{

			if(_tf.text == "") {
				_tf.text = "X";
				_tf.height = Math.min( _tf.textHeight +4, _height );
				_tf.text = "";

			}else{
				var t:String = _value.toString();
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
				
			BaseLayout.DRAW_FIELD( this.graphics, _width, _height, 0, 2 )
		//	setColor( BaseLayout.NORMAL_TXT )
	
			_tf.text = _value.toString();

			TextFieldBounds()
			TextFormatAligment()
			
		//	trace("LABEL : ", _tf.height)
		}
		
		/** Change the color of the textfield component.
		 * @param color The Color for the label.
		 * @param alpha The Alpha for the Label.
		 * @param start The start Index.
		 * @param end 	The end Index for change.*/
		public function setColor( color:uint, alpha:Number = 1, start:int=-1, end:int=-1):void{
			
			var f:TextFormat = _tf.getTextFormat()
			f.color = color
			
			_tf.alpha = alpha
			
			_tf.setTextFormat( f, start, _tf.length)	
			_tf.textColor = color
			Draw()
		}
		
		/** Draws a border around textfield the component.
		 * @param show Draw the border.
		 * @param color The Color for the border.*/
		public function setBorder( show:Boolean, color:uint = 0xffffff ):void 
		{ 
			_tf.border = show
			_tf.borderColor = color
		}
		
///////////////////////////////////
// event handlers
///////////////////////////////////
	
		/**
		 * Internal change handler.
		 * @param event The Event passed by the system.
		 */
		protected function onChange(event:Event):void
		{
			value = new int( _tf.text )
			maximum = value
			minimum = value

			event.stopImmediatePropagation();
			dispatchEvent(event);
			
		}

///////////////////////////////////
// getter/setters
///////////////////////////////////
	
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

		/** Gets / sets the value of the Element. */
		public function set value( num:int ):void 	{ _value = num; Draw();}
		public function get value():int 			{ return _value; }
		
		/** Sets / gets the maximum value for this component. */
		public function set maximum(value:Number):void
		{
			_maximum = value;
			if(_value > _maximum)
			{
				_value = _maximum;
				Draw();
			}
		}
		public function get maximum():Number { return _maximum; }
		
		/** Sets / gets the maximum value for this component. */
		public function set minimum(value:Number):void
		{
			_minimum = value;
			if(_value < _minimum)
			{
				_value = _minimum;
				Draw();
			}
		}
		public function get minimum():Number { return _minimum; }
	}
}