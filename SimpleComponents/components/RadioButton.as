package klock.simpleComponents.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextLineMetrics
		
	import klock.simpleComponents.components.base.BaseElement;
	import klock.simpleComponents.components.base.BaseLayout;
	
	public class RadioButton extends BaseElement
	{
		protected var _tf			:Label;
		protected var _label		:String = "LabelText";
		protected var _button		:Sprite
		
		/**
		 * Constructor 
		 * @param initObject		A Object contains all init properties.
		 * @param label 	 		The string to use for the label.
		 * @param parent 	 		The parent DisplayObjectContainer on which to add this element. 
		 * @param defaultHandler	The event handling function to handle the default event for this component.  */	
		public function RadioButton( initObject:Object, label:String, parent:DisplayObjectContainer = null, defaultListener:Function = null )
		{	
			_label = label
			super( initObject, parent );
			
			if( defaultListener != null ) addEventListener( MouseEvent.CLICK, defaultListener );
		}
		
		/** Initilizes the component. */
		override protected function Init():void
		{
			
			super.Init();
			
			buttonMode = true;
			//	useHandCursor = true;
			mouseChildren = false;
			
		}
		
		/** Create child display objects. */
		override protected function AddChilds():void
		{
			
			addChild( _button = new Sprite())
			addChild( _tf = new Label({x:_height, y:0 , _width: _width-_height , textAlign:"left"}, _label, this ))
		//	_tf.setColor( 0xff6600)
		//	_tf.setBorder( true)
			
			_button.visible = false
			_button.filters = [ this.getShadow( 2, true ) ]
		//	this.filters    = [ this.getShadow( 3, true ) ]
			
			addEventListener( MouseEvent.CLICK, onClick );	
		}

///////////////////////////////////
// event handler
///////////////////////////////////

		/**
		 * Internal click handler.
		 * @param event 	The MouseEvent passed by the system. */
		protected function onClick(event:MouseEvent):void
		{
			_selected = !_selected;
			_button.visible = _selected;
			
		}

///////////////////////////////////
// public methods
///////////////////////////////////

		/** Draws the visual ui of the component.*/
		override public function Draw( ):void
		{	
			if( _tf == null ) return
			this.graphics.clear()
			BaseLayout.DRAW_ROUNDFIELD( this.graphics, _height, 0)
	
			_tf.text = _label;
			_tf.Draw()
			_tf.setSize( _width-_height, 18 )
			_tf.x = _height
			_tf.y = Math.round(_height *.5 -  _tf.textField.getLineMetrics(0).height *.5)- _tf.textField.getLineMetrics(0).descent;
			
			_button.graphics.clear()
			BaseLayout.DRAW_ROUNDFIELD( _button.graphics, _height, 1 )//,  _height*.4,   _height*.4 )
			_button.x = (_height*.5 - _button.width*.5 )// right align (_width-_height) + (_height*.5 - _button.width*.5 )
			_button.y = (_height*.5 - _button.height*.5 )
			
			
		}
///////////////////////////////////
// getter/setters
///////////////////////////////////

		/** Sets / gets the label text shown on this CheckBox. 
		 * @param text 		The label string. */
		public function set label( text:String ):void
		{
			_label = text;
			Draw();
		}
		public function get label():String
		{
			return _label;
		}
		
		/** Sets / gets the selected state of this CheckBox.*/
		public function set selected( value:Boolean ):void
		{
			_selected = value;
			_button.visible = _selected;
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		/** Sets/gets whether this component will be enabled or not. */
		public override function set Enabled(value:Boolean):void
		{
			super.Enabled = value;
			mouseChildren = false;
		}
		
		public function get labelField():Label
		{
			return _tf;
		}
		
	}
}