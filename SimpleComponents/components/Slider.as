package klock.simpleComponents.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	
	import klock.simpleComponents.components.base.BaseElement;
	import klock.simpleComponents.components.base.BaseLayout;
	
	public class Slider extends BaseElement
	{
		
		protected var _handle		:Sprite;
		protected var _back			:Sprite;
		protected var _backClick	:Boolean = true;
		protected var _value		:Number = 0;
		protected var _max			:Number = 100;
		protected var _min			:Number = 0;
		protected var _tick			:Number = 0.01;
		protected var _thumbPercent :Number = 1.0
		protected var _orientation	:String;

		public static const HORIZONTAL	:String = "horizontal";
		public static const VERTICAL	:String = "vertical";
		
		/**
		 * Constructor 
		 * @param initObject		A Object contains all init properties.
		 * @param parent 	 		The parent DisplayObjectContainer on which to add this element. 
		 * @param  					orientation Whether the element will be HORIZONTAL or VERTICAL.
		 * @param defaultHandler	The event handling function to handle the default event for this component.  */	
		public function Slider( initObject:Object, parent:DisplayObjectContainer = null, orientation:String = "vertical", defaultListener:Function = null )
		{
			_orientation = orientation;
			if( initObject.hasOwnProperty("_width") )_width = initObject._width
			super( initObject, parent );
			
			if( defaultListener != null ) addEventListener( Event.CHANGE, defaultListener );
		}
		
		/** Initilizes the component. */
		override protected function Init():void
		{	
			super.Init();
			
			if(_orientation == HORIZONTAL){
				setSize(100, 10);
			}else{
				setSize(10, 100);
			}
		}
		
		/** Creates and adds the child displayObjects of this component. */
		override protected function AddChilds():void
		{
			_back = new Sprite();
			_back.x = _back.y = BaseLayout.LEFT
			_back.filters = [getShadow(3, true)];
			addChild(_back);
			
			_handle = new Sprite();
		//	_handle.filters = [getShadow(2, true)];
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
		//	_handle.buttonMode = true;
		//	_handle.useHandCursor = true;
			addChild(_handle);
		
			Draw()
		}
		
		/** Draws the back of the slider. */
		protected function drawBack():void
		{

			BaseLayout.DRAW_FILLIN( _back.graphics, _width, _height, 2 )
			BaseLayout.DRAW_OUTLINE( this.graphics, _width, _height, 0 )
			
			if(_backClick){
				_back.addEventListener(MouseEvent.MOUSE_DOWN,   onBackClick);
			}else{
				_back.removeEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
		}
		
		/** Draws the handle of the slider. */
		protected function drawHandle():void
		{	
			
			var w:Number;
			var h:Number;
			var size:Number;

			if(_orientation == HORIZONTAL){
				size = _height-BaseLayout.LEFT*2;
				h = w = size
				
				if( _thumbPercent !== 1.0 )  w = size * _thumbPercent

			}else{
				size = _width-BaseLayout.LEFT*2;	
				h = w = size
				
				if( _thumbPercent !== 1.0 )  h = size * _thumbPercent
			}
	
			_handle.graphics.clear()
			BaseLayout.DRAW_OUTLINE( _handle.graphics, w, h, 2 )
		
			positionHandle();
		}
		
		/** Adjusts value to be within minimum and maximum. */
		protected function correctValue():void
		{
			if(_max > _min){
				_value = Math.min(_value, _max);
				_value = Math.max(_value, _min);
			}else{
				_value = Math.max(_value, _max);
				_value = Math.min(_value, _min);
			}
		}
				
		/** Adjusts position of handle when value, maximum or minimum have changed. */
		protected function positionHandle():void
		{
			var range:Number;
			if(_orientation == HORIZONTAL)
			{
				range = _back.x + _back.width - _handle.width - BaseLayout.LEFT;
				_handle.x = BaseLayout.LEFT + ((_value - _min) / (_max - _min) * range);
				_handle.y = BaseLayout.LEFT;
			}else{
		
				range = _back.y + _back.height - _handle.height - BaseLayout.LEFT;
				_handle.x = BaseLayout.LEFT;
				_handle.y = BaseLayout.LEFT + ((_value - _min) / (_max - _min) * range);
			}
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/** Draws the visual ui of the component. */
		override public function Draw():void
		{
			super.Draw();
			if( _handle == null ) return 
			
			drawBack();
			drawHandle();

		}
		
		/**
		 * Convenience method to set the three main parameters in one shot.
		 * @param min 		The minimum value of the slider.
		 * @param max 		The maximum value of the slider.
		 * @param value 	The value of the slider.  */
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			this.minimum = min;
			this.maximum = max;
			this.value = value;
		}
		
		/** Sets the percentage of the size of the thumb button.*/
		public function setThumbPercent(value:Number):void
		{
			_thumbPercent = Math.min(value, 1.0);
			
			Draw();
		}
	
///////////////////////////////////
// event handlers
///////////////////////////////////
		
		/**
		 * Handler called when user clicks the background of the slider, causing the handle to move to that point. Only active if backClick is true.
		 * @param event 	The MouseEvent passed by the system.
		 */
		protected function onBackClick( event:MouseEvent ):void
		{
			if(_orientation == HORIZONTAL){
			
				_handle.x = mouseX - _handle.width * .5;
				_handle.x = Math.max( _handle.x, _back.x );
				_handle.x = Math.min( _handle.x, _back.x + _back.width - _handle.width )
				
				_value = ( _handle.x-BaseLayout.LEFT ) / ( width - height ) * ( _max - _min ) + _min;
			}else{
				_handle.y = mouseY - _handle.height * .5;
				_handle.y = Math.max( _handle.y, _back.y );
				_handle.y = Math.min( _handle.y, _back.y + _back.height - _handle.height)
				
			_value = ( _handle.y - BaseLayout.LEFT ) / ( _back.height - _handle.height ) * ( _max - _min ) + _min;	
			}
			
			correctValue();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Internal mouseDown handler. Starts dragging the handle.
		 * @param event 	The MouseEvent passed by the system.
		 */
		protected function onDrag(event:MouseEvent):void
		{
			stage.addEventListener( MouseEvent.MOUSE_UP,   onDrop);
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onSlide);
		}
		
		/**
		 * Internal mouseUp handler. Stops dragging the handle.
		 * @param event 	The MouseEvent passed by the system.
		 */
		protected function onDrop(event:MouseEvent):void
		{
			stage.removeEventListener( MouseEvent.MOUSE_UP,    onDrop);
			stage.removeEventListener( MouseEvent.MOUSE_MOVE,  onSlide);		
		}
		
		/**
		 * Internal mouseMove handler for when the handle is being moved.
		 * @param event 	The MouseEvent passed by the system.
		 */
		protected function onSlide( event:MouseEvent ):void
		{
			var oldValue:Number = _value;
			if(_orientation == HORIZONTAL){
				_handle.y = BaseLayout.LEFT
				_handle.x = mouseX - _handle.width * .5;
				_handle.x = Math.min( _handle.x, _back.x + _back.width - _handle.width );
				_handle.x = Math.max( _handle.x, _back.x);
				
				_value =  ( _handle.x - BaseLayout.LEFT ) / ( width - _height ) * ( _max - _min ) + _min;
			}else{
				_handle.x = BaseLayout.LEFT
				_handle.y = mouseY - _handle.height * .5;
				_handle.y = Math.min( _handle.y, _back.y + _back.height - _handle.height );
				_handle.y = Math.max( _handle.y, _back.y);
			
				_value = ( _handle.y- BaseLayout.LEFT ) / ( _back.height - _handle.height ) * ( _max - _min ) + _min;
			}
			
			correctValue();
			if( _value != oldValue ) dispatchEvent(new Event(Event.CHANGE, true));			
		}

///////////////////////////////////
// getter/setters
///////////////////////////////////
		
		/** Sets / gets whether or not a click on the background of the slider will move the handler to that position. */
		public function set backClick( b:Boolean ):void
		{
			_backClick = b;
			Draw();
		}
		
		public function get backClick():Boolean
		{
			return _backClick;
		}
		
		/** Sets / gets the current value of this slider. */ 
		public function set value(v:Number):void
		{
			_value = v;
			
			correctValue();
			positionHandle();
			
		}
		
		public function get value():Number
		{
			return Math.round(_value / _tick) * _tick;
		}
		
		/** Gets the value of the slider without rounding it per the tick value.*/
		public function get rawValue():Number
		{
			return _value;
		}
		
		/** Gets / sets the maximum value of this slider.*/
		public function set maximum(m:Number):void
		{
			_max = m;
			correctValue();
			positionHandle();
		}
		
		public function get maximum():Number
		{
			return _max;
		}
		
		/** Gets / sets the minimum value of ths slider. */
		public function set minimum(m:Number):void
		{
			_min = m;
			correctValue();
			positionHandle();
		}
		
		public function get minimum():Number
		{
			return _min;
		}
		
		/** Gets / sets the tick value of this slider. This round the value to the nearest multiple of this number. */
		public function set tick(t:Number):void
		{
			_tick = t;
		}
		
		public function get tick():Number
		{
			return _tick;
		}
		
		/** Gets the width value of the slider button. */
		public function get thumbPercent():Number
		{
			return _thumbPercent;
		}


	}
}