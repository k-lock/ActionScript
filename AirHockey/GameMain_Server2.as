package
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Joints.*;
	
	import com.flashdynamix.motion.TweensyZero;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import klock.simpleComponents.components.Button;
	import klock.simpleComponents.components.Label;
	import klock.utils.ObjectLister;
	
	import playerio.Connection;
	import playerio.Message;

	public class GameMain_Server2 extends Sprite
	{
				
		public static var m_iterations		:int 	= 10;
		public static var m_world_scale		:int 	= 30;
		public static var m_timeStep		:Number = 1 / m_world_scale;	
		
		
		public var _mouseXWorldPhys			:Number;
		public var _mouseYWorldPhys			:Number;
		
		private var dragginA				:Boolean = false
		private var dragginB 				:Boolean = false
		
		private var m_world					:b2World;
		
		private var serverJointA			:b2MouseJoint
		private var serverJointB			:b2MouseJoint
		
		private var serverMouseX			:Number
		private var serverMouseY			:Number
		
		private var m_mouseJointA			:b2MouseJoint;
		private var playerA_Body			:b2Body;
		private var playerA_Sprite			:Sprite;
		
		private var m_mouseJointB			:b2MouseJoint;
		private var playerB_Body			:b2Body;
		private var playerB_Sprite			:Sprite;
		
		private var puck_Body				:b2Body;
		private var puck_Sprite				:Sprite;
		
		private var goal_up  				:b2AABB
		private var goal_down				:b2AABB

		private var labelC					:Label
		private var labelB					:Label
		private var labelA					:Label
		
		private var _scoreBoard				:Sprite;
		
		private var _stage					:Stage
		private var m_ID					:uint
		
		private var _connection				:Connection
		
		public function GameMain_Server2()
		{
			addEventListener(Event.ADDED_TO_STAGE , GameMain_Init)
		}
		
		private function GameMain_Init( event:Event ):void 
		{	
			removeEventListener( Event.ADDED_TO_STAGE , GameMain_Init)
			_stage = stage

			var pioc :PlayerIOConector = new PlayerIOConector( _stage ) 
				pioc.addEventListener( "connect_PlayerIO", ConnectToServer )
	

		}
		
		private function ConnectToServer( event:Event ):void{
	
			_connection = PlayerIOConector( event.target ).CONNECTION
			
			SetupMessages()
			
			PlayerIOConector( event.target ).removeEventListener( "connect_PlayerIO", ConnectToServer )
		}
		
		private function SetupMessages():void{

			_connection.addMessageHandler( "goalReset", function( m:Message, _id:uint, _aScore:uint,_bScore:uint ):void{ 
				
				ResetGameBoard()
			    showPoints( _aScore, _bScore );
				
			});
			
			_connection.addMessageHandler( "add_client", function( m:Message, _id:int ):void {  m_ID = _id } );		
			_connection.addMessageHandler( "start_game", function( m:Message )         :void {  Starter()  } );
			
			_connection.addMessageHandler( "startDrag",  function( m:Message, _id:int, _x:Number, _y:Number ):void { startMover( _id, _x, _y ) });
			_connection.addMessageHandler(  "dragMove",  function( m:Message, _id:int, _x:Number, _y:Number ):void { onMover   ( _id, _x, _y ) });
			_connection.addMessageHandler(  "stopDrag",  function( m:Message, _id:int )						:void { stopMover ( _id ) });
			
			_connection.addMessageHandler(  "PuckRefresh",  function( m:Message ):void  {  ResetGameBoard() });
			_connection.addMessageHandler( "playerAPos", function( m:Message, _id:int, _x:Number, _y:Number ):void
			{
				if( m_ID == 1 ) return 
				var plAdef : b2BodyDef = playerA_Body.GetDefinition()
			
					playerA_Body.SetPosition( new b2Vec2( _x, _y))
					plAdef.position = new b2Vec2( _x, _y)
					
					playerA_Body.SetActive( false)
					playerA_Body.SetAwake( false)
					
			});	
			
			_connection.addMessageHandler( "playerBPos", function( m:Message, _id:int, _x:Number, _y:Number ):void
			{
				if( m_ID == 2 ) return 
				
				var plBdef : b2BodyDef = playerB_Body.GetDefinition()

				playerB_Body.SetPosition( new b2Vec2( _x, _y))
				plBdef.position = new b2Vec2( _x, _y)
				
				
				playerB_Body.SetActive( false)
				playerB_Body.SetAwake( false)
			
			});	

			_connection.addMessageHandler(  "movePuck",  function( m:Message, _x:Number, _y:Number, _vx:Number, _vy:Number, _a:Number ):void{
				
				var half:Number = puck_Sprite.width*.5
				var plAdef : b2BodyDef = puck_Body.GetDefinition()
				
				if( m_ID == 2 ){

						puck_Body.SetPosition( new b2Vec2((_x +half ) / m_world_scale, (_y +half ) / m_world_scale))
						plAdef.position = new b2Vec2( (_x +half ) / m_world_scale, (_y +half ) / m_world_scale)
				//		plAdef.linearVelocity = new b2Vec2( _vx, _vy )

				}
				if( m_ID == 1 ){

					puck_Body.SetPosition( new b2Vec2((_x +half ) / m_world_scale, (_y +half ) / m_world_scale))
					plAdef.position = new b2Vec2( (_x +half ) / m_world_scale, (_y +half ) / m_world_scale)
					//		plAdef.linearVelocity = new b2Vec2( _vx, _vy )
					
				}
				
			});

		}
		
		private function showPoints( _aScore:uint, _bScore:uint ):void
		{
		
			Label( _scoreBoard.getChildAt( 0 )).text = _aScore.toString(); 
			Label( _scoreBoard.getChildAt( 1 )).text = _bScore.toString();
			
		}
		
		// ================================================================================================================
		//																								  	Game Starter
		//=================================================================================================================	
		
		private function Starter():void
		{		
			trace( "GameMain - Starter", m_ID)
			
			initGameBoard()
			
			
			PlayerEventHandler()
			
			initGameTick( 5 )

			
				var b:Button = new Button({x:5,y:5}, "Reset Puck", this, RefreshBall )
		}
		
		private function RefreshBall( event:Event ):void{
			
			_connection.send( "PuckRefresh", m_ID)
			
		}
		
		private function PlayerEventHandler():void
		{
			if( m_ID == 1 )
			{
				playerA_Sprite.addEventListener( MouseEvent.MOUSE_DOWN, StartDraggin)
		
				playerA_Body.SetSleepingAllowed( false )
				playerB_Body.SetSleepingAllowed( true)
				
				puck_Body.SetSleepingAllowed(false )
				
				//		playerB_Body.SetType( 1 )
				
				//		playerB_Body.SetActive( false)
				//		playerB_Body.SetAwake( false)
				
			}else{
				
				playerB_Sprite.addEventListener( MouseEvent.MOUSE_DOWN, StartDraggin)
				
				playerA_Body.SetSleepingAllowed( true )
				playerB_Body.SetSleepingAllowed( false)
				
				puck_Body.SetSleepingAllowed( false )
		//		puck_Body.SetType( b2Body.b2_staticBody )
				
		//		playerA_Body.SetActive( false)
		//		playerA_Body.SetAwake( false)
				
			}
	
			stage.addEventListener( MouseEvent.MOUSE_UP, StopDraggin, false, 0, true  );
		}
		
		private function ResetGameBoard():void
		{
		
			var stageW	:Number = _stage.stageWidth
			var stageH	:Number = _stage.stageHeight
			var half	:Number = puck_Sprite.width*.5
			var puckdef :b2BodyDef = puck_Body.GetDefinition()
			
			puck_Body.SetLinearVelocity( new b2Vec2(0,0) )
			puck_Body.SetPosition( new b2Vec2( ( stageW*.5 ) / m_world_scale, ( stageH*.5 ) / m_world_scale))
			puckdef.position     = new b2Vec2( ( stageW*.5 ) / m_world_scale, ( stageH*.5 ) / m_world_scale)
			puckdef.linearVelocity = new b2Vec2(0,0)
				
			var playAdef 	:b2BodyDef = puck_Body.GetDefinition()
			
			playerA_Body.SetLinearVelocity( new b2Vec2(0,0) )
			playerA_Body.SetPosition( new b2Vec2( ( stageW*.5 ) / m_world_scale, ( stageH/3 ) / m_world_scale))
			playAdef.position    =    new b2Vec2( ( stageW*.5 ) / m_world_scale, ( stageH/3 ) / m_world_scale)
			playAdef.linearVelocity = new b2Vec2(0,0)	
	
			var playBdef 	:b2BodyDef = puck_Body.GetDefinition()
			
			playerB_Body.SetLinearVelocity( new b2Vec2(0,0) )
			playerB_Body.SetPosition( new b2Vec2( ( stageW*.5 ) / m_world_scale, ( stageH-(stageH/3) ) / m_world_scale))
			playBdef.position    =    new b2Vec2( ( stageW*.5 ) / m_world_scale, ( stageH-(stageH/3) ) / m_world_scale)
			playBdef.linearVelocity = new b2Vec2(0,0)		
				
			removeTimer()
			initGameTick( 5 )
		
		}
		
		
		// ================================================================================================================
		//																								   Logic Game Tick
		//=================================================================================================================	
		
		private function LogicTick( event:Event=null ):void {
			
			MouseWorldPhysics()	
			
			m_world.Step( m_timeStep, m_iterations, m_iterations );
			m_world.ClearForces();
			m_world.DrawDebugData();
			
			//if( m_ID==2 && puck_Body.IsActive() || m_ID==1 )
			moveBody( playerA_Sprite, playerA_Body)
			moveBody( playerB_Sprite, playerB_Body)
			moveBody( puck_Sprite,    puck_Body)	
			
			//		labelA.text = int(playerA_Body.GetPosition().x) +  " | " + int(playerA_Body.GetPosition().y) + " | " + "Player A" + m_ID + " | " + playerA_Body.IsActive()
			//		labelB.text = int(playerB_Body.GetPosition().x) +  " | " + int(playerB_Body.GetPosition().y) + " | " + "Player B" + m_ID  + " | " + playerB_Body.IsActive()
			labelC.text = int(   puck_Body.GetPosition().x )+  " / " + int(   puck_Body.GetPosition().y) + " | " + m_ID + " | " + puck_Body.IsActive()
		
	
			if( m_ID == 1) _connection.send( "movePuck", m_ID, puck_Sprite.x, puck_Sprite.y, puck_Body.GetLinearVelocity().x,  puck_Body.GetLinearVelocity().y,0)
		//	if( m_ID == 2 && puck_Sprite.y > 350 ) _connection.send( "movePuck", m_ID, puck_Sprite.x, puck_Sprite.y, puck_Body.GetLinearVelocity().x,  puck_Body.GetLinearVelocity().y,0)
				
			
			if( m_ID == 1 && !dragginA) _connection.send( "playerAPos", playerA_Body.GetPosition().x, playerA_Body.GetPosition().y )
			if( m_ID == 2 && !dragginB) _connection.send( "playerBPos", playerB_Body.GetPosition().x, playerB_Body.GetPosition().y )
	
				
			if( puck_Sprite.y < -20 ) {_connection.send( "playerBgoal", m_ID); removeTimer() }
			if( puck_Sprite.y > 720 ) {_connection.send( "playerAgoal", m_ID); removeTimer() }
		
		/*	if( m_ID == 1 ) {
				
					playerB_Body.SetAwake(( puck_Sprite.y > 350) ? true : false )
				
			}*/
			
		}
		
		private function moveBody( sprite:Sprite, body:b2Body ):void{	
			
			sprite.x = ( body.GetPosition().x * m_world_scale ) - ( sprite.width * 0.5 );
			sprite.y = ( body.GetPosition().y * m_world_scale ) - ( sprite.width * 0.5 );
			
		}		
		
		// ================================================================================================================
		//																								Physic Mouse Setup
		//=================================================================================================================	
		
		private function MouseWorldPhysics():void{
			
			_mouseXWorldPhys = (stage.mouseX) / m_world_scale; 
			_mouseYWorldPhys = (stage.mouseY) / m_world_scale; 
			
			if( m_mouseJointA && dragginA ) m_mouseJointA.SetTarget( new b2Vec2( _mouseXWorldPhys, _mouseYWorldPhys ) );
			if( m_mouseJointB && dragginB ) m_mouseJointB.SetTarget( new b2Vec2( _mouseXWorldPhys, _mouseYWorldPhys ) );	
			
		}		
	
		// ================================================================================================================
		//																						   Server Paddle Drag Mover
		//=================================================================================================================	
	
		private function startMover(  _id:int, _x:Number, _y:Number ):void
		{
			
//trace( "startMover ", _id, m_ID)			
			
			var body:b2Body =  ( _id == 2 && m_ID == 1 ) ? playerB_Body : playerA_Body
				body.GetPosition().Set( _x, _y )
			
			var joint:b2MouseJointDef = new b2MouseJointDef();
				joint = new b2MouseJointDef();
				joint.bodyA = m_world.GetGroundBody();
				joint.bodyB =body;
				joint.target.Set( _x, _y );
				joint.collideConnected = false;
				joint.dampingRatio = 0
				joint.maxForce =  1000.0 * body.GetMass();
			
			if( _id == 1 && m_ID == 2 ) {
				
				if ( !m_mouseJointA ) {
					
					//		dragginA = true
					m_mouseJointA = m_world.CreateJoint(joint) as b2MouseJoint;
				}
			}
			
			if( _id == 2 && m_ID == 1 ) {
				
				if ( !m_mouseJointB ) {
					
					//	dragginB = true
					m_mouseJointB = m_world.CreateJoint(joint) as b2MouseJoint;
				}
			}
		}
		private function onMover( _id:int, _x:Number, _y:Number ):void
		{
			if( _id == 1 && m_ID == 2 ) {
				
				if( !playerA_Body.IsActive() )playerA_Body.SetActive( true )
				
				m_mouseJointA.SetTarget( new b2Vec2( _x, _y ) );
				m_mouseJointA.SetDampingRatio( 0.3 )
				
				playerA_Body.GetLinearVelocity( ).Set( 0, 0 )
	
			}
			if( _id == 2 && m_ID == 1 ) {
				
				
				if( !playerB_Body.IsActive() )playerB_Body.SetActive( true )
				
				m_mouseJointB.SetTarget( new b2Vec2( _x, _y ) );
				m_mouseJointB.SetDampingRatio( 0.3 )
				
				playerB_Body.GetLinearVelocity( ).Set( 0, 0 )
				
			}
		}
		private function stopMover( _id:uint ):void
		{
			if( _id == 1 && m_ID == 2 ) {
				
				m_world.DestroyJoint(m_mouseJointA);
				m_mouseJointA = null;
			}
			
			if( _id == 2 && m_ID == 1 ) {
				
				m_world.DestroyJoint(m_mouseJointB);
				m_mouseJointB = null;
			}
		}
		
		// ================================================================================================================
		//																						    	Player Paddle Drag
		//=================================================================================================================	
		
		private function StartDraggin( event:MouseEvent ):void
		{		
			
			if( event.type == "mouseDown"){
				
				var body :b2Body = ( m_ID == 1 ) ? playerA_Body : playerB_Body		
				body.SetPosition( new b2Vec2(  body.GetPosition().x, body.GetPosition().y) )
		//		body.GetFixtureList().SetRestitution( 0 )
		//		body.GetLinearVelocity( ).Set( 0, 0 )
				body.SetAwake(true);
				
				var joint:b2MouseJointDef = new b2MouseJointDef();
				joint = new b2MouseJointDef();
				joint.bodyA = m_world.GetGroundBody();
				joint.bodyB = body;
				joint.target.Set( body.GetPosition().x, body.GetPosition().y );
				joint.collideConnected = false;
				joint.dampingRatio = 0.3
				joint.maxForce =  1000.0 * body.GetMass();
				
				if ( !m_mouseJointA && event.target == playerA_Sprite) {
					
					dragginA = true	
					m_mouseJointA = m_world.CreateJoint(joint) as b2MouseJoint;
					_connection.send( "startDrag" , 1,  body.GetPosition().x, body.GetPosition().y)
					addEventListener( MouseEvent.MOUSE_MOVE, OnDragging );

					return
				}
				
				if ( !m_mouseJointB && event.target == playerB_Sprite ) {
					
					dragginB = true
					m_mouseJointB = m_world.CreateJoint(joint) as b2MouseJoint;
					_connection.send( "startDrag" , 2, body.GetPosition().x, body.GetPosition().y)
					addEventListener( MouseEvent.MOUSE_MOVE, OnDragging );	
		
			//		puck_Body.SetActive( true )
			/*		if( serverJointB ){
						m_world.DestroyJoint( serverJointB );
						serverJointB = null;
					}*/
					return
				}
			}
		}
		
		private function OnDragging(event:MouseEvent):void
		{
			var body:b2Body = ( m_ID == 1) ? playerA_Body : playerB_Body
		
		
			body.GetFixtureList().SetRestitution( .3 )	
			_connection.send( "draggin", m_ID, body.GetDefinition().position.x, body.GetDefinition().position.y )	
		}
		
		private function StopDraggin( event:MouseEvent ):void
		{
			if( !dragginA && m_ID == 1 || !dragginB && m_ID == 2 ) return 
			var body :b2Body = ( m_ID == 1 ) ? playerA_Body : playerB_Body
			body.GetFixtureList().SetRestitution( .3 )
			body.GetLinearVelocity( ).Set( 0, 0 )
			
			if (m_ID == 1 && m_mouseJointA && dragginA ){
				
				m_world.DestroyJoint(m_mouseJointA);
				m_mouseJointA = null;
				dragginA = false
				
			}else if (m_ID == 2 && m_mouseJointB && dragginB ){
				
				m_world.DestroyJoint(m_mouseJointB);
				m_mouseJointB = null;
				dragginB = false
					
			//	puck_Body.SetActive( false )

			}
			
			removeEventListener( MouseEvent.MOUSE_MOVE, OnDragging );
		
		}

		// ================================================================================================================
		//																								Game Object Setup
		//=================================================================================================================	
		
		private function initGameBoard():void
		{
			// graphics
			
			var bm:Bitmap = Assets.getTexture( "Field" )
			var m:Matrix = bm.transform.matrix
				m.scale( _stage.stageWidth/bm.width, _stage.stageHeight/bm.height )
			
			var g:Graphics = this.graphics
				g.beginBitmapFill( bm.bitmapData , m)
				g.drawRect( 0,0, _stage.stageWidth, _stage.stageHeight );
	
			// Box2D 
			
			m_world = new b2World(new b2Vec2(0, 0), true);
			
			var stageW:Number = _stage.stageWidth
			var stageH:Number = _stage.stageHeight
			var element:Number = ( stageW*.5 ) - ( stageW / 4 ) *.5
			
			labelA = createTxt( 10, 10,  	   "" );
			labelB = createTxt( 10, stageH-60, "" );
			labelC = createTxt( 10, stageH*.5 ,"" );
			
			// drawing the boundaries 
			createBox( 			   element*.5, 710,              element, 20, false, "ground1" );
			createBox(         ( stageW *.5 ), 717.5, stageW-(element*2),  5, false, "ground2", true );		
			createBox(( stageW - element*.5 ), 710,              element, 20, false, "ground3");	
			
			createBox(       -5, stageH*.5, 10, stageH, false, "left" );
			createBox( stageW+5, stageH*.5, 10, stageH, false, "right");
			
			createBox( 			   element*.5, -10,              element, 20, false, "roof1" );
			createBox(         ( stageW *.5 ), -17.5, stageW-(element*2),  5, false, "roof2", true );		
			createBox(( stageW - element*.5 ), -10,              element, 20, false, "roof3");
			
			createBox(          ( stageW*.5 ),( stageH*.5 ),     stageW,   1, false, "middleBreak", true);
			
			
			
			createPlayer      ( stageW*.5, stageH/3 )
			createSecondPlayer( stageW*.5, stageH-(stageH/3))
			createPuck        ( stageW*.5, stageH*.5 )
			
			// AABB field to test if puck going out of bounds
			goal_up = new b2AABB();
			goal_up.lowerBound.Set( 0, -70/m_world_scale);
			goal_up.upperBound.Set( stageW/m_world_scale, -60/m_world_scale);
			
			goal_down = new b2AABB();
			goal_down.lowerBound.Set( 0, (stageH+70)/m_world_scale);
			goal_down.upperBound.Set( stageW/m_world_scale, (stageH+80)/m_world_scale);
			
			
			// scoreBoard
			addChild( _scoreBoard = new Sprite())
			_scoreBoard.mouseChildren = _scoreBoard.mouseEnabled = false
			var a:Label = new Label( {x: 50, y:stageH/3         }, "0", _scoreBoard )
			var b:Label = new Label( {x: 50, y:stageH-(stageH/3)}, "0", _scoreBoard )
				
			debugDraw()
		}
		
		
		
		private function createPuck(  px:Number, py:Number, radius:Number=.95, velX:Number=0, velY:Number=0):void
		{
		//	if( m_ID == 1 ){
				var dataObj:Object;
				dataObj = new Object();
				dataObj.name = "PUCK";
				dataObj.base = this;
				
				var bodyDef:b2BodyDef = new b2BodyDef();
				bodyDef.type = b2Body.b2_dynamicBody;
				bodyDef.position.Set( px * m_timeStep, py * m_timeStep );
								
				var fixtDef:b2FixtureDef = new b2FixtureDef();
				fixtDef.shape = new b2CircleShape( radius );
				fixtDef.restitution = .6;
				fixtDef.friction = 8.5;
				fixtDef.density = 100;
				fixtDef.filter.groupIndex = -1
				
				//		fixtDef.isSensor = true
		//		fixtDef.userData = dataObj;
				
				
				puck_Body = m_world.CreateBody(bodyDef);			
				puck_Body.SetLinearVelocity( new b2Vec2( velX, velY ) );
				puck_Body.SetUserData( "PUCK" )
				puck_Body.CreateFixture(fixtDef);
			
	//		}
			puck_Sprite = new Sprite();
			puck_Sprite.addChild( Assets.getTexture("Puck") )
			puck_Sprite.width =  puck_Sprite.height = radius * 2 * m_world_scale
			puck_Sprite.x = px - (radius * 2 * m_world_scale)*.5;
			puck_Sprite.y = py - (radius * 2 * m_world_scale)*.5;
			
		//	puck_Sprite.alpha = 0
			
			
			this.addChild( puck_Sprite );
		}
		
		private function createPlayer(  px:Number, py:Number, radius:Number = 1.3, velX:Number = 0, velY:Number = 0):void
		{
	//		if( m_ID == 1 ){
				
				var dataObj:Object;
				dataObj = new Object();
				dataObj.name = "PLAYER_A" ;
				dataObj.base = this;
				
				var bodyDef:b2BodyDef = new b2BodyDef();
				bodyDef.type = b2Body.b2_dynamicBody;
				bodyDef.position.Set( px * m_timeStep, py * m_timeStep );
				
				var fixtDef:b2FixtureDef = new b2FixtureDef();
				fixtDef.shape = new b2CircleShape( radius );
				fixtDef.restitution = .3;
				fixtDef.friction = 0.5;
				fixtDef.density = 30;
		//		fixtDef.userData = dataObj;
				
				playerA_Body = m_world.CreateBody( bodyDef );
				playerA_Body.SetFixedRotation( true )
				playerA_Body.SetLinearVelocity( new b2Vec2( velX, velY ) );
				playerA_Body.SetUserData( "PLAYER" )
				playerA_Body.CreateFixture(fixtDef);
	
	//		}
			
			var bm:Bitmap = Assets.getTexture("Player")
			playerA_Sprite = new Sprite();
			playerA_Sprite.addChild( bm )
			playerA_Sprite.width =  playerA_Sprite.height = radius * 2 * m_world_scale
			playerA_Sprite.x = px - (radius * 2 * m_world_scale)*.5;
			playerA_Sprite.y = py - (radius * 2 * m_world_scale)*.5;
		//	playerA_Sprite.alpha = 0
			
			addChild(playerA_Sprite);
			
		}
		
		private function createSecondPlayer(  px:Number, py:Number, radius:Number = 1.3, velX:Number = 0, velY:Number = 0):void
		{

			var dataObj:Object;
			dataObj = new Object();
			dataObj.name = "PLAYER_B" ;
			dataObj.base = this;
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set( px * m_timeStep, py * m_timeStep );
			
			var fixtDef:b2FixtureDef = new b2FixtureDef();
			fixtDef.shape = new b2CircleShape( radius );
			fixtDef.restitution = .3;
			fixtDef.friction = 0.5;
			fixtDef.density = 30;
	//		fixtDef.userData = dataObj;
			
			playerB_Body = m_world.CreateBody( bodyDef );
			playerB_Body.SetFixedRotation( false )
			playerB_Body.SetLinearVelocity( new b2Vec2( velX, velY ) );
			playerB_Body.SetUserData( "PLAYERB" )
			playerB_Body.CreateFixture(fixtDef);
			
		
				
			var bm:Bitmap = Assets.getTexture("Player2")
			playerB_Sprite = new Sprite();
			playerB_Sprite.addChild( bm )
			playerB_Sprite.width =  playerB_Sprite.height = radius * 2 * m_world_scale
			playerB_Sprite.x = px - (radius * 2 * m_world_scale)*.5;
			playerB_Sprite.y = py - (radius * 2 * m_world_scale)*.5;
			
		//	playerB_Sprite.alpha = 0
			
			addChild(playerB_Sprite);
			
		}
		
		private function createBox( bx:Number, by:Number, w:Number, h:Number, d:Boolean, ud:String, goal:Boolean = false ):b2Body {
			
			var my_body:b2BodyDef = new b2BodyDef();
			my_body.position.Set( bx/m_world_scale, by/m_world_scale );
			my_body.type = (d)? b2Body.b2_dynamicBody : b2Body.b2_staticBody;
			
			var my_box:b2PolygonShape = new b2PolygonShape();
			my_box.SetAsBox( w/2/m_world_scale, h/2/m_world_scale );
			
			var my_fixture:b2FixtureDef = new b2FixtureDef();
			my_fixture.shape = my_box;
			my_fixture.filter.groupIndex = ( goal ) ? -1 : 1
			my_fixture.userData = null
			
			var world_body:b2Body = m_world.CreateBody(my_body);
			world_body.SetUserData(ud);
			world_body.CreateFixture(my_fixture);
			
			return world_body;
			
		}

		private function createTxt( tx:Number, ty:Number, text:String, width:uint = 200, height:uint = 50 ):Label
		{
			var tf:Label = new Label({x:tx, y:ty},text, this )
			tf.setSize( 200, 200 )
			
			return tf;
		}
		
		// ================================================================================================================
		//																							Box2D Debug Draw Setup 
		//=================================================================================================================
		
		private function debugDraw():void {
			
			var debug_sprite:Sprite = new Sprite();
			debug_sprite.mouseChildren = debug_sprite.mouseEnabled = false
			addChild(debug_sprite);
			
			var debug_draw:b2DebugDraw = new b2DebugDraw();
			debug_draw.SetSprite(debug_sprite);
			debug_draw.SetDrawScale(m_world_scale);
			debug_draw.SetFillAlpha( 1 )//0.8);
			debug_draw.SetLineThickness(1.0);
			debug_draw.SetFlags( b2DebugDraw.e_shapeBit| b2DebugDraw.e_jointBit | b2DebugDraw.e_controllerBit);
			
			m_world.SetDebugDraw(debug_draw);
			
		}	
		
		
		// ================================================================================================================
		//																										Game Timer 
		//=================================================================================================================
		
		private var theTimer:Timer
		
		private function initGameTick( _tick:uint):void
		{
		//	if( theTimer !== null )
			
			theTimer = new Timer( _tick );
			theTimer.start();
			theTimer.addEventListener( TimerEvent.TIMER, timerTick);
		//	theTimer.addEventListener( TimerEvent.TIMER_COMPLETE, removeTimer);
		}
		
		private function timerTick( event:TimerEvent ):void 
		{
			LogicTick( null )
		}
		
		private function removeTimer():void 
		{
			theTimer.removeEventListener( TimerEvent.TIMER, timerTick);
			theTimer.stop();
			
			//delete(theTimer)
		}
		
	
	}
}