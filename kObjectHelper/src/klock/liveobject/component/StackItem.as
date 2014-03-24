package klock.liveobject.component {

import flash.display.CapsStyle;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.JointStyle;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import klock.liveobject.component.ui.UI;
import klock.liveobject.utils.StringUtils;
import klock.simpleComponents.components.CheckBox;
import klock.simpleComponents.components.Label;
import klock.simpleComponents.components.base.BaseElement;
import klock.simpleComponents.components.base.BaseLayout;

public class StackItem extends BaseElement {

	private const QUAD_SIZE:uint = 12;


	public var _index			:int = -1;
	public var _data			:Object;
	public  var IS_open			:Boolean = true;

	private var _arrow			:Sprite;
	private var _label			:Label;
	private var _ckbox			:CheckBox;
	private var _cobox			:Sprite;
	public	var _color			:uint
	private	var _offset			:uint
	private var _mouseOver		:Boolean = false;
	private var _drawDebug		:Boolean = false;
	private var _maxCDE			:uint;


	public function StackItem(initObject:Object, parent:DisplayObjectContainer = null, color:uint = 0, data:Object=null, offset:uint = 0, maxCDE:uint = 8) {

		_color = color;
		_data = data
		_offset = offset;
		_maxCDE = maxCDE;

		super(initObject, parent);

	}
	override protected function AddChilds():void {


		var xpos :uint = 5

		addChild(_cobox = new Sprite())
		_cobox.x = xpos
		_cobox.y = 10
		_cobox.addEventListener(MouseEvent.CLICK, onItemEvent, false,0,true );

		drawColorBox();

		// checkbox for object visibility
		_ckbox = new CheckBox({x:xpos += QUAD_SIZE *.5},"", this , onUIChange )
		_ckbox.name ='cckbox'
		_ckbox.setSize( 20, 20)
		_ckbox.selected =  true;

		xpos+= 15  + _offset*5

		if(_data.obj is DisplayObjectContainer && DisplayObjectContainer(_data.obj ).numChildren>0 ){

			addChild(_arrow = new Sprite());
			_arrow.buttonMode = true;
			drawArrow()
			_arrow.x= xpos
			_arrow.addEventListener(MouseEvent.CLICK, onItemEvent, false,0,true );

		}
		xpos += 15

		_label = new Label( { x:xpos, y:0, textAlign:"left", _width:UI.STACKITEM_LABEL_WIDTH }, "", this );

		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);

		super.Draw()
		Draw()
		_label.Draw();
	}

	private function drawColorBox():void {
		var g:Graphics = _cobox.graphics;
		g.clear();
		if( _drawDebug ){
			g.lineStyle( 2, _color,1, false, "normal", CapsStyle.SQUARE, JointStyle.MITER)
			g.beginFill( _color, 0 )
		}else{
			g.beginFill( _color )
		}
		g.drawRect(0,-QUAD_SIZE *.5,QUAD_SIZE *.5,QUAD_SIZE)
		g.endFill();
	}

	private function drawArrow():void {
		var g:Graphics = _arrow.graphics;
		g.clear();
		g.clear()
		g.beginFill( 0,0 )
		g.drawRect(0,0,20,20)

		BaseLayout.DRAW_TRIANGLE(g,!IS_open ? 3 : 1, 20, 0x222222,1,0,0,false);
	}

	private function onUIChange(event:Event):void {

		dispatchEvent(new Event( "onUIChange", true ));
	}

	private function onItemEvent(event:MouseEvent):void {

		if( event.currentTarget == _arrow ){

			IS_open = !IS_open;
			drawArrow()
			dispatchEvent(new Event("LIST_CHANGE", true))

		}else if(  event.currentTarget == _cobox ){

			_drawDebug = !_drawDebug;
			drawColorBox()
		}
	}

	protected function onMouseOver(event:MouseEvent):void
	{
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		_mouseOver = true;
		Draw();
	}

	protected function onMouseOut(event:MouseEvent):void
	{
		removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		_mouseOver = false;
		Draw();
	}

	public override function Draw() : void
	{

		if( _label == null ) return
		super.Draw();
		graphics.clear();

		if(_selected){
			graphics.beginFill(BaseLayout.SELECTED_LIST,.7);
		}else if(_mouseOver){
			graphics.beginFill(BaseLayout.ROLL_LIST,.7);
		}else{
			graphics.beginFill(BaseLayout.NORMAL_LIST,.7);
		}
		graphics.drawRect(0, 0, __width, _height);
		graphics.endFill();

		if(_data == null) return;


		var label2Split:String = _data.label.toString();
		var splitArray:Array = label2Split.split(",");
		//	var contStr:String = StringUtils.cutStringValue(splitArray[0].toString());
		var nameStr:String = StringUtils.cutStringValue(splitArray[1].toString());
		var typeStr:String = StringUtils.cutStringValue(splitArray[2].toString());

		_label.text = nameStr + '\t' + typeStr;

	}
	public function set selected(value:Boolean):void
	{
		_selected = value;
		Draw();
	}
	/*public function get selected():Boolean
	{
		return _selected;
	}*/


	public function get ckbox():CheckBox {
		return _ckbox;
	}
}
}
