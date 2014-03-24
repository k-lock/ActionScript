package klock.liveobject.component {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import klock.liveobject.utils.ListUtils;

import klock.liveobject.utils.StringUtils;
import klock.simpleComponents.components.CheckBox;

public class VTab_B extends BaseTab {

	private var _stackList			:StackList
	private var _childList          :Array = [];
	private var _watchIsContainer	:Boolean = false;


	public function VTab_B( _tabObject:TabObject, watchObject:DisplayObject ) {

		super(_tabObject,watchObject);

		initObjects();
	}


	private function initObjects():void {

		_childList = []

		createChildList();

	}

	//------------------------------------------------------------------------------------------------------------------

	private function createChildList():void {

		var i:int=0;

		ListUtils.objectz = [];
		_watchIsContainer = ( _watchObject is DisplayObjectContainer  && DisplayObjectContainer(_watchObject).numChildren>0);
		if (_watchObject is DisplayObjectContainer ){

			ListUtils.traceDisplayList(_watchObject)

		}else{
			ListUtils.objectz.push({ obj:_watchObject, par:_watchObject.parent, cde:0})
		}

		for each( var d:Object in ListUtils.objectz )
		{
			_childList.push( addChildObject( d , i) );
			i++;
		}
		ListUtils.objectz = [];
		childStackInit()
	}

	private function addChildObject(d:Object, i:uint):Object {

		var obj:DisplayObject = d.obj;
		var tStr:String = StringUtils.clearType( obj.toString() )
		var nStr:String = obj.name;
		var arrow:String = (obj is DisplayObjectContainer)? "+" : "-";

		return {

			label:arrow+","+nStr + ","+  tStr,
			obj: d.obj,
			par: d.par,
			arr:(obj is DisplayObjectContainer && DisplayObjectContainer(obj).numChildren>0)?1:3,
			index: i,
			open:true ,
			cde: d.cde

		};
	}

	//------------------------------------------------------------------------------------------------------------------

	private function childStackInit():void {

		_stackList = new StackList(this, _childList)
		_stackList.addEventListener(MouseEvent.CLICK, onWatchObjectChange );
		_stackList.selectedIndex = 0

	}

	private function onWatchObjectChange(event:MouseEvent = null):void {




		var l:StackList = StackList(event.currentTarget);
		if( l!= null ){

			if(l.selectedIndex == -1 ) l.selectedIndex = 0

			watchObject = _childList[l.selectedIndex].obj
			_watchIsContainer = (_watchObject is DisplayObjectContainer)



		}
	}


	override public function set watchObject(value:DisplayObject):void {
		super.watchObject = value;

		dispatchEvent(new Event("WatchObjectChange",true))
	}
}
}
