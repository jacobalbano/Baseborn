package ifrit 
{
	import flash.net.SharedObject;
	
	/**
	 * @author Jake Albano
	 */
	public class SaveState 
	{
		static private var fn_ptr:*;
		
		public function SaveState() { }
		
		public static function saveLastLevel(level:String):void
		{
			var so_save:SharedObject = SharedObject.getLocal("./com.thaumaturgistgames.ifrit");
			
			if (!so_save)
			{
				trace("null");
			}
			else
			{
				trace("loaded");
				
				if (!so_save.data.level )
				{
					trace("writing");
					
					so_save.data.level = level;
					so_save.flush(100);
				}
			}
		}
		
		private static function value():void
		{
			trace("LOL");
		}
		
	}

}