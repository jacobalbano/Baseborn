package ifrit 
{
	import flash.net.SharedObject;
	
	/**
	 * @author Jake Albano
	 */
	public class SaveState 
	{
		private static const so:SharedObject = SharedObject.getLocal("com.thaumaturgistgames.ifrit");
		
		public static function set level(level:String):void
		{
			if (so)	so.data.level = level;
		}
		
		public static function get level():String
		{
			return so.data.level || null;
		}
		
		public static function set playerClass(playerClass:uint):void
		{
			if (so)	so.data.playerClass = playerClass;
		}
		
		public static function get playerClass():uint
		{
			return so.data.playerClass || 0;
		}
		
		//public static function set knownSkills():void
		//{
			//if (so)	so.data.
		//}
		//
		//public static function get knownSkills():
		//{
			//return so.data.
		//}
		
	}

}