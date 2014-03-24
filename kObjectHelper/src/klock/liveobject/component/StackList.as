/**
 * Created by PMAN on 04.03.14.
 */
package klock.liveobject.component {

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import klock.liveobject.component.ui.UI;
import klock.simpleComponents.components.CheckBox;
import klock.simpleComponents.components.Panel;
import klock.simpleComponents.components.ScrollBar;
import klock.simpleComponents.components.base.BaseElement;

public class StackList extends Sprite {

	private const MOUSE_WHELL_SPEED	:Number = 1.75;
	private const ITERATE_TIMER		:int = 30;

	private var _selectedIndex		:int = -1;
	private var _items				:Array;
	public var _debugColors		:Vector.<uint>;
	private var _listContainer		:Panel;


	public function StackList(  parent:DisplayObjectContainer = null, listItems:Array = null ){

		_items = (listItems != null) ? listItems :  new Array();
		parent.addChild(this)

		addChildren()

	}

	private function addChildren():void {

		var paHeight : uint = VTab.TAB_HEIGHT-5//UI.ITEM_LINE_HEIGHT*8;
		var paWidth : uint =  UI.ELEMENT_WIDTH;

		_debugColors = new Vector.<uint>
		_listContainer = new Panel({}, this)
		BaseElement(_listContainer).setSize( paWidth, paHeight )

		var maxCDE:uint = 0;
		var obj:Object;
		for each( obj in _items ){
			if( obj.cde > maxCDE ){
				maxCDE = obj.cde;
			}
		}

		for each( obj in _items )addItem(maxCDE )

		addEventListener( "LIST_CHANGE", onListChange)
		addEventListener(MouseEvent.MOUSE_WHEEL, onMouseScroll);
		addEventListener("onUIChange", onEnableItem );

		var scHBar:ScrollBar
		var scVBar:ScrollBar
		var vBar:Boolean = _listContainer.height > paHeight
		var hBar:Boolean = _listContainer.width  > paWidth

		if( vBar ){

			scVBar = new ScrollBar({y:0,x:paWidth-10},this,"vertical", onScroll)
			scVBar.name = "vbar"
			scVBar.setSliderParams( 0, paHeight- _listContainer.height- (hBar ? 10 : 0), 0)
			scVBar.setSize( 10, paHeight - (hBar ? 10 : 0))

		}if( hBar ){

			scHBar = new ScrollBar({x:0,y:paHeight-10},this,"horizontal", onScroll)
			scHBar.name = "hbar"
			scHBar.setSliderParams( 0, paWidth- _listContainer.width- (vBar ? 10 : 0) , 0)
			scHBar.setSize( paWidth, 10)

		}
	}

	private function addItem( maxCDE:uint ):StackItem {

		var c:uint =0xffffff*Math.random()
		_debugColors.push(c)


		var i:uint =  _listContainer.content.numChildren

		trace( "add ITem", i)
		var element:StackItem = new StackItem({x: 0 ,y: i * UI.ITEM_LINE_HEIGHT}, _listContainer.content,c, _items[i] ,_items[i].cde, maxCDE );
		element.setSize( maxCDE * 5 +  UI.ELEMENT_WIDTH-50,element.height)
		element._index = i;
		element.addEventListener(MouseEvent.CLICK, onSelect);
		return element;
	}

	// ----------------------------------------------------------------------------------------------------------------- list events

	protected function onEnableItem(event:Event):void
	{
		var item:StackItem = event.target as StackItem
		item._data.obj.visible = CheckBox(item.ckbox).selected;

	}

	private function onMouseScroll(event:MouseEvent):void {

		var scvBar:ScrollBar = getChildByName("vbar") as ScrollBar;
		if( scvBar != null){
			var mw:Number = event.delta;
			scvBar.value +=mw *MOUSE_WHELL_SPEED;
			scvBar.dispatchEvent( new Event("change", true))
		}
	}
	private function onScroll(event:Event):void {

		if( event.type == "change" ){
			var scBar:ScrollBar = event.currentTarget as ScrollBar
			if( scBar.name == "vbar"){
				_listContainer.content.y = scBar.value
			}else if( scBar.name == "hbar"){
				_listContainer.content.x = scBar.value
			}
		}
	}

	// ----------------------------------------------------------------------------------------------------------------- listItem events

	private function onListChange(event:Event):void {

		var item:StackItem = event.target as StackItem
		var childObj:Object = _items[item._index]

		iteratMode = item.IS_open;
		iteratList = []
		iterate(null,childObj.obj);

		var t:Timer = new Timer(0,ITERATE_TIMER)
		t.start()
		t.addEventListener(TimerEvent.TIMER_COMPLETE, onIterateComplete );

	}

	//------------------------------------------------------------------------------------------------------------------ object deep search

	private var iteratList:Array
	private var iteratMode:Boolean = false;

	private function iterate(task:Function,dispObjContainer:DisplayObjectContainer):void
	{
		for each( var obj:Object in _items ){
			if( obj.par == dispObjContainer ){
				iteratList.push( obj.index )
				if(obj.obj is DisplayObjectContainer && obj.obj.visible){
					this.iterate(task,obj.obj as DisplayObjectContainer);
				}
			}
		}
	}

	private function onIterateComplete(event:TimerEvent):void {

		for each( var i:uint in iteratList ){
			_listContainer.content.getChildAt(i).visible = iteratMode;
		}

		var ypos:uint = 0;
		for each( var obj:Object in _items ){
			if( _listContainer.content.getChildAt(obj.index).visible ){
				_listContainer.content.getChildAt(obj.index).y = ypos*UI.ITEM_LINE_HEIGHT
				ypos++;
			}
		}

		var t:Timer = event.target as Timer;
		t.removeEventListener(TimerEvent.TIMER_COMPLETE, onIterateComplete );

	}

	//------------------------------------------------------------------------------------------------------------------ list item selection

	private function onSelect(event:Event):void
	{
		if(! (event.target is StackItem)) return;

		for(var i:int = 0; i < _listContainer.content.numChildren; i++)
		{
			if(_listContainer.content.getChildAt(i) == event.target) _selectedIndex = i;
			StackItem(_listContainer.content.getChildAt(i)).selected = false;
		}
		StackItem(event.target).selected = true;
		dispatchEvent(new Event(Event.SELECT));

	}

	public function get selectedIndex():int {
		return _selectedIndex;
	}

	public function set selectedIndex(value:int):void {
		_selectedIndex = value;
		StackItem(_listContainer.content.getChildAt(_selectedIndex)).dispatchEvent(new MouseEvent(MouseEvent.CLICK, true));

	}

	public function get listContainer():Panel {
		return _listContainer;
	}


}
}
