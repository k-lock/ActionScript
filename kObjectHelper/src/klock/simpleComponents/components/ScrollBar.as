package klock.simpleComponents.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	
	import klock.simpleComponents.components.base.BaseElement;
	import klock.simpleComponents.components.base.BaseLayout;

	public class ScrollBar extends BaseElement
	{
		
	//	protected const DELAY_TIME:int = 500;
	//	protected const REPEAT_TIME:int = 100; 
		protected const UP:String = "up";
		protected const DOWN:String = "down";
		
		protected var _autoHide			:Boolean = false;
		protected var _upButton			:Button;
		protected var _downButton		:Button;
		protected var _scrollSlider		:Slider;
		protected var _orientation		:String;
		protected var _lineSize			:int = 1;
		protected var _downIcon			:Shape
		protected var _upIcon			:Shape
		/**
		 * Constructor 
		 * @param initObject		A Object contains all init properties.
		 * @param parent 	 		The parent DisplayObjectContainer on which to add this element. 
		 * @param  					orientation Whether the element will be HORIZONTAL or VERTICAL.
		 * @param defaultHandler	The event handling function to handle the default event for this component.  */	
		public function ScrollBar( initObject:Object, parent:DisplayObjectContainer = null , orientation:String = "horizontal", defaultListener:Function = null )
		{
			_orientation = orientation;
			super( initObject, parent );
			
			if( defaultListener != null ) addEventListener( Event.CHANGE, defaultListener );
		}
		
		/** Initializes the component. */
		protected override function Init():void
		{
			super.Init();
			if(_orientation == Slider.HORIZONTAL) {
				setSize(100, 10);
			}else{
				setSize(10, 100);
			}
		/*	_delayTimer = new Timer(DELAY_TIME, 1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer = new Timer(REPEAT_TIME);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);*/
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function AddChilds():void
		{
			_scrollSlider = new Slider( { x:10 }, this, _orientation, onChange);
			_scrollSlider.setSize( 80, 10 )
	
			_upButton = new Button( {x:0, y:0, _width: 10}, "+", this );
			_upButton.addEventListener( MouseEvent.MOUSE_DOWN, onUpClick );
			_upButton.removeChild( _upButton.textField )
			_upButton.setSize( 10, 10 );
						
			_downButton = new Button( {x:__width-_height*.5, y:0, _width: 10}, "-", this );
			_downButton.addEventListener( MouseEvent.MOUSE_DOWN, onDownClick );
			_downButton.setSize( 10, 10 );
			_downButton.removeChild( _downButton.textField )

			addChild( _upIcon = new Shape)
			BaseLayout.DRAW_TRIANGLE( _upIcon.graphics,  (_orientation == Slider.HORIZONTAL)? 3 : 1, 8, 0x999999, 1, 1, 1 )
				
			addChild( _downIcon = new Shape)
			BaseLayout.DRAW_TRIANGLE( _downIcon.graphics,(_orientation == Slider.HORIZONTAL)? 2 : 0, 8, 0x999999, 1, 1, 1 )
		}
		
///////////////////////////////////
// public methods
///////////////////////////////////

		/**
		 * Convenience method to set the three main parameters in one shot.
		 * @param min The minimum value of the slider.
		 * @param max The maximum value of the slider.
		 * @param value The value of the slider.
		 */
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			_scrollSlider.setSliderParams(min, max, value);
		}
		
		/** Sets the percentage of the size of the thumb button. */
		public function setThumbPercent(value:Number):void
		{
			_scrollSlider.setThumbPercent(value);
		}
		
		/** Draws the visual ui of the component. */
		override public function Draw():void
		{
			super.Draw();
			if(_orientation == Slider.VERTICAL){
				_scrollSlider.x = 0;
				_scrollSlider.y = 10;
				_scrollSlider.setSize( 10, _height - 20 )
				_downButton.x = _upIcon.x = 0;
				_downButton.y = _upIcon.y = _height - 10;
			}else{
				_scrollSlider.x = 10;
				_scrollSlider.y = 0;
				_scrollSlider.setSize( __width - 20, 10 )
				_downButton.x = _upIcon.x =__width - 10;
				_downButton.y = _upIcon.y = 0;
			}
			
			_scrollSlider.Draw();
			
			if(_autoHide){
				visible = false //_scrollSlider.thumbPercent < 1.0;
			}else{
				visible = true;
			}
		}
		
///////////////////////////////////
// event handlers
///////////////////////////////////

		protected function onUpClick(event:MouseEvent):void
		{
			goUp();
	//		_shouldRepeat = true;
	//		_direction = UP;
	//		_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function goUp():void
		{
			_scrollSlider.value -= _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onDownClick(event:MouseEvent):void
		{
			goDown();
	//		_shouldRepeat = true;
	//		_direction = DOWN;
	//		_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function goDown():void
		{
			_scrollSlider.value += _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}
	
		protected function onMouseGoUp(event:MouseEvent):void
		{
	//		_delayTimer.stop();
	//		_repeatTimer.stop();
	//		_shouldRepeat = false;
		}
		
		protected function onChange(event:Event):void
		{
			dispatchEvent( event );
		}

		/** Sets / gets the current value of this scroll bar. */
		public function set value(v:Number):void
		{
			_scrollSlider.value = v;
		}
		
		public function get value():Number
		{
			return _scrollSlider.value;
		}
		
		/** Sets / gets whether the scrollbar will auto hide when there is nothing to scroll. */
		public function set autoHide(value:Boolean):void
		{
			_autoHide = value;
			Draw();
		}
		public function get autoHide():Boolean
		{
			return _autoHide;
		}
		/** Sets / gets the minimum value of this scroll bar. */
		public function set minimum(v:Number):void
		{
			_scrollSlider.minimum = v;
		}
		public function get minimum():Number
		{
			return _scrollSlider.minimum;
		}
		
		/** Sets / gets the maximum value of this scroll bar. */
		public function set maximum(v:Number):void
		{
			_scrollSlider.maximum = v;
		}
		public function get maximum():Number
		{
			return _scrollSlider.maximum;
		}
		
		/** Sets / gets the amount the value will change when up or down buttons are pressed.  */
		public function set lineSize(value:int):void
		{
			_lineSize = value;
		}
		public function get lineSize():int
		{
			return _lineSize;
		}
		
		/** Sets / gets the amount the value will change when the back is clicked. */
/*		public function set pageSize(value:int):void
		{
			_scrollSlider.pageSize = value;
			Draw();
		}
		public function get pageSize():int
		{
			return _scrollSlider.pageSize;
		}*/
	}
}