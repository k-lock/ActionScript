package klock.simpleComponents.components
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import klock.simpleComponents.components.base.BaseElement;
	import klock.simpleComponents.components.base.BaseLayout;
	
	public class ListItem extends BaseElement
	{
		protected var _data				:Object;
		protected var _label			:Label;
	//	protected var _selected			:Boolean;
		protected var _mouseOver		:Boolean = false;
		
		/**
		 * Constructor 
		 * @param initObject		A Object contains all init properties.
		 * @param parent 	 		The parent DisplayObjectContainer on which to add this element. 
		 * @param data				A Object contains all list item data values.*/	
		public function ListItem( initObject:Object, parent:DisplayObjectContainer = null, data:Object = null)
		{
			_data = data;
			super( initObject, parent );
		}
		
		/**
		 * Initilizes the component.
		 */
		protected override function Init() : void
		{
			super.Init();
			
			addEventListener( MouseEvent.MOUSE_OVER, onMouseOver);
			setSize(100, 16);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function AddChilds() : void
		{
			super.AddChilds();
			_label = new Label( { x:5, y:0, textAlign:"left", _width:__width-5 }, "", this );
			_label.Draw();
	
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called when the user rolls the mouse over the item. Changes the background color. */
		protected function onMouseOver(event:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_mouseOver = true;
			Draw();
		}
		
		/**
		 * Called when the user rolls the mouse off the item. Changes the background color.  */
		protected function onMouseOut(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_mouseOver = false;
			Draw();
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.  */
		public override function Draw() : void
		{
			
			if( _label == null ) return 
			super.Draw();
			graphics.clear();
			
			if(_selected){
				graphics.beginFill(BaseLayout.SELECTED_LIST);
			}else if(_mouseOver){
				graphics.beginFill(BaseLayout.ROLL_LIST);
			}else{
				graphics.beginFill(BaseLayout.NORMAL_LIST);
			}
			graphics.drawRect(0, 0, __width, _height);
			graphics.endFill();
			
			if(_data == null) return;
			
			if( _data is String ){
				_label.text = _data as String;
			}else if(_data.hasOwnProperty("label") && _data.label is String){
				_label.text = _data.label;
			}else{
				_label.text = _data.toString();
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the string that appears in this item. */
		public function set data(value:Object):void
		{
			_data = value;
			Draw();
		}
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * Sets/gets whether or not this item is selected. */
		public function set selected(value:Boolean):void
		{
			_selected = value;
			Draw();
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		
	}
}