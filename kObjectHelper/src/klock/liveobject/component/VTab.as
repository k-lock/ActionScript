package klock.liveobject.component {
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import klock.simpleComponents.components.Label;
import klock.simpleComponents.components.Panel;
import klock.simpleComponents.components.base.BaseElement;
import klock.simpleComponents.components.base.BaseLayout;

public class VTab extends BaseElement {

	private const TAB_WIDTH:uint = 250;
	public static const TAB_HEIGHT:uint = 400;
	private const TAB_HEAD_WIDTH:uint = 110;
	private const TAB_HEAD_HEIGHT:uint = 15;

	private var __index:uint = 0;
	private var __label:String = "TabName";

	private var tabHead:Sprite;
	private var tabLabel:Label;
	private var tabPanel:Sprite;
	private var _tabContainer:Panel;


	public function VTab(initObject:Object, parent:DisplayObjectContainer = null) {

		super(initObject, parent);

		if( parent     != null ) parent.addChild( this );
		if( initObject != null ) SetupObjects( initObject, this )

	}

	override protected function AddChilds():void {
		super.AddChilds();

		addChild( tabPanel = new Sprite());
		BaseLayout.DRAW_FILLIN(tabPanel.graphics,TAB_WIDTH,TAB_HEIGHT )
		tabPanel.y = TAB_HEAD_HEIGHT-1

		addChild( tabHead= new Sprite());
		BaseLayout.DRAW_FILLIN(tabHead.graphics,TAB_HEAD_WIDTH,TAB_HEAD_HEIGHT )

		tabLabel = new Label({x:5},__label, tabHead )
		tabLabel.mouseEnabled = false;
		tabLabel.mouseChildren = false;

		_tabContainer = new Panel({x:2.5,y:2.5}, tabPanel);
		_tabContainer.setSize(TAB_WIDTH-5,TAB_HEIGHT-5);

		setSize(TAB_WIDTH,TAB_HEIGHT);
	}

	override public function Draw():void {
		super.Draw();
		if( tabLabel == null ||tabHead == null ) return;
		if(!_selected ){
			tabLabel.setColor(0x888888 )
			BaseLayout.DRAW_FILLIN(tabHead.graphics,TAB_HEAD_WIDTH,TAB_HEAD_HEIGHT,1 )
		}else{
			tabLabel.setColor(0x222222 )
			BaseLayout.DRAW_FILLIN(tabHead.graphics,TAB_HEAD_WIDTH,TAB_HEAD_HEIGHT,0 )
		}

		setTabContentVisible();
		setTabHeadPosition();
	}

	override protected function Events(mode:Boolean):void {
		super.Events(mode);

		if( mode  ){
			tabHead.addEventListener( 	MouseEvent.CLICK, 	   Listener, false, 0, true );
			tabHead.addEventListener( 	MouseEvent.MOUSE_DOWN, Listener, false, 0, true );
		}else{
			tabHead.removeEventListener( MouseEvent.CLICK, 	   	Listener );
			tabHead.removeEventListener( MouseEvent.MOUSE_MOVE, Listener)
			tabHead.removeEventListener( MouseEvent.MOUSE_UP, 	Listener)
			tabHead.removeEventListener( MouseEvent.MOUSE_OUT, 	Listener)
			tabHead.removeEventListener( MouseEvent.MOUSE_DOWN,	Listener );
		}
	}
	var _dragStartPosition:Point;
	override protected function Listener(event:Event):void {

		if( event.type == "click"){

			dispatchEvent(new Event("TabChange", true))

		}else if(event.type ==  "mouseDown"){

			if( _selected ){

				_dragStartPosition = new Point(MouseEvent(event).stageX - this.parent.x, MouseEvent(event).stageY - this.parent.y)
				tabHead.addEventListener( MouseEvent.MOUSE_MOVE, Listener, false, 0, true );
				tabHead.addEventListener( MouseEvent.MOUSE_UP, Listener, false, 0, true );
				tabHead.addEventListener( MouseEvent.MOUSE_OUT, Listener, false, 0, true );
			}
		}else if(event.type ==  "mouseUp" || event.type ==  "mouseOut"){

			tabHead.removeEventListener(MouseEvent.MOUSE_UP, Listener)
			tabHead.removeEventListener(MouseEvent.MOUSE_MOVE, Listener)

			_dragStartPosition = new Point()

		}else if(event.type ==  "mouseMove"){

			this.parent.x = MouseEvent(event).stageX - _dragStartPosition.x;
			this.parent.y = MouseEvent(event).stageY - _dragStartPosition.y;
		}
	}

	private function setTabContentVisible():void {
		tabPanel.visible = _selected;
	}

	private function setTabHeadPosition():void {
		tabHead.x = TAB_HEAD_WIDTH * __index;
	}

	public function set _label(value:String):void {
		__label = value;
	}

	public function get selected():Boolean {
		return _selected;
	}

	public function set selected(value:Boolean):void {
		_selected = value;
		Draw();
	}

	public function get index():uint {
		return __index;
	}

	public function set index(value:uint):void {
		__index = value;
	}

	public function get tabContainer():Sprite {
		return _tabContainer.content;
	}

	public function set tabContainer(value:Sprite):void {
		_tabContainer.content = value;
	}
}
}
