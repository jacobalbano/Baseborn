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
		
		public static function get knowsA():Boolean
		{
			return so.data.knowsA || false;
		}
		
		public static function set knowsA(p:Boolean):void
		{
			if (so)	so.data.knowsA = p;
		}
		
		public static function get knowsS():Boolean
		{
			return so.data.knowsS || false;
		}
		
		public static function set knowsS(p:Boolean):void
		{
			if (so)	so.data.knowsS = p;
		}
		
		public static function get knowsD():Boolean
		{
			return so.data.knowsD || false;
		}
		
		public static function set knowsD(p:Boolean):void
		{
			if (so)	so.data.knowsD = p;
		}
		
	}

}