package klock.liveobject.component {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;

public class BaseTab extends Sprite {

	protected var _watchObject	:DisplayObject = null;
	protected var _tabObject	:TabObject = null;

	public function BaseTab(_tabObject:TabObject,_watchObject:DisplayObject) {
		_tabObject = _tabObject;
		watchObject = _watchObject;

	}

	public function get watchObject():DisplayObject {
		return _watchObject;
	}

	public function set watchObject(value:DisplayObject):void {
		_watchObject = value;
		if( _tabObject== null )return
			_tabObject.watchObject = _watchObject;
		}
}
}
