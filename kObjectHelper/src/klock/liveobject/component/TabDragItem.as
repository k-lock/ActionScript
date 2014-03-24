
package klock.liveobject.component {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextFormatAlign;

import klock.liveobject.component.ui.UI;
import klock.simpleComponents.components.Label;
import klock.simpleComponents.components.base.BaseLayout;

public class TabDragItem extends Sprite {

	//private const DRAG_IN_STAGE		:Boolean = false;

	private var _stage				:Stage;
	private var _dragStartPosition  :Point;

	public function TabDragItem(stage_:Stage) {
		_stage=stage_;
		Draw(false)
		_stage.addEventListener(MouseEvent.MOUSE_DOWN, onDragHeader)
	}
	private function Draw(dragin:Boolean, headerHeight:uint = 10):void {

		var c:uint = dragin ? UI.TAB_HEADER_ACTIVE : BaseLayout.NORMAL_FILL;
		var g:Graphics = this.graphics;
		g.clear()
		g.lineStyle(1, BaseLayout.NORMAL_LINE);
		g.beginFill(c)
		g.drawRect(0, 0, UI.ELEMENT_WIDTH, headerHeight);

		c = dragin ? 0xffffff : 0
		var labelStr :String = (dragin ? "-" : "+");
		var label:Label;
		if (this.numChildren > 0) {
			label = this.getChildAt(0) as Label;
			label.setColor(c);
			label.text = labelStr
		} else {
			this.addChild(label = new Label({x: 5, y: -3}, labelStr))
			label.textAlign = TextFormatAlign.LEFT
		}
	}

	//------------------------------------------------------------------------------------------------------------------    UI HEADER DRAG EVENTS

	public function onDragHeader(event:MouseEvent):void {

		switch(event.type){
			case "mouseMove":
				this.parent.x = event.stageX - _dragStartPosition.x;
				this.parent.y = event.stageY - _dragStartPosition.y;

				/*if( DRAG_IN_STAGE ){
					repositionDrag()
				}*/
				break;
			case "mouseUp":
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onDragHeader)
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragHeader)
				_stage.addEventListener(MouseEvent.MOUSE_DOWN, onDragHeader)
				_dragStartPosition = new Point()
				Draw(false)
				break;
			case "mouseDown":
				_dragStartPosition = new Point(event.stageX - this.parent.x, event.stageY - this.parent.y)
				if (_dragStartPosition.y < UI.ITEM_LINE_HEIGHT_HALF) {
					_stage.addEventListener(MouseEvent.MOUSE_MOVE, onDragHeader)
					_stage.addEventListener(MouseEvent.MOUSE_UP, onDragHeader)
					Draw(true);
				}
				break;
		}
	}



	/*private function repositionDrag():void {

	 if( x < 0 ) x = 0
	 if( x+this.width > _stage.stageWidth ) x = _stage.stageWidth-UI.ELEMENT_WIDTH;

	 if( y < 0 ) y = 0
	 if( y > _stage.stageHeight ) y = _stage.stageHeight-UI.ELEMENT_WIDTH;

	 }*/

}
}
