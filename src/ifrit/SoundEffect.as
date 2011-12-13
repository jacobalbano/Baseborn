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
		private var position:Number;
		private var count:uint;
		
		public function SoundEffect(name:String, sound:Sound) 
		{
			this.name = name;
			this.sound = sound;
			this.position = -1;
			this.count = 0;
		}
		
		override protected function update():void
		{
			super.update();
			
			if (this.channel)
			{
				if (this.count % 2 == 0)
				{
					if (this.channel.position > 0)
					{
						if (this.position < this.channel.position)
						{
							this.playing = true;
							this.position = this.channel.position;
						}
						else	this.playing = false;
					}
				}
				count++;
			}
		}
		
	}

}