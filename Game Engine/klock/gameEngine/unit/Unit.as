package klock.gameEngine.unit
{
	import klock.gameEngine.interfaces.ITransformer;
	
	

	public class Unit
	{
		/** The DisplayObject Holder */
		public var instance	:Object

		public function Unit( target:Object, position:Object = null )	
		{
			instance = target
			
			transform ( position )
			
			
		}
		
		
		
		
		public function transform( position:Object) :void{
			
		/*	unit.x =  position.x
			unit.y =  position.y
			unit.z =  position.z
			unit.rotationX =  position.rotX
			unit.rotationY =  position.rotX
			unit.rotationZ =  position.rotZ
			unit.alpha =  position.alpha	
		*/			
			for(var prop:String in position){
				instance[prop] += position[prop]
			}
			
			
		
			
			
		}		
		
		
		
		//
	}
}