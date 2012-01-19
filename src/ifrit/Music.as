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
		public var transform:SoundTransform = new SoundTransform;
		
		public var name:String;
		public var playing:Boolean;
		
		private var position:Number;
		private var count:uint;
		
		public function Music(name:String, sound:Sound) 
		{
			this.sound = sound;
			this.name = name;
			this.position = -1;
			this.count = 0;
		}
		
		override protected function update():void
		{
			super.update();
			
			if (this.channel)
			{
				this.channel.soundTransform = this.transform;
				
				if (this.count % 10 == 0)
				{
					if (this.channel.position > 0)
					{
						if (this.position < this.channel.position)
						{
							this.playing = true;
							this.position = this.channel.position;
						}
						else
						{
							this.playing = false;
						}
					}
				}
				count++;
			}
		}
		
	}

}