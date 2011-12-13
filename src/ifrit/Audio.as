package ifrit 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Audio extends Sound
	{
		public var Sfx:Vector.<SoundEffect> = new Vector.<SoundEffect>;
		public var Songs:Vector.<Music> = new Vector.<Music>;
		
		public function Audio()
		{
			Game.stage.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		protected function update():void	{ }
		
		public function stopSFX(name:String):void
		{
			for each (var item:SoundEffect in Sfx) 
			{
				if (item.name == name)
				{
					item.channel.stop();
					item.playing = false;
					return;
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
			
			this.Sfx.push(new SoundEffect(name, data) );
		}
		
		public function playSFX(name:String, loops:Number = 0, startTime:Number = 0):void
		{
			for each (var item:SoundEffect in Sfx) 
			{
				if (item.name == name)
				{
					if (!item.playing)
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
			
			this.Songs.push(new Music(name, data) );
		}
		
		public function playMusic(name:String, loops:Number = 0, startTime:Number = 0):void
		{
			for each (var item:Music in Songs) 
			{
				if (item.name == name)
				{
					if (!item.playing)
					{
						trace("play ", item.name);
						item.channel = item.sound.play(startTime, loops);
						item.playing = true;
					}
				}
				
				if (item.name != name)
				{
					if (item.playing)
					{
						trace("stop ", item.name);
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
					if (item.channel && item.playing)	item.channel.stop();
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
		}
	}

}