package klock.utils
{
	public class ObjectLister
	{
		public function ObjectLister()

		
		public static function LISTER(obj:Object):void{
			
			var n:uint = obj.numChildren
			
			for(var i:uint=0;i<n;i++){
				
				trace(i, obj.getChildAt(i),  obj.getChildAt(i).name)	
				
				
			}
			
			
			
		}
		
	}
}