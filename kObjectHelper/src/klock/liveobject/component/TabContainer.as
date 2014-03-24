/**
 * Created by PMAN on 09.03.14.
 */
package klock.liveobject.component {
import avmplus.getQualifiedClassName;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName;

import klock.liveobject.component.ui.UI;
import klock.liveobject.config.Config;
import klock.liveobject.event.KObjectTabEvent;
import klock.simpleComponents.components.Button;
import klock.simpleComponents.components.ComboBox;
import klock.simpleComponents.components.Label;
import klock.simpleComponents.components.NumStep;

public class TabContainer extends Sprite {

	private var _visualTab          :TabPanel;
	private var _properTab          :TabPanel;
	private var _transfTab          :TabPanel;
	private var _boundsTab          :TabPanel;
	private var _childsTab          :TabPanel;
	private var _childListLength	:int = -1


	public function TabContainer(ccl:uint) {

		y = UI.ITEM_LINE_HEIGHT_HALF+2;
		addTabs(ccl)
		tabPosition();
	}

	//------------------------------------------------------------------------------------------------------------------ add tabs

	private function addTabs( cll:uint ):void {

		var tabCounter:uint = 0;
		_childListLength = cll;

		addChild(_childsTab = new TabPanel("Display Stack", tabCounter++))
		addChild(_properTab = new TabPanel("Properties", tabCounter++))
		addChild(_visualTab = new TabPanel("Visibility", tabCounter++))
		addChild(_transfTab = new TabPanel("Transform", tabCounter++))
		addChild(_boundsTab = new TabPanel("DisplayHelper",tabCounter))

		// add events
		_childsTab.addEventListener(KObjectTabEvent.TAB_CHANGE_EVENT, onTabChange)
		_properTab.addEventListener(KObjectTabEvent.TAB_CHANGE_EVENT, onTabChange)
		_visualTab.addEventListener(KObjectTabEvent.TAB_CHANGE_EVENT, onTabChange)
		_transfTab.addEventListener(KObjectTabEvent.TAB_CHANGE_EVENT, onTabChange)
		_boundsTab.addEventListener(KObjectTabEvent.TAB_CHANGE_EVENT, onTabChange)



		// size tab height to fit with the content
		_childsTab.panel.setSize(_childsTab.panel.width, UI.ITEM_LINE_HEIGHT*( _childListLength < UI.MAX_LIST_ITEMS ? _childListLength : UI.MAX_LIST_ITEMS) )
		_properTab.panel.setSize(_properTab.panel.width, UI.ITEM_LINE_HEIGHT*Config.PROPERTY_FILTER.length)
		_visualTab.panel.setSize(_visualTab.panel.width, UI.ITEM_LINE_HEIGHT*Config.VISUAL_PROPERTY_FILTER.length)
		_transfTab.panel.setSize(_transfTab.panel.width, UI.ITEM_LINE_HEIGHT*Config.TRANS_PROPERTY_FILTER.length)
		_boundsTab.panel.setSize(_boundsTab.panel.width, UI.ITEM_LINE_HEIGHT*Config.BOUNDS_PROPERTY_FILTER.length)

	}
	private function onTabChange(event:KObjectTabEvent):void {
		tabPosition();
	}

	//------------------------------------------------------------------------------------------------------------------ reposition

	public function tabPosition():void {

		var ch:Number = (_childsTab.isOpen? (UI.ITEM_LINE_HEIGHT*(_childListLength < UI.MAX_LIST_ITEMS ? _childListLength : UI.MAX_LIST_ITEMS)+23):0 +UI.TAB_HEIGHT);
		var ph:Number = (_properTab.isOpen? UI.ITEM_LINE_HEIGHT*Config.PROPERTY_FILTER.length:0 )+ UI.TAB_HEIGHT
		var vh:Number = (_visualTab.isOpen? UI.ITEM_LINE_HEIGHT*Config.VISUAL_PROPERTY_FILTER.length:0 )+ UI.TAB_HEIGHT
		var th:Number = (_transfTab.isOpen? UI.ITEM_LINE_HEIGHT*Config.TRANS_PROPERTY_FILTER.length :0 )+ UI.TAB_HEIGHT
		var bh:Number = (_boundsTab.isOpen? UI.ITEM_LINE_HEIGHT*Config.BOUNDS_PROPERTY_FILTER.length:0 )+ UI.TAB_HEIGHT

		_childsTab.y = 0
		_properTab.y = ch
		_visualTab.y = ch+ph
		_transfTab.y = ch+ph+vh
		_boundsTab.y = ch+ph+vh+th

	}

	//------------------------------------------------------------------------------------------------------------------ item update

	public function setListItemValues(filter:Vector.<String>, content:Sprite, watchObject:Object):void {

		for each( var objectProp:String in filter ){

			var objProp:* = content.getChildByName(objectProp);
			if ( objectProp == "blendMode") {

				ComboBox(objProp).selectedItem = watchObject.obj[objectProp];

			/*}else if ( (objectProp == "type" || objectProp == "name") && filter == Config.PROPS_PROPERTY_FILTER ) {

				if(objectProp == "type" )	Label(objProp).text = watchObject.obj.type;
				if(objectProp == "name" )	Label(objProp).text = watchObject.obj;
*/
			}else if( watchObject.obj[objectProp] is Number){

				NumStep(objProp).value = watchObject.obj[objectProp];

			}else if( watchObject.obj[objectProp] is String && Label(objProp) != null ){

				Label(objProp).text = watchObject.obj[objectProp];

			}else if( watchObject.obj[objectProp] is Boolean){

				Button(objProp).pushMode = watchObject.obj[objectProp];
				Button(objProp).label = (watchObject.obj[objectProp]).toString();


				if(objectProp=="showChildBounds"){
					Button(objProp).Enabled = (watchObject.obj is DisplayObjectContainer);
				}/*
				 else if( objectProp == "type"){
				 Label(_objectTab.content.getChildByName("label2type")).text = _childList[l.selectedIndex]
				 }*/

			}
		}
	}


	public function propersTabChange( watchObject:Object ):Vector.<String> {

		//clear content
		while( _properTab.content.numChildren > 1 ) _properTab.content.removeChildAt(0);
//trace( watchObject.obj.toString() , _properTab.content.numChildren, flash.utils.getQualifiedSuperclassName(watchObject.obj).toString(),flash.utils.getQualifiedSuperclassName(watchObject.obj).toString().indexOf('MovieClip')>-1)
		//check watch obj type and get current type list
		var list:Vector.<String> = new <String>[];
		if( watchObject.obj.toString() == "[object MovieClip]" || flash.utils.getQualifiedSuperclassName(watchObject.obj).toString().indexOf('MovieClip')>-1) list = Config.MC_PROPERTY_FILTER;
		if( watchObject.obj.toString() == "[object TextField]") list = Config.TXT_PROPERTY_FILTER;


		//add children

		//fill children

		return list;
	}



	public function get propsfTab():TabPanel {
		return _properTab;
	}

	public function get transfTab():TabPanel {
		return _transfTab;
	}

	public function get visualTab():TabPanel {
		return _visualTab;
	}

	public function get childsTab():TabPanel {
		return _childsTab;
	}

	public function get boundsTab():TabPanel {
		return _boundsTab;
	}
}
}
