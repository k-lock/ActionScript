package klock.simpleComponents.components
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import klock.simpleComponents.components.base.BaseElement;
	import klock.simpleComponents.components.base.BaseLayout;
	
	public class Panel extends BaseElement
	{
		protected var _mask			:Sprite;
		protected var _background	:Sprite;
		protected var _color		:int = -1;
		protected var _shadow		:Boolean = true;
		protected var _gridSize		:int = 10;
		protected var _showGrid		:Boolean = false;
		protected var _gridColor	:int = -1
		
		
		/** Container for content added to this panel. This is masked, so best to add children to content, rather than directly to the panel. */
		public var content:Sprite;
		
		/**
		 * Constructor 
		 * @param initObject		A Object contains all init properties.
		 * @param parent 	 		The parent DisplayObjectContainer on which to add this element.*/	
		public function Panel( initObject:Object, parent:DisplayObjectContainer = null )
		{
			super(initObject, parent);
		}

		/** Initializes the component.  */
		override protected function Init():void
		{
			super.Init();
			setSize(100, 100);
		}
		
		/** Creates and adds the child display objects of this component. */
		override protected function AddChilds():void
		{
			
			super.addChild( _background = new Sprite() );
			super.addChild( _mask 	    = new Sprite() );
			super.addChild( content 	= new Sprite() );
			
			content.x = content.y =_background.x = _background.y = BaseLayout.LEFT
			
			_mask.mouseEnabled = false;
			content.mask = _mask;
			
			_background.filters = [getShadow(2, true)];
		}

///////////////////////////////////
// public methods
///////////////////////////////////

		/** Overridden to add new child to content. */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			content.addChild(child);
			return child;
		}
		
		/** Access to super.addChild */
		public function addSuperChild( child:DisplayObject ):DisplayObject
		{
			super.addChild(child);
			return child;
		}
		
		/** Draws the visual ui of the component. */
		override public function Draw():void
		{
			super.Draw();
			
			BaseLayout.DRAW_FILLIN( _background.graphics, _width, _height, 2, _color )
			BaseLayout.DRAW_OUTLINE( this.graphics, _width, _height, 0 )
			
			drawGrid();
			
			var g:Graphics = _mask.graphics
				g.clear();
				g.beginFill(0xff0000);
				g.drawRect(0, 0, _width, _height);
				g.endFill();
		}
		/** Draw the grid element.*/
		protected function drawGrid():void
		{
			if(!_showGrid) return;
			
			var w:Number = _width - BaseLayout.LEFT*2
			var g:Graphics = _background.graphics
				g.lineStyle(0, ( _gridColor != -1 ) ? _gridColor : BaseLayout.PANELGRID );
			for(var i:int = _gridSize; i < _width; i += _gridSize){
				g.moveTo(i, 0);
				g.lineTo(i, _height-BaseLayout.LEFT*2);
			}
			for(i = _gridSize; i < _height; i += _gridSize) {
				g.moveTo( 0, i );
				g.lineTo( w, i);
			}
		}

///////////////////////////////////
// event handlers
///////////////////////////////////

///////////////////////////////////
// getter/setters
///////////////////////////////////

		/** Gets / sets whether or not this Panel will have an inner shadow. */
		public function set shadow( b:Boolean ):void
		{
			_shadow = b;
			filters = ( _shadow ) ? [getShadow(2, true)] : [];
	
		}
		public function get shadow():Boolean
		{
			return _shadow;
		}
		
		/** Gets / sets the backgrond color of this panel.  */
		public function set color(c:int):void
		{
			_color = c;
			Draw();
		}
		public function get color():int
		{
			return _color;
		}
		
		/** Sets / gets the size of the grid. */
		public function set gridSize(value:int):void
		{
			_gridSize = value;
			Draw();
		}
		public function get gridSize():int
		{
			return _gridSize;
		}
		
		/** Sets / gets whether or not the grid will be shown. */
		public function set showGrid(value:Boolean):void
		{
			_showGrid = value;
			Draw();
		}
		public function get showGrid():Boolean
		{
			return _showGrid;
		}
		
		/** Sets / gets the color of the grid lines. */
		public function set gridColor(value:uint):void
		{
			_gridColor = value;
			Draw();
		}
		public function get gridColor():uint
		{
			return _gridColor;
		}
	
	
	}
}