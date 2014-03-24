/**
 * Created by PMAN on 23.03.14.
 */
package klock.liveobject.component {
import flash.display.DisplayObject;
import flash.events.Event;

import klock.liveobject.component.ui.UI;
import klock.liveobject.config.Config;
import klock.liveobject.event.KObjectTabEvent;
import klock.simpleComponents.components.Button;
import klock.simpleComponents.components.ComboBox;
import klock.simpleComponents.components.Label;
import klock.simpleComponents.components.NumStep;

public class VTab_A extends BaseTab {

	private var _positionTab:TabPanel;
	private var _rotationTab:TabPanel;
	private var _visibileTab:TabPanel;
	private var _scaleTab:TabPanel;



	public function VTab_A(_tabObject:TabObject, watchObject:DisplayObject ) {

		super(_tabObject,watchObject);

		// add standart property tabpanels
		addpositionTab();
		addRotationTab();
		addScaleTab();
		addVisibileTab();

		// add extra property tabpanels

		tabPosition();

	}
	//------------------------------------------------------------------------------------------------------------------

	private function addScaleTab():void {

		addChild(_scaleTab = new TabPanel("Scale",2,false));

		_scaleTab.addEventListener(KObjectTabEvent.TAB_CHANGE_EVENT, onTabSelect );

		var line:uint = 0;

		UI.addNumLine("scaleX",	watchObject.scaleX,   line, _scaleTab.content, .1, onTabContentChange )
		UI.addNumLine("scaleY",	watchObject.scaleY, ++line, _scaleTab.content, .1, onTabContentChange )
		UI.addNumLine("scaleZ",	watchObject.scaleZ, ++line, _scaleTab.content, .1, onTabContentChange )

	}

	private function updateScaleTab():void {

		var line:uint = 0;

		if( _scaleTab == null ) return;

		NumStep(_scaleTab.content.getChildByName("scaleX")).value = watchObject.scaleX;
		NumStep(_scaleTab.content.getChildByName("scaleY")).value = watchObject.scaleY;
		NumStep(_scaleTab.content.getChildByName("scaleZ")).value = watchObject.scaleZ;

	}


	//------------------------------------------------------------------------------------------------------------------

	private function addVisibileTab():void {

		addChild(_visibileTab = new TabPanel("Visibilty",3,false));

		_visibileTab.addEventListener(KObjectTabEvent.TAB_CHANGE_EVENT, onTabSelect );

		var line:uint = 0;

		UI.addNumLine("alpha",			watchObject.alpha, 		line, _visibileTab.content, .1, onTabContentChange )
		UI.addBtnLine("cacheAsBitmap",	watchObject.cacheAsBitmap, ++line, _visibileTab.content, onTabContentChange )
		UI.addBtnLine("visible",		watchObject.visible, 		++line,   _visibileTab.content, onTabContentChange )

		var _cobox:ComboBox = UI.addComboLine("blendMode", ++line, _visibileTab.content,Config.BLEND_MODE_LIST, onTabContentChange);
			_cobox.numVisibleItems = Config.BLEND_MODE_LIST.length
			_cobox.selectedItem = watchObject.blendMode;
	}

	private function updateVisibileTab():void {

		var line:uint = 0;

		if( _visibileTab == null ) return;

		NumStep(_visibileTab.content.getChildByName("alpha")).value = watchObject.alpha;

		Button(_visibileTab.content.getChildByName("cacheAsBitmap")).buttonMode = watchObject.cacheAsBitmap
		Button(_visibileTab.content.getChildByName("visible")).buttonMode = watchObject.visible

		var _cobox:ComboBox = ComboBox(_visibileTab.content.getChildByName("blendMode"));
		_cobox.selectedItem = watchObject.blendMode;
	}

	//------------------------------------------------------------------------------------------------------------------

	private function addRotationTab():void {
		addChild(_rotationTab = new TabPanel("Rotation",1,true));

		_rotationTab.addEventListener(KObjectTabEvent.TAB_CHANGE_EVENT, onTabSelect );

		var line:uint = 0;

		UI.addNumLine("rotationX",watchObject.rotationX, line,   _rotationTab.content, 1, onTabContentChange )
		UI.addNumLine("rotationY",watchObject.rotationY, ++line, _rotationTab.content, 1, onTabContentChange )
		UI.addNumLine("rotationZ",watchObject.rotationZ, ++line, _rotationTab.content, 1, onTabContentChange )

	}
	private function updateRotationTab():void {

		var line:uint = 0;

		if( _rotationTab == null ) return;

		NumStep(_rotationTab.content.getChildByName("rotationX")).value = watchObject.rotationX;
		NumStep(_rotationTab.content.getChildByName("rotationY")).value = watchObject.rotationY;
		NumStep(_rotationTab.content.getChildByName("rotationZ")).value = watchObject.rotationZ;

	}
	//------------------------------------------------------------------------------------------------------------------

	private function addpositionTab():void {

		addChild(_positionTab = new TabPanel("Position",0,true));
		_positionTab.addEventListener(KObjectTabEvent.TAB_CHANGE_EVENT, onTabSelect );
		var line:uint = 0;

		UI.addNumLine("x",watchObject.x, line, _positionTab.content, 1, onTabContentChange )
		UI.addNumLine("y",watchObject.y, ++line, _positionTab.content, 1, onTabContentChange )
		UI.addNumLine("z",watchObject.z, ++line, _positionTab.content, 1, onTabContentChange )

		UI.addNumLine("width",watchObject.width, ++line, _positionTab.content, 1, onTabContentChange )
		UI.addNumLine("height",watchObject.height, ++line, _positionTab.content, 1, onTabContentChange )

	}
	private function updatePositionTab():void {

		var line:uint = 0;

		if( _positionTab == null ) return;

		NumStep(_positionTab.content.getChildByName("x")).value = watchObject.x;
		NumStep(_positionTab.content.getChildByName("y")).value = watchObject.y;
		NumStep(_positionTab.content.getChildByName("z")).value = watchObject.z;

		NumStep(_positionTab.content.getChildByName("width")).value = watchObject.width;
		NumStep(_positionTab.content.getChildByName("height")).value = watchObject.height;

	}

	//------------------------------------------------------------------------------------------------------------------

	public function tabPosition():void {

		var ph:Number = (_positionTab.isOpen? 	UI.ITEM_LINE_HEIGHT*5:0 )+ UI.TAB_HEIGHT
		var rh:Number = (_rotationTab.isOpen?	UI.ITEM_LINE_HEIGHT*3:0 )+ UI.TAB_HEIGHT
		var sh:Number = (_scaleTab.isOpen? 		UI.ITEM_LINE_HEIGHT*3:0 )+ UI.TAB_HEIGHT
		var vh:Number = (_visibileTab.isOpen? 	UI.ITEM_LINE_HEIGHT*4:0 )+ UI.TAB_HEIGHT

		_positionTab.y = 0
		_rotationTab.y = ph
		_scaleTab.y = _rotationTab.y + rh
		_visibileTab.y =_scaleTab.y +sh

	}

	//------------------------------------------------------------------------------------------------------------------

	private function onTabSelect(event:KObjectTabEvent):void {
		tabPosition()
	}

	private function onTabContentChange(event:Event):void {

		var objectProp :* = event.currentTarget.name;
		if ( objectProp == "blendMode" && event.type == "select") {

		//	ComboBox(event.currentTarget).selectedItem = watchObject[objectProp];

			watchObject.blendMode = Config.BLEND_MODE_LIST[ComboBox(event.currentTarget).selectedIndex];

		}else if( watchObject[objectProp] is Number){

			watchObject[objectProp] =  NumStep(event.currentTarget).value;

		//	NumStep(event.currentTarget).value = watchObject[objectProp];

		}else if( watchObject[objectProp] is String && Label(event.currentTarget) != null ){

			watchObject[objectProp] = Label(event.currentTarget).text

		//	Label(event.currentTarget).text = watchObject[objectProp];

		}else if( watchObject[objectProp] is Boolean){

			watchObject[objectProp] =  !watchObject[objectProp];

			Button(event.currentTarget).pushMode = watchObject[objectProp];
			Button(event.currentTarget).label = (watchObject[objectProp]).toString();

		}

	}


	override public function set watchObject(value:DisplayObject):void {
		super.watchObject = value;

		updateVisibileTab();
		updateRotationTab();
		updatePositionTab();
		updateScaleTab();
	}

}
}
