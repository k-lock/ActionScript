package klock.astar.route 
{
	import klock.astar.grid.Gridboard;
	import klock.astar.tile.Tile;
	import klock.astar.tile.TileState;
	
	public class Route
	{
		public static var heuristic:Function = Pathfinder.euclidianHeuristic;			
		
		public static function findPath( firstNode:Tile, destinationNode:Tile ):void  // , connectedNodeFunction:Function
		{
			var openNodes:Array = [];
			var closedNodes:Array = [];			
			
			var currentNode:Tile = firstNode;
			var testNode:Tile;
			
			var l:int;
			var i:int;
		
			var connectedNodes:Array //:Array//= currentNode.TILE.NEIGHBORS;
			var travelCost:Number = 1.0;
			
			var g:Number;
			var h:Number;
			var f:Number;
			
			currentNode.g = 0;
			currentNode.h = Pathfinder.heuristic(currentNode, destinationNode, travelCost);
			currentNode.f  = currentNode.g + currentNode.h;

	
		//	trace( 	currentNode.g, currentNode.h, currentNode.f,  Pathfinder.heuristic( firstNode , destinationNode , travelCost)	)
			
			while ( currentNode != destinationNode ) {
				
				connectedNodes = currentNode.NEIGHBORS //connectedNodeFunction( currentNode );			
				
				l = connectedNodes.length;
				
				for (i = 0; i < l; ++i) {
					
					testNode = connectedNodes[i];
		
					if ( testNode == currentNode || testNode.State == TileState.TOWER  ) continue;					
					
					//For our example we will test just highlight all the tested nodes
					Tile(testNode).State = TileState.ENROUTE;
	
					//g = currentNode.g + Pathfinder.heuristic( currentNode, testNode, travelCost); //This is what we had to use here at Untold for our situation.
					//If you have a world where diagonal movements cost more than regular movements then you would need to determine if a movement is diagonal and then adjust
					//the value of travel cost accordingly here.
					g = currentNode.g + travelCost;
					h = Pathfinder.heuristic( testNode, destinationNode, travelCost);
					f = g + h;
	
					if ( Pathfinder.isOpen(testNode, openNodes) || Pathfinder.isClosed( testNode, closedNodes) )
					{
						if(testNode.f > f)
						{
							testNode.f = f;
							testNode.g = g;
							testNode.h = h;
							testNode.parentNode = currentNode;
						}
					}
					else {
						testNode.f = f;
						testNode.g = g;
						testNode.h = h;
						testNode.parentNode = currentNode;
						openNodes.push(testNode);
					}
					
				}
			//	trace( "NEXT NEIGHBORS -------------------------", currentNode.TILE.Position, ( currentNode.Parent != null ) ? currentNode.Parent.TILE.Position : "START TILE")
				closedNodes.push( currentNode );
				
				if (openNodes.length == 0) {
					return// null;
				}
				openNodes.sortOn('f', Array.NUMERIC);
				currentNode = openNodes.shift() as Tile;
			}
			
			
			//return Pathfinder.buildPath( destinationNode, firstNode );
			var path:Vector.<Tile> = new Vector.<Tile>();
			var currentPoint:Tile = currentNode;
			while ( currentPoint != null ) {
				path.push(currentPoint);
				currentPoint = currentPoint.parentNode;
			}
			path.reverse();
			trace( path.length )
			//return buildPath( currentNode, new TileScore( null, firstNode ))
		}
		
		
		public static function buildPath( destinationNode:Tile, startNode:Tile ):Array {			
			var path:Array = [];
			var node:Tile = destinationNode;
			path.push(node);
			while (node != startNode) {
				node = node.parentNode;
				path.unshift( node );
			}

			return path;			
		}
		
		public static function isOpen(node:Tile, openNodes:Array):Boolean {
			
			var l:int = openNodes.length;
			for (var i:int = 0; i < l; ++i) {
				if ( openNodes[i] == node ) return true;
			}
			
			return false;			
		}
		
		public static function isClosed(node:Tile, closedNodes:Array):Boolean {
			
			var l:int = closedNodes.length;
			for (var i:int = 0; i < l; ++i) {
				if (closedNodes[i] == node ) return true;
			}
			
			return false;
		}
		
		/****************************************************************************** 
		*
		*	These are our avaailable heuristics 
		*
		******************************************************************************/		
		public static function euclidianHeuristic( node:Tile, destinationNode:Tile, cost:Number = 1.0):Number
		{
			var dx:Number = node.Position.x - destinationNode.Position.x;
			var dy:Number = node.Position.y - destinationNode.Position.y;
			
			return Math.sqrt( dx * dx + dy * dy ) * cost;
		}
		
		public static function manhattanHeuristic(node:Tile, destinationNode:Tile, cost:Number = 1.0):Number
		{
			return Math.abs(node.Position.x - destinationNode.Position.x) * cost + Math.abs(node.Position.y + destinationNode.Position.y) * cost;
		}
		
		public static function diagonalHeuristic(node:Tile, destinationNode:Tile, cost:Number = 1.0, diagonalCost:Number = 1.0):Number
		{
			var dx:Number = Math.abs(node.Position.x - destinationNode.Position.x);
			var dy:Number = Math.abs(node.Position.y - destinationNode.Position.y);
			
			var diag:Number = Math.min( dx, dy );
			var straight:Number = dx + dy;
			
			return diagonalCost * diag + cost * (straight - 2 * diag);
		}
		

	}

}