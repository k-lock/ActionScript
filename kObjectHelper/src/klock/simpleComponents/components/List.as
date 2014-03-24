package klock.simpleComponents.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import klock.simpleComponents.components.base.BaseElement;
	import klock.simpleComponents.components.base.BaseLayout;
	
	public class List extends BaseElement
	{
		protected var _mask				:Sprite
		protected var _items			:Array;
		protected var _itemHolder		:Sprite;
		protected var _scrollbar		:ScrollBar
		protected var _selectedIndex	:int = -1;
		protected var _listItemHeight	:Number = 20;
		
		/**
		 * Constructor 
		 * @param initObject		A Object contains all init properties.
		 * @param label 	 		The string to use for the label.
		 * @param parent 	 		The parent DisplayObjectContainer on which to add this element. 
		 * @param listItems			An array of items to display in the list.*/	
		public function List( initObject:Object, parent:DisplayObjectContainer = null, listItems:Array = null )
		{
			
			_items = (listItems != null) ? listItems :  new Array();
		
			super( initObject, parent );
	
		}
		/**
		 * Initilizes the component.
		 */
		protected override function Init() : void
		{
			super.Init();
			setSize(100, 100);
			
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		//	addEventListener(Event.RESIZE, onResize);
			
			makeListItems();
			fillItems();
		}
		
		/** Creates and adds the child display objects of this component. */
		protected override function AddChilds() : void
		{
			super.AddChilds();
	//		_panel = new Panel(this, 0, 0);
	//		_panel.color = _defaultColor;
			addChild( _itemHolder = new Sprite() );
	//		_itemHolder.x = 
			_itemHolder.y = BaseLayout.LEFT
	//		_panel.content.addChild(_itemHolder);
			_scrollbar = new ScrollBar( {x:0, y:0 },this, Slider.VERTICAL, onScroll);
			_scrollbar.setSliderParams(0, 0, 0);
			
			addChild( _mask = new Sprite() );
			_mask.x = _mask.y =  BaseLayout.LEFT

			_itemHolder.mask = _mask
			
		}
		
		/** Creates all the list items based on data. */
		protected function makeListItems():void
		{
			var item:ListItem;
			while(_itemHolder.numChildren > 0)
			{
				item = ListItem(_itemHolder.getChildAt(0));
				item.removeEventListener( MouseEvent.CLICK, onSelect );
				_itemHolder.removeChildAt(0);
			}

			var numItems:int = Math.ceil( _height / _listItemHeight-.2);
			numItems = Math.min(numItems, _items.length);
			numItems = Math.max(numItems, 1);
	
			for(var i:int = 0; i < numItems; i++)
			{
				item = new ListItem( {x:BaseLayout.LEFT, y: i * _listItemHeight}, _itemHolder );
				item.setSize( __width - BaseLayout.LEFT - uint((_scrollbar.autoHide )? 0 : 10 ) , _listItemHeight);
				item.addEventListener(MouseEvent.CLICK, onSelect);
				
			}
		
		}

		protected function fillItems():void
		{
			var offset:int = _scrollbar.value;
			var numItems:int = Math.ceil(_height / _listItemHeight);
			numItems = Math.min(numItems, _items.length);
			for(var i:int = 0; i < numItems; i++)
			{
				var item:ListItem = _itemHolder.getChildAt(i) as ListItem;
			
				if( offset + i < _items.length ) {
					item.data = _items[offset + i];
				}else{
					item.data = "";
				}
	
			/*	if(_alternateRows) {
					item.defaultColor = ((offset + i) % 2 == 0) ? _defaultColor : _alternateColor;
				}else{
					item.defaultColor = _defaultColor;
				}*/
				if( offset + i == _selectedIndex ) {
					item.selected = true;
				}else{
					item.selected = false;
				}
			}
		}
		
		/** If the selected item is not in view, scrolls the list to make the selected item appear in the view. */
		protected function scrollToSelection():void
		{
			var numItems:int = Math.ceil(_height / _listItemHeight);
			if(_selectedIndex != -1) {
				if(_scrollbar.value > _selectedIndex){
					//                    _scrollbar.value = _selectedIndex;
				}else if(_scrollbar.value + numItems < _selectedIndex){
					_scrollbar.value = _selectedIndex - numItems + 1;
				}
			}else{
				_scrollbar.value = 0;
			}
//			fillItems();
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
	
		/** Draws the visual ui of the component. */
		public override function Draw() : void
		{
			
			if( _scrollbar == null ) return
			super.Draw();
			
			_selectedIndex = Math.min(_selectedIndex, _items.length - 1);
			
	/*		
			// panel
			_panel.setSize(_width, _height);
			_panel.color = _defaultColor;
			_panel.draw();
	*/		
		
			// scrollbar
			_scrollbar.setSize( __width, _height)
			_scrollbar.x = __width - 10;
			var contentHeight:Number = _items.length * _listItemHeight;
			_scrollbar.setThumbPercent( _height / contentHeight ); 
			var pageSize:Number = Math.floor(_height / _listItemHeight);
			_scrollbar.maximum = Math.max(0, _items.length - pageSize);
	//		_scrollbar.pageSize = pageSize;
			_scrollbar.Draw();
			
			_mask.graphics.clear()
			_mask.graphics.beginFill( 0, 1) 
			BaseLayout.DRAW_RECT( _mask.graphics, __width-BaseLayout.LEFT -  uint((_scrollbar.autoHide )? 0 : 10 ), _height-BaseLayout.LEFT*2)
			BaseLayout.DRAW_OUTLINE( this.graphics, __width, _height, 0 )
			
			scrollToSelection();
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called when a user selects an item in the list.
		 */
		protected function onSelect(event:Event):void
		{
			if(! (event.target is ListItem)) return;
			
			var offset:int = _scrollbar.value;
			
			for(var i:int = 0; i < _itemHolder.numChildren; i++)
			{
				if(_itemHolder.getChildAt(i) == event.target) _selectedIndex = i + offset;
				ListItem(_itemHolder.getChildAt(i)).selected = false;
			}
			ListItem(event.target).selected = true;
			dispatchEvent(new Event(Event.SELECT));

		}
		
		/**
		 * Called when the user scrolls the scroll bar.
		 */
		protected function onScroll(event:Event):void
		{
			fillItems();
		}
		
		/**
		 * Called when the mouse wheel is scrolled over the component.
		 */
		protected function onMouseWheel(event:MouseEvent):void
		{
			_scrollbar.value -= event.delta/3;
			fillItems();
		}


///////////////////////////////////
// Getter / setters
///////////////////////////////////		
		
		/** Sets / gets the list of items to be shown. */
		public function set items(value:Array):void
		{
			_items = value;
			Draw();
		}
		public function get items():Array
		{
			return _items;
		}
		
		/** Sets the height of each list item. */
		public function set listItemHeight(value:Number):void
		{
			_listItemHeight = value;
			makeListItems();
			Draw();
		}
		public function get listItemHeight():Number
		{
			return _listItemHeight;
		}
		
		/** Sets / gets whether the scrollbar will auto hide when there is nothing to scroll. */
		public function set autoHideScrollBar(value:Boolean):void
		{
			_scrollbar.autoHide = value;
		}
		public function get autoHideScrollBar():Boolean
		{
			return _scrollbar.autoHide;
		}
		
		/** Sets / gets the index of the selected list item.  */
		public function set selectedIndex(value:int):void
		{
			if(value >= 0 && value < _items.length)
			{
				_selectedIndex = value;
				//				_scrollbar.value = _selectedIndex;
			}
			else
			{
				_selectedIndex = -1;
			}
			Draw();
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		/** Sets / gets the item in the list, if it exists. */
		public function set selectedItem(item:Object):void
		{
			var index:int = _items.indexOf(item);
			//			if(index != -1)
			//			{
			selectedIndex = index;
			Draw();
			dispatchEvent(new Event(Event.SELECT));
			//			}
		}
		
		public function get selectedItem():Object
		{
			if(_selectedIndex >= 0 && _selectedIndex < _items.length)
			{
				return _items[_selectedIndex];
			}
			return null;
		}

		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component. */	
		override public function setSize( width:Number, height:Number ):void
		{
			__width = width;
			_height = height;
			//	dispatchEvent(new Event(Event.RESIZE));

			makeListItems();
			fillItems();

			Draw()
		}
		
		
	}
}