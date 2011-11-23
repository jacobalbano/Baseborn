package ifrit 
{
	
	import flash.display.Bitmap;
	import com.jacobalbano.Animation;
	import flash.display.Sprite;
	
	/**
	 * @author Jake Albano
	 */
	public class Decal extends IfritObject 
	{
		
		private var callback:Function;
		/**
		 * Simple static or animated sprite
		 * @param	bitmap			The source image to use
		 * @param	x				Position on x
		 * @param	y				Position on y
		 * @param	callback		Callback function reference
		 * @param	frames			If the decal is animated, specify frames
		 * @param	frameWidth		Width of animation frames
		 * @param	frameHeight		Height of animation frames
		 */
		public function Decal(bitmap:Bitmap, x:Number, y:Number, callback:Function = null, frames:Array = null, frameWidth:Number = 0, frameHeight:Number = 0, loop:Boolean = true ) 
		{
			if (frames)
			{
				var a:Animation = new Animation(bitmap, frameWidth, frameHeight);
				a.add("animation", frames, 5, loop);
				a.play("animation");
				a.x = x - a.width / 2;
				a.y = y - a.height / 2;
				Game.stage.addChild(a);
			}
			else
			{
				var s:Sprite = new Sprite;
				s.addChild(bitmap);
				s.x = x - s.width / 2;
				s.y = y - s.height / 2;
				addChild(s);
			}
			
			if (callback != null)
			{
				this.callback = callback;
			}
		}
		
		override protected function update():void 
		{
			super.update();
			
			if (this.callback != null)	this.callback(this);
		}
		
	}

}