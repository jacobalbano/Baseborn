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
		public var animation:Animation;
		
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
		public function Decal(bitmap:Bitmap, x:Number, y:Number, callback:Function = null, frames:Array = null, frameWidth:Number = 0, frameHeight:Number = 0, frameRate:Number = 0, loop:Boolean = true ) 
		{
			if (frames)
			{
				this.animation = new Animation(bitmap, frameWidth, frameHeight);
				animation.add("animation", frames, frameRate, loop);
				animation.play("animation");
				animation.x = x - animation.width / 2;
				animation.y = y - animation.height / 2;
				addChild(this.animation);
			}
			else
			{
				this.animation = new Animation(bitmap, bitmap.width, bitmap.height);
				animation.x = x - animation.width / 2;
				animation.y = y - animation.height / 2;
				addChild(this.animation);
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