package ifrit 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Music extends Audio
	{
		public static const BEACH_VOL:Number = 0.5;
		public static const FOREST_VOL:Number = 0.5;
		public static const TOWER_VOL:Number = 0.5;
		public static const DUNGEON_VOL:Number = 0.45;
		public static const HELLTHER_VOL:Number = 1;
		public static const BOSS_VOL:Number = 0.5;
		public static const FINALE_VOL:Number = 1;
		
		public var sound:Sound;
		public var channel:SoundChannel;
		public var transform:SoundTransform;
		
		public var name:String;
		public var playing:Boolean;
		
		private var position:Number;
		private var count:uint;
		
		public function Music(name:String, sound:Sound, vol:Number) 
		{
			this.name = name;
			this.sound = sound;
			this.position = -1;
			this.count = 0;
			this.transform = new SoundTransform(vol);
		}		
	}

}