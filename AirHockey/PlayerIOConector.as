package
{
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import playerio.*;
	import playerio.Connection;
	
	public class PlayerIOConector extends EventDispatcher
	{
		private static const _gameID	:String = "test-game-irioblxrleucdxtqg4pinw"
		private var _stage				:Stage
		private var _connection			:Connection
		
		public function PlayerIOConector( stage_:Stage )
		{
			_stage = stage_
			connectToserver()
		}
		
		private function connectToserver():void
		{
			PlayerIO.connect(
				_stage,								//Referance to stage
				_gameID,							//Game id
				"public",							//Connection id, default is public
				"GuestUser",						//Username
				"",									//User auth. Can be left blank if authentication is disabled on connection
				null,								//Current PartnerPay partner.
				handleConnect,						//Function executed on successful connect
				handleError							//Function executed if we recive an error
			);   
			
		}
		
		private function handleConnect( client:Client ):void
		{
			trace("Sucessfully connected to player.io");
			
			//Set developmentsever (Comment out to connect to your server online)
			client.multiplayer.developmentServer = "127.0.0.1:8184";
			
			//Create pr join the room test
			client.multiplayer.createJoinRoom(
				"airHockey",								//Room id. If set to null a random roomid is used
				"AirHockey",					//The game type started on the server
				true,								//Should the room be visible in the lobby?
				{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
				{},									//User join data
				handleJoin,							//Function executed on successful joining of the room
				handleError							//Function executed if we got a join error
			);
		}
		
		private function handleJoin( connection:Connection ):void
		{
			_connection = connection;
			
			dispatchEvent( new Event("connect_PlayerIO", true ))
			
		}

		private function handleError(error:PlayerIOError):void
		{
			trace("Got", error);			
		}
		
		
		public function get CONNECTION():Connection { return _connection } 
		
	}
}