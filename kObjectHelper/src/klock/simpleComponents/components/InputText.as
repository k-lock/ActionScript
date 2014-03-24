/**Copyright (c) 2011 Paul Knab - Version 0.0.1*/
package klock.simpleComponents.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextExtent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;
	
	import klock.simpleComponents.components.base.BaseElement;
	import klock.simpleComponents.components.base.BaseLayout;

	public class InputText extends BaseElement
	{
		protected var _tf			:TextField;
		protected var _label		:String = "type in ..";
		protected var _password		:Boolean = false;
		protected var _textAlign	:String = "center"
		/**
		 * Constructor 
		 * @param initObject		A Object contains all init properties.
		 * @param label 	 		The string to use for the label.
		 * @param parent 	 		The parent DisplayObjectContainer on which to add this element. 
		 * @param defaultHandler	The event handling function to handle the default event for this component.  */	
		public function InputText( initObject:Object, label:String, parent:DisplayObjectContainer = null, defaultListener:Function = null )
		{
			_label = label
			super( initObject, parent );

			if( defaultListener != null ) addEventListener( Event.CHANGE, defaultListener );
		}
		
		/** Initializes the component.*/
		override protected function Init():void
		{
			super.Init();
		}
		
		/** Create child display objects. */
		override protected function AddChilds():void
		{
	
			_tf = new TextField();
			_tf.height = _height// = 18;
			_tf.embedFonts = true;
			_tf.selectable = true;
			_tf.defaultTextFormat = new TextFormat(BaseLayout.TXT_FORMAT_10.font, BaseLayout.TXT_FORMAT_10.size, BaseLayout.TXT_FORMAT_10.color);
			_tf.text = _label;
			_tf.type = TextFieldType.INPUT
			_tf.addEventListener( Event.CHANGE, onChange )
		//	setBorder( true, 0xff6600 )			
			addChild(_tf);

			restrict = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZöäüßÖÄÜ!%&(),;:.-+*/0123456789 "
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
				case "justify" : f.align = TextFormatAlign.JUSTIFY
					break
			}
			_tf.setTextFormat( f )
				
		}
		
	/*	public function getOptimalHeight():Number
		{ 
			if ( _tf.text == "" || _tf == null) return -1
			
			var metrics:TextLineMetrics = _tf.getLineMetrics(0); 
	
	trace( metrics.descent)
			var lineHeight:Number = metrics.height; 
		

			return lineHeight;  
		}
	*/	
		private function TextFieldBounds():void
		{
			_tf.text = (_label == null) ? "" : _label;
			_tf.width = __width - BaseLayout.LEFT*2;
			
			if(_tf.text == ""){
				_tf.text = "X";
				_tf.height = Math.min( _tf.textHeight, _height );
				_tf.text = "";
			}else{
				_tf.height = Math.min( _tf.textHeight+4, _height);
			}
	
			_tf.x = BaseLayout.LEFT;
			_tf.y = (_height / 2) - (_tf.height / 2);
			
		//	_tf.setSize( _width-_height, _height )
			_tf.y = Math.round( _height *.5 -  _tf.getLineMetrics(0).height *.5)- _tf.getLineMetrics(0).descent;

		}
		
///////////////////////////////////
// public methods
///////////////////////////////////
		
		/** Draws the visual ui of the component.*/
		override public function Draw( ):void
		{	
			if( _tf == null ) return
			
			super.Draw()
	
			BaseLayout.DRAW_FIELD( this.graphics, __width, _height, 0, 2 )
			setColor( BaseLayout.NORMAL_TXT )

			_tf.displayAsPassword = _password;
			_tf.text = _label = ( _label != null ) ? _label : ""	

			TextFieldBounds()
			TextFormatAligment()
		
			
		}
		/** Change the color of the textfield component.
		 * @param color 	The Color for the label.
		 * @param alpha 	The Alpha for the Label.
		 * @param start 	The start Index.
		 * @param end 		The end Index for change.*/
		public function setColor(color:uint, alpha:Number = 1, start:int=-1, end:int=-1):void{
			
			var f:TextFormat = _tf.getTextFormat()
			f.color = color
			
			_tf.alpha = alpha
			_tf.setTextFormat(f, start, end)		
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
// event handlers
///////////////////////////////////
		
		/**
		 * Internal change handler.
		 * @param event 	The Event passed by the system.
		 */
		protected function onChange(event:Event):void
		{
			_label = _tf.text;
			event.stopImmediatePropagation();
			dispatchEvent(event);

		}
		
///////////////////////////////////
// Getters / Setters
///////////////////////////////////		
		
		/** Gets / sets the text shown in this textfield. */
		public function set text( text:String ):void
		{
			_label = text;
			if(_label == null) _label = "";
			Draw();
		}
		public function get text()			:String 	{ return _label; }
		/** Returns a reference to the textfield in the component. */
		public function get textField()		:TextField 	{ return _tf; }
		
		/** Gets / sets the list of characters that are allowed in this textfield. */
		public function set restrict( restrict:String ):void { _tf.restrict = restrict; }
		public function get restrict()		:String 		 { return     _tf.restrict; }
		
		/** Gets / sets the maximum number of characters that can be shown in this InputText.  */
		public function set maxChars( max:int ):void 	{ _tf.maxChars  = max; }
		public function get maxChars()		:int 		{ return _tf.maxChars; }
		
		/** Gets / sets whether or not this input text will show up as password. */
		public function set password( b:Boolean ):void { _password = b; Draw();}
		public function get password():Boolean		   { return _password; }
		
		/**
		 * Sets/gets whether this component is enabled or not. */
		public override function set Enabled(value:Boolean):void
		{
			super.Enabled = value;
			_tf.tabEnabled = value;
			
		}
		/** Sets the TextFormatAlign [ LEFT, CENTER, RIGHT ] to the textfield. */
		public function set textAlign( value:String ):void { _textAlign = value; Draw();}

	}
}