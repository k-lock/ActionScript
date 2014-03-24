package klock.liveobject.component {

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;

public class TabObject extends Sprite {

	public var tabs:Vector.<VTab> = new Vector.<VTab>();
	private var _tabNames:Vector.<String>  = null;
	private var _currentIndex:uint = 0;
	private var _watchObject:DisplayObject = null;

	public function TabObject(initObject:Object, tabNames:Vector.<String> , parent:DisplayObjectContainer = null) {

		if( parent     != null ) parent.addChild( this );
		if( initObject != null ) for(var n:String in initObject)if (n in initObject) this[n] = initObject[n];

		_tabNames = tabNames;

		init();
	}

	private function init():void {

		AddChildren();
		AddEventHandlers( true );
		Draw();
	}

	private function AddEventHandlers(mode:Boolean):void {
		if(mode){
			addEventListener( "TabChange", onEventHandler)
			tabs[1].addEventListener( "WatchObjectChange",onEventHandler )
		}else{
			removeEventListener("TabChange", onEventHandler)
			BaseTab(tabs[1].tabContainer).removeEventListener("WatchObjectChange", onEventHandler)
		}


	}



	private function onEventHandler(event:Event):void {

		if(  event.type == "WatchObjectChange" ){

			watchObject = VTab_B(tabs[1].tabContainer.getChildAt(0)).watchObject

		}else if(  event.type == "TabChange" ){
			currentIndex = VTab(event.target).index;
		}
	}

	private function AddChildren():void {

		var tab:VTab;
		var i:uint = 0;
		var n:uint = _tabNames.length;

		for(i;i<n;i++){
			addChild(tab = new VTab({_label:_tabNames[i], 	selected:false, 	index:i}));
			tabs.push( tab )
		}
	}

	private function Draw():void{

		setTabSelection();
	}

	private function setTabSelection():void {

		var i:uint = 0;
		var n:uint = tabs.length;
		for(i;i<n;i++){
			if(i!=_currentIndex)tabs[i].selected = false;
		 }
		tabs[_currentIndex].selected = true;
	}

	public function get currentIndex():uint {
		return _currentIndex;
	}

	public function set currentIndex(value:uint):void {
		_currentIndex = value;

		Draw();
	}


	public function get watchObject():DisplayObject {
		return _watchObject;
	}

	public function set watchObject(value:DisplayObject):void {
		_watchObject = value;
		/*var i:uint = 0;
		var n:uint = tabs.length;
		for(i;i<n;i++){
			if(i!=_currentIndex)BaseTab(tabs[i].tabContainer).watchObject = _watchObject;
		}*/

		BaseTab(tabs[0].tabContainer.getChildAt(0)).watchObject = _watchObject;
	}
}
}
