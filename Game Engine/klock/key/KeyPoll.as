package klock.key
{
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	
	/**
	 * <p>Games often need to get the current state of various keys in order to respond to user input. 
	 * This is not the same as responding to key down and key up events, but is rather a case of discovering 
	 * if a particular key is currently pressed.</p>
	 * 
	 * <p>In Actionscript 2 this was a simple matter of calling Key.isDown() with the appropriate key code. 
	 * But in Actionscript 3 Key.isDown no longer exists and the only intrinsic way to react to the keyboard 
	 * is via the keyUp and keyDown events.</p>
	 * 
	 * <p>The KeyPoll class rectifies this. It has isDown and isUp methods, each taking a key code as a 
	 * parameter and returning a Boolean.</p>
	 *<br><br>
	 *<br>package
	 *<br>	{
	 *<br>	import flash.display.Sprite;
	 *<br>	import flash.events.Event;
	 *<br>	import flash.ui.Keyboard;
	 *<br>	import KeyPoll;
	 *<br><br>
     *<br>	public class Test extends Sprite {
	 *<br>	var key:KeyPoll;
	 *<br><br>
	 *<br>	public function Test() {
	 *<br>	  key = new KeyPoll( this.stage );
	 *<br>	  addEventListener( Event.ENTER_FRAME, enterFrame );
	 *<br>	}
	 *<br><br>
	 *<br>	public function enterFrame( ev:Event ):void {
	 *<br>	  if( key.isDown( Keyboard.LEFT ) ) {
	 *<br>		trace( "left down" );
	 *<br>	  }
	 *<br>	  if( key.isDown( Keyboard.RIGHT ) ) {
	 *<br>		trace( "right down" );
	 *<br>	  }
	 *<br>	}
	 *<br>	}
	 *<br>	}
	 *
	 */
	public class KeyPoll {
		
		private var states:ByteArray;
		private var dispObj:DisplayObject;
		
		/**
		 * Constructor
		 * 
		 * @param stage A display object on which to listen for keyboard events. To catch all key events, this should be a reference to the stage.
		 */
		public function KeyPoll( stage:DisplayObject ) {
			states = new ByteArray();
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			dispObj = stage;
			dispObj.addEventListener( KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true );
			dispObj.addEventListener( KeyboardEvent.KEY_UP, keyUpListener, false, 0, true );
			dispObj.addEventListener( Event.ACTIVATE, activateListener, false, 0, true );
			dispObj.addEventListener( Event.DEACTIVATE, deactivateListener, false, 0, true );
		}
		
		private function keyDownListener( ev:KeyboardEvent ):void {
			states[ ev.keyCode >>> 3 ] |= 1 << (ev.keyCode & 7);
		}
		
		private function keyUpListener( ev:KeyboardEvent ):void {
			states[ ev.keyCode >>> 3 ] &= ~(1 << (ev.keyCode & 7));
		}
		
		private function activateListener( ev:Event ):void {
			for ( var i:int = 0; i < 32; ++i )  states[ i ] = 0;
		}

		private function deactivateListener( ev:Event ):void {
			for ( var i:int = 0; i < 32; ++i )  states[ i ] = 0;
		}
		
		/**
		 * To test whether a key is down.
		 *
		 * @param keyCode code for the key to test.
		 * @return true if the key is down, false otherwise.
		 * @see #isUp()
		 */
		public function isDown( keyCode:uint ):Boolean {
			return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) != 0;
		}
		
		/**
		 * To test whether a key is up.
		 *
		 * @param keyCode code for the key to test.
		 * @return true if the key is up, false otherwise.
		 * @see #isDown()
		 */
		public function isUp( keyCode:uint ):Boolean {
			return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) == 0;
		}
	}
}