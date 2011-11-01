package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.geom.Point;
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.Timer;
	
	/**
	 * @author Jake Albano
	 */
	public class Enemy extends Mob 
	{
		//	Which way the enemy patrols
		//	If true, right, else left
		public var heading:Boolean;
		private var rightBound:Number;
		private var leftBound:Number;
		private var lastPosition:Point;
		private var speed:Number;
		
		public function Enemy(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("mage.png") );
			this.lastPosition = new Point(x, y);
			this.heading = true;
			this.heading = Boolean(Math.round(Math.random()));
			this.speed = Math.random();
		}
		
		/**
		 * 
		 */
		override public function think():void 
		{
			super.think();
			this.rotationY = this.heading ? 0 : 180;
			
			var found:Boolean = false;
			for (var i:int = 0; i < Game.Platforms.length; i++) 
			{
				if (Game.Platforms[i].collide(this) && Game.Platforms[i].rotation == 0)
				{
					leftBound = Game.Platforms[i].x + this.width / 2 - Game.Platforms[i].width / 2;
					rightBound = Game.Platforms[i].x - this.width / 2 + Game.Platforms[i].width / 2;
					found = true;
					break;
				}
			}
			
			if (!found)
			{
				this.leftBound = 0;
				this.rightBound = stage.stageWidth;
			}
			
			if (this.x == this.lastPosition.x) heading = !heading;
			else if (this.x >= this.rightBound) heading = false;
			else if (this.x <= this.leftBound) heading = true;
			
			this.lastPosition.x = this.x;
			
			if (heading) this.x += 1;  else x -= 1;
		}
		
	}

}