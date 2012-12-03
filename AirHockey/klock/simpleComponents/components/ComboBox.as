/**Copyright (c) 2011 Paul Knab - Version 0.0.1*/
package klock.simpleComponents.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import klock.simpleComponents.components.base.BaseElement;
	import klock.simpleComponents.components.base.BaseLayout;
	
	public class ComboBox extends BaseElement
	{
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		
		protected var _label:String = "";
		protected var _dropDownButton:Button;
		protected var _items:Array;
		protected var _labelButton:Button;
		protected var _list:List;
		protected var _numVisibleItems:int = 4;
		protected var _open:Boolean = false;
		protected var _openPosition:String = BOTTOM;
		protected var _stage:Stage;
		

		public function ComboBox( initObject:Object, label:String, parent:DisplayObjectContainer = null, items:Array = null, defaultListener:Function = null)
		{
			_label = label
			_items = items;
						
			super(initObject, parent);
			
			addEventListener( Event.ADDED_TO_STAGE, 	onAddedToStage);
			addEventListener( Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			if( defaultListener != null ) addEventListener( Event.SELECT, defaultListener );
		}
	
		/**
		 * Initilizes the component.
		 */
		protected override function Init():void
		{
			super.Init();
			setSize(100, 20);
			
			setLabelButtonLabel();
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected override function AddChilds():void
		{
			super.AddChilds();
			_list = new List( {name:"LIST"}, null, _items);
			_list.autoHideScrollBar = false;
			_list.addEventListener(Event.SELECT, onSelect);
	
			_list.scaleX = _list.scaleY = this.parent.scaleX
			
			_labelButton    = new Button({name:"LB",_width:_width-_height, pushMode:true },_label , this, onDropDown);
			_dropDownButton = new Button({name:"DB",x:_width-_height, _width:_height},"+", this, onDropDown);
		
		}
		
		/** Determines what to use for the main button label and sets it. */
		protected function setLabelButtonLabel():void
		{
			if(selectedItem == null){
				_labelButton.label = _label;
			}else if(selectedItem is String){
				_labelButton.label = selectedItem as String;
			}else if(selectedItem.hasOwnProperty("label") && selectedItem.label is String){
				_labelButton.label = selectedItem.label;
			}else{
				_labelButton.label = selectedItem.toString();
			}
			
		}
		
		
		/** Removes the list from the stage.  */
		protected function removeList():void
		{
			if( _stage.contains(_list)) _stage.removeChild(_list);
			_stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			_dropDownButton.label = "+";			
		}
///////////////////////////////////
// public methods
///////////////////////////////////

		public override function Draw():void
		{
			super.Draw();
			_labelButton.setSize(_width - _height + 1, _height);
			_labelButton.Draw();
			
			_dropDownButton.setSize(_height, _height);
			_dropDownButton.Draw();
			_dropDownButton.x = _width - height;
			
			_list.setSize( _width, _numVisibleItems * _list.listItemHeight);
		}
		
		/**
		 * Adds an item to the list.
		 * @param item The item to add. Can be a string or an object containing a string property named label.  */
		public function addItem(item:Object):void
		{
//			_list.addItem(item);
		}
		
		/**
		 * Adds an item to the list at the specified index.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 * @param index The index at which to add the item. */
		public function addItemAt(item:Object, index:int):void
		{
//			_list.addItemAt(item, index);
		}
		
		/**
		 * Removes the referenced item from the list.
		 * @param item The item to remove. If a string, must match the item containing that string. If an object, must be a reference to the exact same object.  */
		public function removeItem(item:Object):void
		{
//			_list.removeItem(item);
		}
		
		/**
		 * Removes the item from the list at the specified index
		 * @param index The index of the item to remove.  */
		public function removeItemAt(index:int):void
		{
//			_list.removeItemAt(index);
		}
		
		/** Removes all items from the list. */
		public function removeAll():void
		{
//			_list.removeAll();
		}
		
///////////////////////////////////
// event handlers
///////////////////////////////////

		/**
		 * Called when one of the top buttons is pressed. Either opens or closes the list.
		 */
		protected function onDropDown(event:MouseEvent):void
		{

		_open = !_open;
		
			if(_open) {
				var point:Point = new Point();
				
				if( _openPosition == BOTTOM) {
					point.y = _height;
				}else{
					point.y = -_numVisibleItems * _list.listItemHeight;
				}
				point = this.localToGlobal(point);
				_list.setPosition(point.x, point.y);
	
				_stage.addChild(_list);
				_stage.addEventListener(MouseEvent.CLICK, onStageClick);
				_dropDownButton.label = "-";
				
			}else{
				removeList();
			}
			
		}
	
		/** Called when the mouse is clicked somewhere outside of the combo box when the list is open. Closes the list. */
		protected function onStageClick(event:MouseEvent):void
		{

			if( event.target.parent == _dropDownButton || event.target.parent == _labelButton) return;
			if(new Rectangle(_list.x, _list.y, _list.width, _list.height).contains(event.stageX, event.stageY))return;
	
			_open = false;
			removeList();
		}
		
		/** Called when an item in the list is selected. Displays that item in the label button. */
		protected function onSelect(event:Event):void
		{
			_open = false;
			_dropDownButton.label = "+";
			if(stage != null && stage.contains(_list))
			{
				stage.removeChild(_list);
			}
			setLabelButtonLabel();
			dispatchEvent(event);
		}
		
		/** Called when the component is added to the stage. */
		protected function onAddedToStage(event:Event):void
		{
			_stage = stage;
		}
		
		/** Called when the component is removed from the stage. */
		protected function onRemovedFromStage(event:Event):void
		{
			removeList();
		}
		
		
///////////////////////////////////
// getter/setters
///////////////////////////////////
	
		/** Sets / gets the index of the selected list item. */
		public function set selectedIndex(value:int):void
		{
			_list.selectedIndex = value;
			setLabelButtonLabel();
		}
		public function get selectedIndex():int
		{
			return _list.selectedIndex;
		}
		
		/** Sets / gets the item in the list, if it exists.  */
		public function set selectedItem(item:Object):void
		{
			_list.selectedItem = item;
			setLabelButtonLabel();
		}
		public function get selectedItem():Object
		{
			return _list.selectedItem;
		}

		/** Sets the height of each list item.  */
		public function set listItemHeight(value:Number):void
		{
			_list.listItemHeight = value;
			Draw();
		}
		public function get listItemHeight():Number
		{
			return _list.listItemHeight;
		}
		
		/** Sets / gets the position the list will open on: top or bottom.  */
		public function set openPosition(value:String):void
		{
			_openPosition = value;
		}
		public function get openPosition():String
		{
			return _openPosition;
		}
		
		/** Sets / gets the label that will be shown if no item is selected. */
		public function set defaultLabel(value:String):void
		{
			_label = value;
			setLabelButtonLabel();
		}
		public function get defaultLabel():String
		{
			return _label;
		}
		
		/** Sets / gets the number of visible items in the drop down list. i.e. the height of the list. */
		public function set numVisibleItems( value:int ):void
		{
			_numVisibleItems = value;
			Draw();
		}
		public function get numVisibleItems():int
		{
			return _numVisibleItems;
		}
		
		/** Sets / gets whether the scrollbar will auto hide when there is nothing to scroll. */
		public function set autoHideScrollBar(value:Boolean):void
		{
			_list.autoHideScrollBar = value;
			Draw();
		}
		public function get autoHideScrollBar():Boolean
		{
			return _list.autoHideScrollBar;
		}
		
		/** Gets whether or not the combo box is currently open. */
		public function get isOpen():Boolean
		{
			return _open;
		}
	}
}