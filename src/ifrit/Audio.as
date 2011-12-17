package ifrit 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import com.thaumaturgistgames.flakit.Library;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Audio extends Sound
	{
		public var Sfx:Vector.<SoundEffect> = new Vector.<SoundEffect>;
		public var Songs:Vector.<Music> = new Vector.<Music>;
		
		public static var isMuted:Boolean;
		public static var canMute:Boolean;
		private static var muteCooldown:Timer = new Timer(100, 10);
		
		public function Audio()
		{
			Game.stage.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		protected function update():void	{ }
		
		public function mute():void
		{
			for each (var sfx:SoundEffect in this.Sfx)
			{
				if (sfx.channel)
				{
					sfx.transform.volume = 0;
				}
			}
			
			for each (var song:Music in this.Songs)
			{
				if (song.channel)
				{
					song.transform.volume = 0;
				}
			}
			
			Audio.isMuted = true;
			Audio.muteCooldown.start();
		}
		
		public function unmute():void
		{
			if (Audio.muteCooldown.currentCount >= 10)
			{
				//TODO: Doesn't work yet
				for each (var sfx:SoundEffect in this.Sfx)
				{
					if (sfx.transform)
					{
						sfx.transform.volume = 1;
					}
				}
				
				for each (var song:Music in this.Songs)
				{
					if (song.transform)
					{
						song.transform.volume = 1;
					}
				}
				
				Audio.isMuted = false;
				Audio.muteCooldown.stop();
				Audio.muteCooldown.reset();
			}
		}
		
		public function stopSFX(name:String):void
		{
			for each (var item:SoundEffect in Sfx) 
			{
				if (item.name == name)
				{
					if (item.playing)
					{
						item.channel.stop();
						item.playing = false;
						return;
					}
				}
			}
		}
		
		public function sfxIsPlaying(name:String):Boolean
		{
			for each (var item:SoundEffect in Sfx)
			{
				if (item.name == name)	return item.playing;
			}
			return false;
		}
		
		public function addSFX(name:String, data:Sound):void
		{
			for each (var item:SoundEffect in Sfx) 
			{
				if (item.name == name)
				{
					throw new Error("A sound effect with the name '" + name  +"' already exists.");
					return;
				}
			}
			
			var newSfx:SoundEffect = new SoundEffect(name, data);
			
			if (newSfx)
			{
				this.Sfx.push(newSfx);
			}
		}
		
		public function playSFX(name:String, loops:Number = 0, startTime:Number = 0):void
		{
			for each (var item:SoundEffect in Sfx) 
			{
				if (item.name == name)
				{
					if (!item.playing && !Audio.isMuted)
					{
						item.channel = item.sound.play(startTime, loops);
						item.playing = true;
						return;
					}
				}
			}
		}
		
		public function addMusic(name:String, data:Sound):void
		{
			for each (var item:Music in Songs) 
			{
				if (item.name == name)
				{
					throw new Error("A song with the name '" + name  +"' already exists.");
					return;
				}
			}
			
			var newMusic:Music = new Music(name, data);
			
			if (newMusic)
			{
				this.Songs.push(newMusic);
			}
		}
		
		/**
		 * Call a Music Sound by name to be played
		 * @param	name		Name of the Sound to be played
		 * @param	loops		Number of times to loop the Sound
		 * @param	startTime	Millisecond position to begin playback of the Sound
		 */
		public function playMusic(name:String, loops:Number = 0, startTime:Number = 0):void
		{
			for each (var item:Music in Songs) 
			{
				if (item && item.name == name)
				{
					if (!item.playing && !Audio.isMuted)
					{
						item.channel = item.sound.play(startTime, loops);
						item.playing = true;
					}
				}
				
				if ( item && item.name != name)
				{
					if (item.playing)
					{
						stopMusic(item.name);
					}
				}
			}
		}
		
		public function stopMusic(name:String):void
		{
			for each (var item:Music in Songs) 
			{
				if (item.name == name)
				{
					if (item.channel && item.playing)
					{
						item.playing = false;
						item.channel.stop();
					}
					return;
				}
			}
		}
		
		public function musicIsPlaying(name:String):Boolean
		{
			for each (var item:Music in Songs)
			{
				if (item.name == name)	return item.playing;
			}
			return false;
		}
		
		private function enterFrame(e:Event):void 
		{
			update();
			//if (muteCooldown)	trace(muteCooldown.currentCount);
		}
	}

}