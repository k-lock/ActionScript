/**
 * BASE UI ELEMENTS
 */
package klock.liveobject.component.ui {
import flash.display.DisplayObjectContainer;

import klock.simpleComponents.components.Button;
import klock.simpleComponents.components.ComboBox;
import klock.simpleComponents.components.InputText;
import klock.simpleComponents.components.Label;
import klock.simpleComponents.components.NumStep;
import klock.simpleComponents.components.base.BaseLayout;

public class UI {

	public function UI() { }

	//------------------------------------------------------------------------------------------------------------------
	//
	//                                                                                       STATIC UI LAYOUT CONST
	//
	//------------------------------------------------------------------------------------------------------------------

	public static const ELEMENT_WIDTH:uint = 245;
	public static const ITEM_LINE_HEIGHT:uint = 20;
	public static const ITEM_LINE_HEIGHT_HALF:uint = 10;
	public static const SPACE:uint = 10;

	public static const TAB_HEIGHT:Number = ITEM_LINE_HEIGHT*1.1;
	public static const STACKITEM_LABEL_WIDTH:Number = ELEMENT_WIDTH *.48;
	public static const LABEL_FIELD_WIDTH:Number = ELEMENT_WIDTH * .52;
	public static const VALUE_FIELD_WIDTH:Number = ELEMENT_WIDTH * .54 ;
	public static const MAX_LIST_ITEMS:uint = 8;

	public static const TAB_HEADER_ACTIVE:uint = 0x8A8887;

	//------------------------------------------------------------------------------------------------------------------
	//
	//                                                                                       STATIC UI ELEMENTS
	//
	//------------------------------------------------------------------------------------------------------------------

	//------------------------------------------------------------------------------------------------------------------    Add property text fields

	public static function addTextLine(label:String, value:String, yIndex:int, parent:DisplayObjectContainer):void {

		var label_1:Label;
		var inLabel_1:InputText;

		parent.addChild(label_1 = new Label({x: 2, y: ITEM_LINE_HEIGHT * yIndex}, label, parent))
		label_1.setSize(LABEL_FIELD_WIDTH, ITEM_LINE_HEIGHT)
		label_1.setBorder(true, BaseLayout.NORMAL_FILL)

		parent.addChild(inLabel_1 = new InputText({x: VALUE_FIELD_WIDTH, y: -2 + ITEM_LINE_HEIGHT * yIndex}, value, parent))
		inLabel_1.mouseEnabled = false;
		inLabel_1.mouseChildren = false;
	}

	//------------------------------------------------------------------------------------------------------------------    Add property numstep fields

	public static function addNumLine(label:String, value:Number, yIndex:int, parent:DisplayObjectContainer, step:Number = .1, funct:Function = null):NumStep {

		var _label:Label;
		var numStep:NumStep;

		parent.addChild(_label = new Label({x: 2, y: ITEM_LINE_HEIGHT * yIndex}, label, parent))
		_label.setSize(LABEL_FIELD_WIDTH, ITEM_LINE_HEIGHT)
		_label.setBorder(true, BaseLayout.NORMAL_FILL)

		parent.addChild(numStep = new NumStep({x: VALUE_FIELD_WIDTH, y: -2 + ITEM_LINE_HEIGHT * yIndex}, value, parent, funct))
		numStep.name = label;
		numStep.step = step;

		if (label == "alpha") {
			numStep.minimum = 0;
			numStep.maximum = 1;
		}
		if (label == "rotation") {
			numStep.minimum = -360;
			numStep.maximum = 360;
		}

		return numStep;
	}

	//------------------------------------------------------------------------------------------------------------------    Add property btn field

	public static function addBtnLine(label:String, value:Boolean, yIndex:int, parent:DisplayObjectContainer, funct:Function = null ):Button {

		var _label:Label;
		var _btn:Button;

		parent.addChild(_label = new Label({x: 2, y: ITEM_LINE_HEIGHT * yIndex}, label, parent))
		_label.setSize(LABEL_FIELD_WIDTH, ITEM_LINE_HEIGHT)
		_label.setBorder(true, BaseLayout.NORMAL_FILL)


		parent.addChild(_btn = new Button({x: VALUE_FIELD_WIDTH, y: -2 + ITEM_LINE_HEIGHT * yIndex}, value.toString(), parent, funct));
		_btn.name = label;
		_btn.pushMode = value;

		return _btn;
	}

	//------------------------------------------------------------------------------------------------------------------    Add property combobox field

	public static function addComboLine(label:String, yIndex:int, parent:DisplayObjectContainer, list:Array, funct:Function  ):ComboBox {

		var _label:Label;
		var _cobox:ComboBox;

		parent.addChild(_label = new Label({x: 2, y: ITEM_LINE_HEIGHT * yIndex}, label, parent))
		_label.setSize(LABEL_FIELD_WIDTH, ITEM_LINE_HEIGHT)
		_label.setBorder(true, BaseLayout.NORMAL_FILL)
		parent.addChild(_cobox = new ComboBox({x: VALUE_FIELD_WIDTH, y: -2 + ITEM_LINE_HEIGHT * yIndex}, "", parent, list, funct));
		_cobox.name = label;

		return _cobox;
	}

}
}
