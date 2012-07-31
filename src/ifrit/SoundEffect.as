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
		public var channel:SoundChannel;
		public var transform:SoundTransform;
		
		public var name:String;
		
		private var position:Number;
		private var count:uint;
		
		public function SoundEffect(name:String, sound:Sound) 
		{
			this.transform = new SoundTransform;
			this.name = name;
			this.sound = sound;
			this.position = -1;
			this.count = 0;
		}
		
		public function get playing():Boolean
		{
			if (!this.channel)
			{
				return false;
			}
			
			if (!this.sound)
			{
				return false;
			}
			
			return (this.channel.position > 0 && this.channel.position < this.sound.length);
		}
	}

}