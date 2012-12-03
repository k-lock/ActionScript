/**Copyright (c) 2011 Paul Knab - Version 0.0.2*/
package klock.simpleComponents.components.base
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	/** Base class with the basic properties of all components    */
	[ Event( name="resize", type="flash.events.Event" ) ]
	[ Event( name="draw",   type="flash.events.Event" ) ]
	public class BaseElement extends Sprite
	{
		
		protected var _width	:Number = 100;
		protected var _height	:Number = 20;
		protected var _enabled	:Boolean = true;
		protected var _toggled	:Boolean = false;
		protected var _selected	:Boolean = false;
	
		/**
		 * Constructor 
		 * @param initObject A Object contains all init properties  */
		public function BaseElement( initObject:Object, parent:DisplayObjectContainer = null )
		{//trace( "BASE-CONSTRUCTOR")
			if( parent     != null ) parent.addChild( this )
			if( initObject != null ) SetupObjects( initObject, this )

			Init()
		}
		/** Initilizes the component. */
		protected function Init():void
		{//trace( "BASE-INIT")
			AddChilds()
			
			Draw  () 
			Events( true )
			
		}
		
		/**
		 * Create child display objects. */
		protected function AddChilds():void
		{//trace( "BASE-AddChilds")
			//addChild(  tf = new TXT( label , {x:0,  y:0, width:WIDTH, height: HEIGHT }, MenuHelper.TXT_FORMAT_10, "none"))	
			//tf.TXT_FormatAlignTyp( "CENTER" )
		}
		
		/**
		 * Setup Event Handler.
		 * @param mode Set MouseEvent enabled true or false */
		protected function Events( mode:Boolean ) : void
		{
	/*		if( mode && Enabled ){	
				//	addEventListener( 	MouseEvent.CLICK, 	   Listener, false, 0, true );
				//	addEventListener( 	MouseEvent.MOUSE_OUT,  Listener, false, 0, true );
				addEventListener( 	MouseEvent.MOUSE_OVER, Listener, false, 0, true );
			}else{
				//	removeEventListener( MouseEvent.CLICK, 	   	Listener );
				//	removeEventListener( MouseEvent.MOUSE_OUT,  Listener );
				//if( hasEventListener( MouseEvent.MOUSE_OVER ))
				removeEventListener( MouseEvent.MOUSE_OVER, Listener );
			}*/
		}
		
		/**
		 * MouseEvent Handler
		 * @param event The MouseEvent passed by the system. */
		protected function Listener( event:Event ):void
		{
	/*		if( event.type == "mouseOut"){
				
				stage.removeEventListener ( 	MouseEvent.MOUSE_UP,   Listener );
				stage.removeEventListener ( 	MouseEvent.MOUSE_DOWN, Listener );
				removeEventListener ( 	MouseEvent.MOUSE_OUT,  Listener );
				addEventListener	( 	MouseEvent.MOUSE_OVER, Listener, false, 0, true );
				
				if( !_selected )Draw( 0 )
			}
			if( event.type == "mouseOver" || event.type == "mouseUp"){
				
				stage.addEventListener   ( 	MouseEvent.MOUSE_UP,   Listener, false, 0, true );
				stage.addEventListener   ( 	MouseEvent.MOUSE_DOWN, Listener, false, 0, true );
				addEventListener   ( 	MouseEvent.MOUSE_OUT,  Listener, false, 0, true );
				removeEventListener( 	MouseEvent.MOUSE_OVER, Listener );
				
				if( !_selected )Draw( 1 )
			}
			if( event.type == "mouseDown"){
				
				if( Toggled )
				{
					_selected = ( _selected )? false: true
					Draw(   ( _selected )? 2 : 1 )
					return
				}else{
					Draw( 2 )
				}
			}
			*/
		}
		
		/** Draws the visual ui of the component.*/
		public function Draw():void
		{
			dispatchEvent(new Event("Draw"));
		//	BaseLayout.DRAW_FILLIN (  this.graphics, _width, _height )
		}
		
		/**
		 * DropShadowFilter factory method, used in many of the components.
		 * @param dist The distance of the shadow.
		 * @param knockout Whether or not to create a knocked out shadow.
		 */
		protected function getShadow( dist:Number, knockout:Boolean = false ):DropShadowFilter // , blurX:uint = dist, blurY:uint = dist, stre:Number=.12
		{
			return new DropShadowFilter( dist, 45, BaseLayout.DROPSHADOW, 1, dist, dist, .12, 1, knockout );
		}
		
		// PUBLIC METHODS
		
		/**
		 * Moves the component to the specified position.
		 * @param xpos the x position to move the component
		 * @param ypos the y position to move the component */
		public function setPosition( xpos:Number, ypos:Number ):void
		{
			x = Math.round(xpos);
			y = Math.round(ypos);
		}
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component. */	
		public function setSize( width:Number, height:Number ):void
		{
			_width = width;
			_height = height;
			//	dispatchEvent(new Event(Event.RESIZE));
			
			Draw()
		}
		
		/** Sets or gets whether this component is enabled or not. */
		public function get Enabled()			:Boolean	 	{ return  _enabled; } 
		public function set Enabled( value		:Boolean ):void	
		{ 
			_enabled = value;  
			mouseEnabled = mouseChildren = _enabled;
			
			alpha = ( _enabled ) ? 1.0 : 0.5;
		//	Events( ( value ) ? true : false); 
			
		} 
		/** Sets or gets whether this component is toggleable or not. */
		public function get Toggled()		:Boolean		{ return  _toggled; } 
		public function set Toggled( value	:Boolean ):void { _toggled = value; }
		
		/**
		 * Helper function to assign properties to an object
		 * @param objectA transporter object with properties
		 * @param objectB target object where assign properties to */
		protected static function SetupObjects( objectA:Object, objectB:Object ):void{ for(var n:String in objectA)if (n in objectA) objectB[n] = objectA[n]; }

	}
}