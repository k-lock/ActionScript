/**Copyright (c) 2011 Paul Knab - Version 0.0.1*/
package klock.simpleComponents.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import klock.simpleComponents.components.base.BaseElement;
	import klock.simpleComponents.components.base.BaseLayout;
	
	public class NumStep extends BaseElement
	{

		protected var _plus		:Button
		protected var _minus	:Button
		protected var _tf		:InputText

		protected var _value			:Number = 0	
		protected var _step				:Number = 1;
		protected var _labelPrecision	:int = 1;
		protected var _maximum			:Number = Number.POSITIVE_INFINITY;
		protected var _minimum			:Number = Number.NEGATIVE_INFINITY;
	
		/**
		 * Constructor 
		 * @param initObject		A Object contains all init properties.
		 * @param value 	 		The Number to use for the number field.
		 * @param parent 	 		The parent DisplayObjectContainer on which to add this element. 
		 * @param defaultHandler	The event handling function to handle the default event for this component.  */	
		public function NumStep( initObject:Object, value:Number, parent:DisplayObjectContainer = null, defaultListener:Function = null)
		{
			_value = value
			super( initObject, parent);
		 
			if( defaultListener != null ) addEventListener( Event.CHANGE, defaultListener );
		}
		
		/** Initilizes the component. */
		override protected function Init():void
		{			
			super.Init();	
		}
		
		/** Create child display objects. */
		override protected function AddChilds():void
		{
			addChild( _tf = new InputText( {x:_height, y:0, _width: _width-_height*2 }, _value.toString(), this, onValueTextChange ) )
			addChild( _minus = new Button( {x:0, y:0, _width:_height}, "-", this ) )
			addChild( _plus  = new Button( {x:_width-_height, y:0,_width:_height}, "+", this ) )	

			_tf.textField.restrict = "-0123456789.";
			
			_minus.addEventListener(MouseEvent.MOUSE_DOWN, onMinus, false, 0, true);
			_plus.addEventListener(MouseEvent.MOUSE_DOWN,  onPlus , false, 0, true);
		}
		/** Increments the value by the step amount.*/
		protected function increment():void
		{
			if(_value + _step <= _maximum){
				_value += _step;
				Draw();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		/** Decrements the value by the step amount.*/
		protected function decrement():void
		{
			if(_value - _step >= _minimum){
				_value -= _step;
				Draw();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
////////////////////////////////////
// event handlers
///////////////////////////////////
		
		/**
		 * Called when the minus button is pressed. Decrements the value by the step amount. */
		protected function onMinus(event:MouseEvent):void
		{
			decrement();
		}
		
		/**
		 * Called when the plus button is pressed. Increments the value by the step amount. */
		protected function onPlus(event:MouseEvent):void
		{
			increment();
		}
		
		/** Called when the value is changed manually. */
		protected function onValueTextChange(event:Event):void
		{
			event.stopImmediatePropagation();
			var newVal:Number = Number(_tf.text);
			if( newVal <= _maximum && newVal >= _minimum )
			{
				_value = newVal;
				Draw();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
///////////////////////////////////
// public methods
///////////////////////////////////
		/** Draws the visual ui of the component.*/	
		override public function Draw( ):void
		{
			if( _tf == null ) return 
			
			_tf.text = (Math.round(_value * Math.pow(10, _labelPrecision)) / Math.pow(10, _labelPrecision)).toString();
		    _tf.setSize   ( _width-_height*2, _height )
			_minus.setSize( _height			, _height )
			_plus.setSize ( _height			, _height )
			
			_tf.setPosition( _height, 0 )
			_minus.setPosition( 0, 0 )
			_plus.setPosition( _width-_height, 0 )

			_minus.Draw()
			_plus.Draw()
				
		}
		
////////////////////////////////////
// Setters / getters
///////////////////////////////////		
		
		/** Sets / gets the current value of this component. */
		public function set value( val:Number ):void
		{
			if(val <= _maximum && val >= _minimum)
			{
				_value = val;
				Draw();
			}
		}
		public function get value():Number { return _value; }
		
		/** Sets / gets the amount the value will change when the up or down button is pressed. Must be zero or positive.  */
		public function set step(value:Number):void
		{
			if(value < 0) 
			{
				throw new Error("NumericStepper step must be positive.");
			}
			_step = value;
		}
		public function get step():Number { return _step; }
		
		/** Sets / gets how many decimal points of precision will be shown. */
		public function set labelPrecision(value:int):void
		{
			_labelPrecision = value;
			Draw();
		}
		public function get labelPrecision():int { return _labelPrecision; }
		
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
		
		/** Sets / gets the minimum value for this component. */
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