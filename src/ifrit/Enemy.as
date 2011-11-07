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
		public var fleeMode:Boolean;
		
		private var rightBound:Number;
		private var leftBound:Number;
		private var lastPosition:Point;
		private var speed:Number;
		private var confusionTimer:Timer;
		private var fleeCooldown:Timer;
		
		public function Enemy(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("enemy.png"), 13, 23, 13, 23 );
			this.lastPosition = new Point(x, y);
			this.heading = true;
			this.fleeMode = false;
			this.heading = Boolean(Math.round(Math.random()));
			this.speed = Math.random();
			this.hitpoints = 10;
			this.maxHealth = 10;
			this.confusionTimer = new Timer(1000, 0);
			this.fleeCooldown = new Timer(1000, 0);
		}
		
		/**
		 * 
		 */
		override public function think():void 
		{
			super.think();
			
			this.findPlatform();
			
			this.beginFlee();
			
			this.endFlee();
			
			this.adjustHeading();
			
			this.move();
		}
		
		/**
		 * AI synapse
		 * Search the platform list and decide which platform, if any, to restrict movement to
		 */
		private function findPlatform():void
		{
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
		}
		
		/**
		 * AI synapse
		 * Test if hitpoints are at the panic level and begin the flee procedure
		 */
		private function beginFlee():void
		{
			if ( this.hitpoints <= this.maxHealth / 2 && !fleeMode)
			{
				fleeMode = true;
				if (this.x <= Game.man.x) heading = false;	else heading = true;
				this.fleeCooldown.start();
			}
		}
		
		/**
		 * AI synapse
		 * Regenerate hitpoints if enough time has gone by and end the flee procedure
		 */
		private function endFlee():void
		{
			if (this.fleeCooldown.currentCount >= 4)
			{
				this.fleeMode = false;
				this.fleeCooldown.stop();
				this.fleeCooldown.reset();
				this.hitpoints = this.maxHealth;
			}
		}
		
		/**
		 * AI synapse
		 * Turn around if the edge of a platform is reached or an obstacle is struck
		 */
		private function adjustHeading():void
		{
			if (heading)	{	if (this.x <= this.lastPosition.x) heading = !heading;	}
			else			{ 	if (this.x >= this.lastPosition.x) heading = !heading;	}
			
			if (!fleeMode)
			{
				if (this.x >= this.rightBound) heading = false;
				else if (this.x <= this.leftBound) heading = true;
			}
		}
		
		/**
		 * AI synapse
		 * Update movement
		 */
		private function move():void
		{
			this.lastPosition.x = this.x;
			
			this.rotationY = this.heading ? 0 : 180;
			
			if (fleeMode)
			{
				if (heading) this.x += 5;  else x -= 5;
			}
			else
			{
				if (heading) this.x += 1 + this.speed;  else x -= 1 + speed;
			}
		}
		
		
	}

}