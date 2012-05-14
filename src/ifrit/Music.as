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
		public var sound:Sound;
		public var channel:SoundChannel;
		public var transform:SoundTransform;
		
		public var name:String;
		public var playing:Boolean;
		
		private var position:Number;
		private var count:uint;
		
		public function Music(name:String, sound:Sound) 
		{
			this.name = name;
			this.sound = sound;
			this.position = -1;
			this.count = 0;
			this.transform = new SoundTransform;
		}		
	}

}