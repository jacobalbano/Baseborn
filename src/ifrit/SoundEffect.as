package ifrit 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class SoundEffect extends Audio
	{
		
		public var sound:Sound;
		public var name:String;
		public var playing:Boolean;
		public var channel:SoundChannel;
		
		public function SoundEffect(name:String, sound:Sound) 
		{
			this.name = name;
			this.sound = sound;
			this.playing = false;
		}
		
	}

}