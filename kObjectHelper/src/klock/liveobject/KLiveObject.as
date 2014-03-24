/**
 * Created by PMAN on 23.02.14.
 */
package klock.liveobject {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;

import klock.liveobject.component.StackItem;
import klock.liveobject.component.StackList;
import klock.liveobject.component.TabContainer;
import klock.liveobject.component.TabDragItem;
import klock.liveobject.component.ui.UI;
import klock.liveobject.config.Config;
import klock.liveobject.utils.GlobalStage;
import klock.liveobject.utils.ListUtils;
import klock.liveobject.utils.ListUtils;
import klock.liveobject.utils.StringUtils;
import klock.simpleComponents.components.Button;
import klock.simpleComponents.components.CheckBox;
import klock.simpleComponents.components.ComboBox;
import klock.simpleComponents.components.ListItem;
import klock.simpleComponents.components.NumStep;

public class KLiveObject extends Sprite{

	//------------------------------------------------------------------------------------------------------------------

	private var _watchObject        :Object;
	private var _tempWatchObject    :Object;
	public static var _stage        :Stage;
	private var _watchIsContainer   :Boolean = false;
	private var _drawDebugShape   	:Boolean = false;

	//------------------------------------------------------------------------------------------------------------------    UI DISPLAY OBJECTz


	private var _dragHeader         :TabDragItem;
	private var _tabContainer       :TabContainer;

	private var _stackList			:StackList
	//------------------------------------------------------------------------------------------------------------------    LIST HOLDER OBJECTS

	private var _childList          :Array = [];

	//------------------------------------------------------------------------------------------------------------------    VARIOUS VARz

//------------------------------------------------------------------------------------------------------------------
	/** static constructor caller */
	public static function startSession( watchObj:DisplayObject, stage_:Stage  ):void {

		_stage = stage_;
		_stage.addChildAt( new KLiveObject(watchObj), _stage.numChildren )
	}

	/** constructor   */
	public function KLiveObject(watchObj:DisplayObject) {

		if (_stage == null ) _stage = watchObj.stage;
		_watchObject = _tempWatchObject = {label:"",obj: watchObj, par: watchObj.parent, arr:(watchObj is DisplayObjectContainer && DisplayObjectContainer(watchObj).numChildren>0)?1:3,index: 0, open:true , cde: 0}
		_watchIsContainer = ( _watchObject.obj is DisplayObjectContainer  && DisplayObjectContainer(watchObj).numChildren>0);

		addEventListener( Event.ADDED_TO_STAGE, onStageAdded )

		//this.scaleX = this.scaleY = 2
		this.x = 200
	}

	private function onStageAdded(event:Event):void {

		removeEventListener( Event.ADDED_TO_STAGE, onStageAdded )
		initObjects()
	}
//------------------------------------------------------------------------------------------------------------------- 	INIT STACK CHILD LIST OBJECT

	private function initObjects():void {

		_childList = []

		createChildList();
		initElements()
	}

	private function createChildList():void {

		var i:int=0;

		ListUtils.objectz = [];

		if (_watchIsContainer ){

			ListUtils.traceDisplayList(_watchObject.obj)

		}else{
			ListUtils.objectz.push({ obj:_watchObject.obj, par:_watchObject.parent, cde:0})
		}

		for each( var d:Object in ListUtils.objectz )
		{
			_childList.push( addChildObject( d , i) );
			i++;
		}
		ListUtils.objectz = [];
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

	//-------------------------------------------------------------------------------------------------------------------    INIT UI ELEMENTS

	private function initElements():void {

		addDragTabItem();
		addTabContainer()

	}

	//-------------------------------------------------------------------------------------------------------------------    UI DRAG HEADER DISPLAY OBJECT

	private function addDragTabItem():void {

		addChild(_dragHeader = new TabDragItem(_stage));

	}

	//-------------------------------------------------------------------------------------------------------------------    TAB CONTAINER
	private function addTabContainer():void {

		addChild( _tabContainer = new TabContainer(_childList.length));
		fillTabContainers()

	}


	private function fillTabContainers():void {

		lookObject(Config.PROPS_PROPERTY_FILTER,  _tabContainer.propsfTab.content, _watchObject, onUIChange);
		lookObject(Config.VISUAL_PROPERTY_FILTER, _tabContainer.visualTab.content, _watchObject, onUIChange);
		lookObject(Config.TRANS_PROPERTY_FILTER,  _tabContainer.transfTab.content, _watchObject, onUIChange);
		lookObject(Config.BOUNDS_PROPERTY_FILTER, _tabContainer.boundsTab.content, _watchObject, onUIChange);

//		trace(_tabContainer.propsfTab.content.getChildAt(1).name)

		_tabContainer.transfTab.content.y +=2
		_tabContainer.boundsTab.content.y +=2

		childStackInit();
	}

	private function childStackInit():void {

		var c:Sprite = _tabContainer.childsTab.content;
		_stackList = new StackList(c, _childList)
		_stackList.addEventListener(MouseEvent.CLICK, onWatchObjectChange );
		_stackList.selectedIndex = 0

	}


	//------------------------------------------------------------------------------------------------------------------    Check object props

	private static function lookObject( filter:Vector.<String>, holder:DisplayObjectContainer, watchObj:Object, eventHandler:Function ):void {

		var addList:Array = ListUtils.swapVectorByValue(filter, watchObj.obj as DisplayObject)
		var i:uint = 0,line:uint = 0,n:uint = addList.length;
		for (i; i < n; i++) {

			/* if (addList[i].key == "showBounds"){

			 } else if (addList[i].key == "showPivot"){

			 } else */
			if (addList[i].key == "blendMode") {
				var _cobox:ComboBox = UI.addComboLine("blendMode", line++, holder,Config.BLEND_MODE_LIST, eventHandler);
				_cobox.numVisibleItems = Config.BLEND_MODE_LIST.length
				_cobox.selectedItem = watchObj.obj.blendMode;
			} if (addList[i].key == "type") {
				var _cobox:ComboBox = UI.addComboLine("type", line++, holder,Config.TXT_TYPE_LIST, eventHandler);
				_cobox.numVisibleItems = Config.TXT_TYPE_LIST.length
				_cobox.selectedItem = TextField(watchObj.obj).type;
			} else if (addList[i].value is Number) {
				var step:Number = 1;
				switch (addList[i].key + "") {
					case "alpha":
					case "rotationX":
					case "rotationY":
					case "rotationZ":
					case "scaleX":
					case "scaleY":
					case "scaleZ":
						step = .1;
						break;
					default :
						step = 1;
						break;
				}
				UI.addNumLine(addList[i].key, addList[i].value, line++, holder, step, eventHandler);
			}else if (addList[i].value is String) {
				UI.addTextLine(addList[i].key, addList[i].value + "", line++, holder);
			} else if (addList[i].value is Boolean) {
				var btn:Button = UI.addBtnLine(addList[i].key, addList[i].value as Boolean, line++, holder, eventHandler);
				if(addList[i].key=="showChildBounds"){
					btn.Enabled = (watchObj.obj is DisplayObjectContainer);
				}
			}
		}
	}

	//-------------------------------------------------------------------------------------------------------------------   Stack Item Select

	private function onWatchObjectChange(event:Event):void {

		var l:StackList =( event.currentTarget is CheckBox )? event.currentTarget.parent as StackList: StackList(event.currentTarget);
		if( l!= null ){

			if(l.selectedIndex == -1 ) l.selectedIndex = 0

			_watchObject = _childList[l.selectedIndex]
			_watchIsContainer = (_watchObject.obj is DisplayObjectContainer)

		/*	if( _watchObject is MovieClip){
				trace( MovieClip(_watchObject).isPlaying )
			}*/

			Config.PROPERTY_FILTER = _tabContainer.propersTabChange(_watchObject);
			lookObject(Config.PROPERTY_FILTER,  _tabContainer.propsfTab.content, _watchObject, onUIChange);
			_tabContainer.propsfTab.panel.setSize( _tabContainer.propsfTab.panel.width, UI.ITEM_LINE_HEIGHT*Config.PROPERTY_FILTER.length)
			_tabContainer.tabPosition()
			trace("---> ", Config.PROPERTY_FILTER.length )

			//_tabContainer.setListItemValues(Config.PROPS_PROPERTY_FILTER,  _tabContainer.propsfTab.content, _watchObject )
			//_tabContainer.setListItemValues(Config.TRANS_PROPERTY_FILTER,  _tabContainer.transfTab.content, _watchObject )
			//_tabContainer.setListItemValues(Config.VISUAL_PROPERTY_FILTER, _tabContainer.visualTab.content, _watchObject )





		}
	}


	//-------------------------------------------------------------------------------------------------------------------    UI Event HANDLERS

	private function onUIChange(event:Event):void {

		if (event.currentTarget is NumStep) {
			var stepper:NumStep = NumStep(event.currentTarget);
			if ( _watchObject.obj.hasOwnProperty(stepper.name) && _watchObject.obj[ stepper.name ] != null) {
				if(stepper.name == "currentFrame" ){

					MovieClip(_watchObject.obj).gotoAndPlay( stepper.value )

					trace(MovieClip(_watchObject.obj).currentFrame , MovieClip(_watchObject.obj).framesLoaded, _watchObject.obj is MovieClip)


				}else _watchObject.obj[ stepper.name ] = stepper.value
			}
		} else if (event.currentTarget is Button) {
			var btn:Button = Button(event.currentTarget);
			{
				btn.pushMode = !btn.pushMode
				btn.label = btn.pushMode.toString();

				if ( _watchObject.obj.hasOwnProperty(btn.name) && _watchObject.obj[ btn.name] != null) {
					_watchObject.obj[ btn.name ] = btn.pushMode

					if( btn.name == "visible" ){
						var element:StackItem  = _stackList.listContainer.content.getChildAt (_watchObject.index) as StackItem
						CheckBox(element.ckbox).selected = btn.pushMode;
					}
				}else if( btn.name == "showBounds" ){
					drawBoundsHelper(btn.pushMode)
				}
			}
		} else if (event.currentTarget is ComboBox) {
			var cobox:ComboBox = ComboBox(event.currentTarget);
			if (cobox.name == "blendMode") {
				_watchObject.obj.blendMode = Config.BLEND_MODE_LIST[cobox.selectedIndex];
			}
		}else if( event.currentTarget is CheckBox ){

			if(event.currentTarget.parent is ListItem){
				var cckbox:CheckBox = event.currentTarget as CheckBox;
				var item :StackItem = event.currentTarget.parent as StackItem;
				var itemIndex:uint = item._index

				DisplayObject(_childList[itemIndex].obj).visible = cckbox.selected;
			}
		}

		if(_stackList != null) updateDrawHelper( _drawDebugShape )
	}

	//-------------------------------------------------------------------------------------------------------------------    DRAW DEBUG HELPER

	private var _debugLayer:Sprite= new Sprite() ;
	private function drawBoundsHelper(state:Boolean):void {

		if( _stage == null )return;
		if( !_stage.contains( _debugLayer ) ){
			_stage.addChildAt(_debugLayer  , _stage.numChildren-1);
		}

		if( state ){

			_debugLayer.graphics.clear();

			updateDrawHelper( state )

		}else{

			_debugLayer.graphics.clear();

		}
		_drawDebugShape = state;

		/*	while( _debugLayer.numChildren>0){
			_debugLayer.removeChildAt(0)
		}
		for each( var child:Object in _childList ){
			_debugLayer.addChild(  new Shape() );
		}*/

	}
	private function updateDrawHelper( state:Boolean ):void{

		var debugShape:Shape;
		var offset:uint = 2;
		var wRect:Rectangle;
		var color:uint;
		var g:Graphics;
		var i:uint = 0;

		//debugShape =  _debugLayer//.getChildAt(i) as Shape
		wRect = _watchObject.obj.getRect(_watchObject.obj.stage);
		color = _stackList._debugColors[_watchObject.index]
		g = _debugLayer.graphics
		g.clear();

		if( state )  {
			g.lineStyle( 1, color)
			g.beginFill(color,.2)
			g.drawRect(wRect.x-offset,wRect.y-offset,wRect.width+offset*2,wRect.height+offset*2)
			g.endFill();

		}
/*
		if(_debugLayer == null )drawBoundsHelper(true)
		for each( var child:Shape in _debugLayer ){
			trace( "clear graph ", child)
			child.graphics.clear();
		}
	//	for each( var child:Object in _childList ){

	//		debugShape =  _debugLayer.getChildAt(i) as Shape
			debugShape =  _debugLayer.getChildAt(_watchObject.index) as Shape

			wRect = _watchObject.obj.getRect(_watchObject.obj.stage);
			color = _stackList._debugColors[_watchObject.index]
			g = debugShape.graphics
			g.clear();

			if( state )  {
				g.lineStyle( 1, color)
				g.beginFill(color,.2)
				g.drawRect(wRect.x-offset,wRect.y-offset,wRect.width+offset*2,wRect.height+offset*2)
				g.endFill();

			}
	//		i++
	//	}
*/
	}


}
}
