package klock.simpleComponents.components
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import klock.simpleComponents.components.base.BaseElement;
	import klock.simpleComponents.components.base.BaseLayout;
	
	public class Quester extends BaseElement
	{
		protected var _panel 		:Panel
		protected var _label 	 	:Label
		protected var _labelText 	:String
		protected var _inputText 	:String
		protected var _btnText 	:String
		protected var _input 		:InputText
		protected var _button		:Button 
		protected var _defaultListener:Function = null
		
		
		public function Quester( initObject:Object, parent:DisplayObjectContainer=null, labelText:String = "?", answer:String = "", btnText:String = "", defaultListener:Function = null )
		{
			_labelText = labelText
			_inputText = answer
			_btnText = btnText
			super( initObject, parent );
			
			if( defaultListener != null ) _defaultListener = defaultListener;
			addEventListener( Event.ADDED_TO_STAGE ,AddToStage )
			
			Init()
		}
		/** Initilizes the component. */
		override protected function Init():void
		{			
			super.Init();	
			setSize( 300, 150 )
		}
		
		/**
		 * Create child display objects. */
		override protected function AddChilds():void
		{
			_panel	= new Panel(	{}, this )
			_label	= new Label(	{ x:  10, y: 10, _width: _width-20}, _labelText, this )
			_input	= new InputText({ x:  10, y: 50, _width: _width-20}, _inputText, this )
			_button	= new Button( 	{ x: 100, y: 100 }, 				 _btnText,   this, _defaultListener )
				
			_panel.setSize( _width, _height) 
				
		}
		
		public function get InputTextValue():String 
		{
			return _input.text;
		}
		
		public function disposeElement():void
		{
			if( _defaultListener != null ) _button.removeEventListener( MouseEvent.CLICK, _defaultListener )

			while( numChildren > 0 ) removeChildAt(0)
				
			_panel	= null
			_label	= null
			_input	= null
			_button	= null
			_labelText = ""
			_defaultListener = null
			
		}
		
	}
}