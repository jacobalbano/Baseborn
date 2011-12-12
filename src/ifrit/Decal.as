package ifrit 
{
	
	import flash.display.Bitmap;
	import com.jacobalbano.Animation;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * @author Jake Albano
	 */
	public class Decal extends IfritObject 
	{
		public var lastPosition:Point;
		public var animation:Animation;
		public var inMotion:Boolean;
		
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
			var container:Sprite = new Sprite;
			addChild(container);
			
			if (frames)
			{
				this.animation = new Animation(bitmap, frameWidth, frameHeight);
				container.addChild(this.animation);
				animation.add("animation", frames, frameRate, loop);
				animation.play("animation");
				
				container.x = -frameWidth /2;
				container.y = -frameHeight /2;
			
				this.x = x;
				this.y = y;
			}
			else
			{
				this.animation = new Animation(bitmap, bitmap.width, bitmap.height);
				container.addChild(this.animation);
				
				container.x = -this.animation.width /2;
				container.y = -this.animation.height /2;
			
				this.x = x;
				this.y = y;
			}
			
			this.lastPosition = new Point(this.x, this.y);
			
			if (callback != null)
			{
				this.callback = callback;
			}
		}
		
		override protected function update():void 
		{
			super.update();
			
			if (this.x == this.lastPosition.x && this.y == this.lastPosition.y)
				this.inMotion = false;
			else
				this.inMotion = true;
			
			this.lastPosition.x = this.x;
			this.lastPosition.y = this.y;
			
			if (this.callback != null)	this.callback(this);
		}
		
	}

}