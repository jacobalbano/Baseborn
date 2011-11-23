package ifrit 
{
	import flash.net.SharedObject;
	
	/**
	 * @author Jake Albano
	 */
	public class SaveState 
	{
		public function SaveState() { }
		
		public static function set level(level:String):void
		{
			var so_save:SharedObject = SharedObject.getLocal("./com.thaumaturgistgames.ifrit");
			
			if (so_save)
			{
				so_save.data.level = level;				
			}
		}
		
		public static function get level():String
		{
			return SharedObject.getLocal("./com.thaumaturgistgames.ifrit").data.level || null;
		}
		
		public static function set playerClass(playerClass:uint):void
		{
			var so_save:SharedObject = SharedObject.getLocal("./com.thaumaturgistgames.ifrit");
			
			if (so_save)
			{
				trace("writing class");
				trace(playerClass);
				so_save.data.playerClass = playerClass;				
			}
		}
		
		public static function get playerClass():uint
		{
			trace(SharedObject.getLocal("./com.thaumaturgistgames.ifrit").data.playerClass);
			return SharedObject.getLocal("./com.thaumaturgistgames.ifrit").data.playerClass || 0;
		}
		
	}

}