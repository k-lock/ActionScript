package klock.liveobject.component {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextFormatAlign;

import klock.liveobject.component.ui.UI;
import klock.liveobject.event.KObjectTabEvent;
import klock.simpleComponents.components.Label;
import klock.simpleComponents.components.Panel;
import klock.simpleComponents.components.base.BaseLayout;

public class TabPanel extends Sprite {

    private var _isOpen:Boolean = false;
    private var _id:int = -1;
    private var _label:Label = null;
    private var _labelText:String = "";
    private var _content:Panel = null;
    private var _header:Sprite = null;

    //-------------------------------------------------------------------------------------------------------------- constructor

    public function TabPanel(label:String,index:int, open:Boolean=false) {

        _labelText = label;
        _isOpen = open;
        _id = index;

        setChange()
        initEventHandler(true)
    }

    //-------------------------------------------------------------------------------------------------------------- main update method

    private function setChange():void {

        drawHeader()
        drawLabel()
        drawContent();
    }

    //-------------------------------------------------------------------------------------------------------------- event handlers

    public function initEventHandler(state:Boolean):void {
        if( state){
            if(!_header.hasEventListener(MouseEvent.CLICK))_header.addEventListener(MouseEvent.CLICK, uiMouseEvent, false, 0, true )
        }else{
            _header.removeEventListener(MouseEvent.CLICK, uiMouseEvent )
        }
    }

    private function uiMouseEvent(event:MouseEvent):void {

        switch(event.type){
            case "click" :

                _isOpen = !_isOpen;
                setChange();
                dispatchEvent(new KObjectTabEvent(KObjectTabEvent.TAB_CHANGE_EVENT, _id ))

                break;
        }
    }

    //-------------------------------------------------------------------------------------------------------------- init/ enable content object

    private function drawContent():void {
        if( _content != null ){
            _content.visible = _isOpen;
        }else{
            addChild(_content = new Panel({}, this))
            _content.setSize( UI.ELEMENT_WIDTH, 200)
            _content.y = UI.ITEM_LINE_HEIGHT + UI.SPACE*.25
            _content.visible = _isOpen;
        }
    }

    //-------------------------------------------------------------------------------------------------------------- header label text

    private function drawLabel():void {

        if( _label != null ){
            _label.setColor(_isOpen ?0xffffff:0);
            _label.text = (_isOpen ?"-":"+")+ _labelText
        }else{
            addChild(_label = new Label({x:5,y:2},(_isOpen ?"-":"+")+ _labelText))
            _label.textAlign = TextFormatAlign.LEFT
            _label.setSize( UI.ELEMENT_WIDTH-UI.SPACE,  UI.ITEM_LINE_HEIGHT+UI.SPACE )
        }
    }

    //-------------------------------------------------------------------------------------------------------------- header graphics

    private function drawHeader():void {

        if(_header == null ){
            _header = new Sprite()
            addChild(_header)
        }
        var c:uint = _isOpen ? UI.TAB_HEADER_ACTIVE : BaseLayout.NORMAL_FILL;
        var g:Graphics = _header.graphics;
        g.clear()
        g.lineStyle(1, BaseLayout.NORMAL_LINE);
        g.beginFill(c)
        g.drawRect(0, 0,  UI.ELEMENT_WIDTH, UI.ITEM_LINE_HEIGHT);

    }

    //-------------------------------------------------------------------------------------------------------------- GET / SET / TER

    public function get isOpen():Boolean {
        return _isOpen;
    }
   /* public function set isOpen(value:Boolean):void {
        _isOpen = value;
        setChange()
    }
    public function get labelText():String {
        return _labelText;
    }
    public function set labelText(value:String):void {
        _labelText = value;
        setChange()
    }
    public function get contentHeight():uint {
        return _content.height;
    }*/
    public function get content():Sprite {
        return _content.content;
    }

  /*  public function set content(value:Sprite):void {
        _content.content = value;
    }*/

    public function get panel():Panel {
        return _content;
    }

    //-------------------------------------------------------------------------------------------------------------- returns tab index id

    public function get id():int {
        return _id;
    }
}
}
