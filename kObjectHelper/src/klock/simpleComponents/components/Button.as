/**Copyright (c) 2011 Paul Knab - Version 0.0.1*/
package klock.simpleComponents.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import klock.simpleComponents.components.base.BaseElement;
	import klock.simpleComponents.components.base.BaseLayout;
	
	public class Button extends BaseElement
	{

		//protected var _outline	:Sprite
		protected var _fillin		:Sprite;
		protected var _tf			:Label
		protected var _label		:String = "LabelText"
		protected var _buttonMode	:Boolean = false
		protected var _pushMode		:Boolean = false
		
		/**
		 * Constructor 
		 * @param initObject		A Object contains all init properties.
		 * @param label 	 		The string to use for the label.
		 * @param parent 	 		The parent DisplayObjectContainer on which to add this element. 
		 * @param defaultHandler	The event handling function to handle the default event for this component.  */	
		public function Button( initObject:Object, label:String, parent:DisplayObjectContainer = null, defaultListener:Function = null)
		{			
			_label = label
			super(initObject, parent);
			
			if( defaultListener != null ) addEventListener( MouseEvent.CLICK, defaultListener );
		}
		
		/** Initilizes the component. 	*/
		override protected function Init():void
		{			
			super.Init();	
		}
		
		/**
		 * Create child display objects. */
		override protected function AddChilds():void
		{
			addChild( _fillin  = new Sprite())
			_fillin.buttonMode = _buttonMode;
			_fillin.x = _fillin.y = BaseLayout.LEFT
	
			addChild( _tf = new Label({x:BaseLayout.LEFT , y:0, _width: __width, _height:_height}, _label, this ))
		//	_tf.setBorder( true)
		}
		
		/**
		 * Setup Event Handler.
		 * @param mode Set MouseEvent enabled true or false */
		override protected function Events( mode:Boolean ) : void
		{
			if( mode && Enabled ){
				_fillin.addEventListener	( MouseEvent.MOUSE_OVER, Listener, false, 0, true );
			}else{
				_fillin.removeEventListener ( MouseEvent.MOUSE_OVER, Listener );
				_fillin.removeEventListener ( MouseEvent.MOUSE_OUT,  Listener );
				stage.removeEventListener   ( MouseEvent.MOUSE_UP,   Listener );
				stage.removeEventListener   ( MouseEvent.MOUSE_DOWN, Listener );
			}
		}
		
		/**
		 * MouseEvent Handler
		 * @param event The MouseEvent passed by the system. */
		override protected function Listener( event:Event ):void
		{
			var mode:int = -1
			if( event.type == "mouseOut"){
				
				stage.removeEventListener   ( MouseEvent.MOUSE_UP,   Listener );
				stage.removeEventListener   ( MouseEvent.MOUSE_DOWN, Listener );
				_fillin.removeEventListener ( MouseEvent.MOUSE_OUT,  Listener );
				_fillin.addEventListener	( MouseEvent.MOUSE_OVER, Listener, false, 0, true );
				
				if( !_selected ) mode = 0 
			}
			if( event.type == "mouseOver" || event.type == "mouseUp"){
				
				stage.addEventListener   	( MouseEvent.MOUSE_UP,   Listener, false, 0, true );
				stage.addEventListener   	( MouseEvent.MOUSE_DOWN, Listener, false, 0, true );
				_fillin.addEventListener   	( MouseEvent.MOUSE_OUT,  Listener, false, 0, true );
				_fillin.removeEventListener	( MouseEvent.MOUSE_OVER, Listener );
				
				if( !_selected ) mode = 1
			}
			
			if( event.type == "mouseDown"){
				
				if( Toggled ) {
					
					_selected = ( _selected )? false : true
					mode      = ( _selected )? 2 : 1 
					
				}else{
					mode = 2
				}
			}
			
			if( mode != -1 ) {
				
				_fillin.filters = ( mode == 2 ) ? [ this.getShadow( 4, true ) ] : []
						
				BaseLayout.DRAW_OUTLINE(    this.graphics, __width, _height, ( _pushMode ) ? 0 : mode )
				BaseLayout.DRAW_FILLIN ( _fillin.graphics, __width, _height, ( _pushMode ) ? 2 : mode )
					
		//		if( !_pushMode )_tf.setColor( ( mode >= 2 ) ? BaseLayout.SELECT_TXT : BaseLayout.NORMAL_TXT )		
			}
		}
		
		private function getPushModeIndex( mode : uint ):uint
		{
			if( _pushMode && mode == 0 ) return 1

				
			return mode
		}
		
		/** Draws the visual ui of the component.*/
		override public function Draw( ):void
		{
			if( _fillin == null ) return
			super.Draw() 
			
			BaseLayout.DRAW_OUTLINE(    this.graphics, __width, _height, 0 )
			BaseLayout.DRAW_FILLIN ( _fillin.graphics, __width, _height,( _pushMode ) ? 2 : 0 )

			_tf.text = _label;
			_tf.setSize( __width -BaseLayout.LEFT*2, _tf.height )
			_tf.y = Math.round( _height / 2 - _tf.height / 2);
			_tf.Draw()
		}
		
		/** Return the instance of the button label.
		 * @return Label*/
		public function get textField():Label
		{
			return _tf	
		}
		
		/**  Get/Set the text of the button label.*/
		public function set label( value:String ):void{
			_label = value;
			Draw()
		}
		public function get label():String{
			return _label;
		}
		
		/**  Get/Set the push mode of the button.*/
		public function get pushMode():Boolean{
			return _pushMode;
		}
		public function set pushMode( value:Boolean ):void{
			_pushMode = value;
			Draw()
		}

		override public function set buttonMode( value:Boolean ):void{
			_buttonMode = value;
			_fillin.buttonMode = _buttonMode;
		}

	}
}