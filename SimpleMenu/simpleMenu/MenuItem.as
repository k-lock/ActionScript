package klock.simpleMenu
{
	/** Main holder object for menu items.*/
	public class MenuItem
	{
		public static const ITEM_BOOL	:String = "item_bool"
		public static const ITEM_UINT	:String = "item_uint"
		public static const ITEM_CBOX	:String = "item_cbox"
		public static const PARENT		:String = "parent"
		public static const CHILD		:String = "child"
		
		public var LABEL:String
		public var TYPE :String
		public var VALUE:int
		public var VALUE_OBJECT:Object=null
		
		public function MenuItem( label:String, type:String, value:int = -1, ...parameters )
		{ 
			LABEL = label
			TYPE  = type
			VALUE = value
			
			if( parameters.length>0 )
			{
				var r:Vector.<String> = new Vector.<String>();
				var n:uint = parameters.length;
				for(var i:uint= 0; i<n; i++) r.push( parameters[i] )
				VALUE_OBJECT = r;
			}else{
				
				VALUE_OBJECT = null;
				
			}
		}
		
	}
}