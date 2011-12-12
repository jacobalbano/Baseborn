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
		public var sound:Sound
		public var channel:SoundChannel;
		public var name:String;
		
		public function Music(name:String, sound:Sound) 
		{
			this.sound = sound;
			this.name = name;
		}
		
	}

}