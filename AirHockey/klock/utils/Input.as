package klock.utils{

	import flash.display.*;
	import flash.events.*;

	public class Input {

		static public  var _ascii		:Array;
		static private var keyState		:Array;
		static private var keyArr		:Array;
		
		static private var keyBuffer	:Array;
		static private var bufferSize	:int;

		static public var lastKey		:int = 0;
		static public var timeSinceLastKey:Number = 0;

		static public var mouseDown		:Boolean = false;
		static public var mouseReleased	:Boolean = false;
		static public var mousePressed	:Boolean = false;
		static public var mouseOver		:Boolean = false;
		static public var mouseX		:Number = 0;
		static public var mouseY		:Number = 0;
		static public var mouseOffsetX	:Number = 0;
		static public var mouseOffsetY	:Number = 0;
		static public var mouseDragX	:Number = 0;
		static public var mouseDragY	:Number = 0;
		static public var mouse			:Sprite = new Sprite();

		static public var _stage		:Stage;

		
		public function Input(stage:Stage){
			
			_stage = stage;
			
			// init _ascii array
			_ascii = new Array(222)
			fill_ascii();
			
			// init key state array
			keyState = new Array(222);
			keyArr = new Array();
			
			for (var i:int = 0; i < 222; i++){
				
				keyState[i] = new int(0);
				
				if (_ascii[i] != undefined) keyArr.push(i);
				
			}
			
			// buffer
			bufferSize = 5;
			keyBuffer  = new Array(bufferSize);
			
			for (var j:int = 0; j < bufferSize; j++) keyBuffer[j] = new Array(0,0);
		
			
			// add key listeners
			_stage.addEventListener( KeyboardEvent.KEY_DOWN,keyPress, 		false, 0, true );
			_stage.addEventListener( KeyboardEvent.KEY_UP,	keyRelease, 	false, 0, true );		
			
			// mouse listeners
			_stage.addEventListener( MouseEvent.MOUSE_DOWN, mousePress, 	false, 0, true );
			_stage.addEventListener( MouseEvent.CLICK, 		mouseRelease, 	false, 0, true );
			_stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove, 		false, 0, true );
			_stage.addEventListener( Event.MOUSE_LEAVE, 	mouseLeave, 	false, 0, true );
			
			mouse.graphics.lineStyle( 0.1, 0, 100 );
			mouse.graphics.moveTo( 0, 0);
			mouse.graphics.lineTo( 0, 0.1);
			
		}
		
		
		
		//======================
		// update
		//======================
		static public function update():void{
					
			// update used keys
			for (var i:int = 0; i < keyArr.length; i++){
				if (keyState[keyArr[i]] != 0){
					keyState[keyArr[i]]++;
				}
			}
			
			// update buffer
			for (var j:int = 0; j < bufferSize; j++){
				keyBuffer[j][1]++;
			}
			
			// end mouse release
			mouseReleased = false;
			mousePressed = false;
			mouseOver = false;
			
		}
		
		
		
		//======================
		// mousePress listener
		//======================
		public function mousePress(e:MouseEvent):void{
			mousePressed = true;
			mouseDown = true;
			mouseDragX = 0;
			mouseDragY = 0;
		}
		
		
		
		//======================
		// mousePress listener
		//======================
		public function mouseRelease(e:MouseEvent):void{
			mouseDown = false;
			mouseReleased = true;
		}
		
		
		
		//======================
		// mousePress listener
		//======================
		public function mouseLeave(e:Event):void{
			mouseReleased = mouseDown;
			mouseDown = false;
		}
		
		
		
		//======================
		// mouseMove listener
		//======================
		public function mouseMove(e:MouseEvent):void{
			
			// Fix mouse release not being registered from mouse going off stage
			if (mouseDown != e.buttonDown){
				mouseDown = e.buttonDown;
				mouseReleased = !e.buttonDown;
				mousePressed = e.buttonDown;
				mouseDragX = 0;
				mouseDragY = 0;
			}
			
			mouseX = e.stageX - _stage.x;
			mouseY = e.stageY - _stage.y;
			// Store offset
			mouseOffsetX = mouseX - mouse.x;
			mouseOffsetY = mouseY - mouse.y;
			// Update drag
			if (mouseDown){
				mouseDragX += mouseOffsetX;
				mouseDragY += mouseOffsetY;
			}
			mouse.x = mouseX;
			mouse.y = mouseY;
		}
		
		
		
		//======================
		// getKeyHold
		//======================
		static public function getKeyHold(k:int):int{
			return Math.max(0, keyState[k]);
		}
		
		
		//======================
		// isKeyDown
		//======================
		static public function isKeyDown(k:int):Boolean{
			return (keyState[k] > 0);
		}
		
		
		
		//======================
		//  isKeyPressed
		//======================
		static public function isKeyPressed(k:int):Boolean{
			timeSinceLastKey = 0;
			return (keyState[k] == 1);
		}
		
		
		
		//======================
		//  isKeyReleased
		//======================
		static public function isKeyReleased(k:int):Boolean{
			return (keyState[k] == -1);
		}
		
		
		
		//======================
		// isKeyInBuffer
		//======================
		static public function isKeyInBuffer(k:int, i:int, t:int):Boolean{
			return (keyBuffer[i][0] == k && keyBuffer[i][1] <= t);
		}
		
		
		
		//======================
		// keyPress function
		//======================
		public function keyPress(e:KeyboardEvent):void{

			// set keyState
			keyState[e.keyCode] = Math.max(keyState[e.keyCode], 1);
			
			// last key (for key config)
			lastKey = e.keyCode;
			
		}
		
		//======================
		// keyRelease function
		//======================
		public function keyRelease(e:KeyboardEvent):void{
			keyState[e.keyCode] = -1;
			
			// add to key buffer
			for (var i:int = bufferSize-1; i > 0 ; i--){
				keyBuffer[i] = keyBuffer[i - 1];
			}
			keyBuffer[0] = [e.keyCode, 0];
		}

		//======================
		// get key string
		//======================
		static public function getKeyString(k:uint):String{
			return _ascii[k];
		}
		
		
		//======================
		// set up _ascii text
		//======================
		private function fill_ascii():void{
			_ascii[65] = "A";
			_ascii[66] = "B";
			_ascii[67] = "C";
			_ascii[68] = "D";
			_ascii[69] = "E";
			_ascii[70] = "F";
			_ascii[71] = "G";
			_ascii[72] = "H";
			_ascii[73] = "I";
			_ascii[74] = "J";
			_ascii[75] = "K";
			_ascii[76] = "L";
			_ascii[77] = "M";
			_ascii[78] = "N";
			_ascii[79] = "O";
			_ascii[80] = "P";
			_ascii[81] = "Q";
			_ascii[82] = "R";
			_ascii[83] = "S";
			_ascii[84] = "T";
			_ascii[85] = "U";
			_ascii[86] = "V";
			_ascii[87] = "W";
			_ascii[88] = "X";
			_ascii[89] = "Y";
			_ascii[90] = "Z";
			_ascii[48] = "0";
			_ascii[49] = "1";
			_ascii[50] = "2";
			_ascii[51] = "3";
			_ascii[52] = "4";
			_ascii[53] = "5";
			_ascii[54] = "6";
			_ascii[55] = "7";
			_ascii[56] = "8";
			_ascii[57] = "9";
			_ascii[32] = "Spacebar";
			_ascii[17] = "Ctrl";
			_ascii[16] = "Shift";
			_ascii[192] = "~";
			_ascii[38] = "up";
			_ascii[40] = "down";
			_ascii[37] = "left";
			_ascii[39] = "right";
			_ascii[96] = "Numpad 0";
			_ascii[97] = "Numpad 1";
			_ascii[98] = "Numpad 2";
			_ascii[99] = "Numpad 3";
			_ascii[100] = "Numpad 4";
			_ascii[101] = "Numpad 5";
			_ascii[102] = "Numpad 6";
			_ascii[103] = "Numpad 7";
			_ascii[104] = "Numpad 8";
			_ascii[105] = "Numpad 9";
			_ascii[111] = "Numpad /";
			_ascii[106] = "Numpad *";
			_ascii[109] = "Numpad -";
			_ascii[107] = "Numpad +";
			_ascii[110] = "Numpad .";
			_ascii[45] = "Insert";
			_ascii[46] = "Delete";
			_ascii[33] = "Page Up";
			_ascii[34] = "Page Down";
			_ascii[35] = "End";
			_ascii[36] = "Home";
			_ascii[112] = "F1";
			_ascii[113] = "F2";
			_ascii[114] = "F3";
			_ascii[115] = "F4";
			_ascii[116] = "F5";
			_ascii[117] = "F6";
			_ascii[118] = "F7";
			_ascii[119] = "F8";
			_ascii[188] = ",";
			_ascii[190] = ".";
			_ascii[186] = ";";
			_ascii[222] = "'";
			_ascii[219] = "[";
			_ascii[221] = "]";
			_ascii[189] = "-";
			_ascii[187] = "+";
			_ascii[220] = "\\";
			_ascii[191] = "/";
			_ascii[9] = "TAB";
			_ascii[8] = "Backspace";
			//_ascii[27] = "ESC";
		}
		
		
	}
	
	
}
