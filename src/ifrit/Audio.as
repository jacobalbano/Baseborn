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
		
		protected function update():void	{}
		
		public function mute():void
		{
			if ((muteCooldown.currentCount >= 10 && !isMuted) || !muteCooldown.running)
			{
				for each (var sfx:SoundEffect in this.Sfx)
				{	if (sfx.channel)	sfx.transform.volume = 0;	}
				
				for each (var song:Music in this.Songs)
				{	if (song.channel)	song.transform.volume = 0;	}
				
				isMuted = true;
				muteCooldown.stop();
				muteCooldown.reset();
				muteCooldown.start();
			}
		}
		
		public function unmute():void
		{	
			if (muteCooldown.currentCount >= 10 && isMuted)
			{
				for each (var sfx:SoundEffect in this.Sfx)
				{	if (sfx.channel && sfx.transform)	sfx.transform.volume = 1;	}
				
				for each (var song:Music in this.Songs)
				{	if (song.channel && song.transform)	song.transform.volume = 1;	}
				
				isMuted = false;
				muteCooldown.stop();
				muteCooldown.reset();
				muteCooldown.start();
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
						if (item.channel)
						{
							item.channel.stop();
						}
						
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
			
			if (newSfx)	this.Sfx.push(newSfx);
		}
		
		public function playSFX(name:String, loops:Number = 0, startTime:Number = 0):void
		{
			for each (var item:SoundEffect in Sfx) 
			{
				if (item.name == name)
				{
					if (item.playing)	return;
					else
					{
						if (!isMuted)
						{
							item.channel = item.sound.play(startTime, loops);
							item.playing = true;
							return;
						}
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
			
			if (newMusic)	this.Songs.push(newMusic);
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
					if (!item.playing)
					{
						if (isMuted)	item.transform.volume = 0;
						
						item.channel = item.sound.play(startTime, loops, item.transform);
						item.playing = true;
					}
				}
				
				if ( item && item.name != name)
				{
					if (item.playing)	stopMusic(item.name);
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
		
		/**
		 * Stops all currently playing sounds and songs.
		 * @param	exception	Array of names of songs or sounds to NOT stop.
		 */
		public function stopAll(exception:Array = null):void
		{
			if (exception)
			{
				for (var a:int = Sfx.length - 1; a >= 0; a--)
				{
					for (var aa:int = Songs.length - 1; aa >= 0; aa--)
					{
						for (var aaa:int = exception.length - 1; aaa >= 0; aaa--)
						{
							if ((Sfx[a].name != exception[aaa]) && Songs[aa].name != exception[aaa])
							{
								if (Sfx[a].channel)		Sfx[a].channel.stop();
								if (Songs[aa].channel)	Songs[aa].channel.stop();
							}
						}
					}
				}
			}
			else
			{
				for each (var sfx:SoundEffect in this.Sfx)
				{
					if (sfx.channel)
					{
						sfx.channel.stop();
						sfx.playing = false;
					}
				}
					
				for each (var song:Music in this.Songs)
				{
					if (song.channel)
					{
						song.channel.stop();
						song.playing = false;
					}
				}
			}
		}
		
		public function fadeOut(name:String):void
		{
			for each (var sfx:SoundEffect in Sfx)
			{
				if (sfx.name == name)
				{
					if (sfx.channel)
					{
						if (sfx.transform.volume > 0)	sfx.transform.volume -= 0.015;
						if (sfx.transform.volume <= 0)	sfx.stopSFX(sfx.name);
					}
				}
			}
			
			for each (var song:Music in Songs)
			{
				if (song.name == name)
				{
					if (song.channel)
					{
						if (song.transform.volume > 0)	song.transform.volume -= 0.015;
						if (song.transform.volume <= 0)	song.stopMusic(song.name);
					}
				}
			}
		}
		
		private function enterFrame(e:Event):void 
		{
			update();
		}
	}

}