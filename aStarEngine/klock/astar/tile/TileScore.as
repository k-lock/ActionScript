package klock.astar.tile
{
	import flash.events.EventDispatcher;
	
	public class TileScore{
		
		private var parent					:TileScore = null;
		public function get Parent()		:TileScore 			{ return parent;  } 
		public function set Parent( value	:TileScore ):void	{ parent = value; }
		
		private var tile					:Tile = null;
		public function get Tile_()			:Tile 				{ return tile;  } 
		public function set Tile_( value	:Tile ):void		{ tile = value; }
	
		private var gScore					:Number = 0;
		public function get GScore()	    :Number 			{ return gScore;  } 
		public function set GScore( value	:Number ):void	 	{ gScore = value; }// this.Score = this.GScore + this.HScore; } 
		
		private var hScore					:Number = 0;
		public function get HScore()	    :Number 			{ return hScore;  } 
		public function set HScore( value	:Number ):void	 	{ hScore = value; }// this.Score = this.GScore + this.HScore; } 
		
		private var score					:Number = 0;
		public function get Score()	    	:Number 			{ return score;  } 
		public function set Score( value	:Number ):void 		{ score = value; } 
		
		public function TileScore() {}
		
		
	}
}