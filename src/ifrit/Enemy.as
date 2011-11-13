package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	import flash.geom.Point;
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
		private var platformIndex:int;
		private var lastPosition:Point;
		private var speed:Number;
		private var confusionTimer:Timer;
		private var fleeCooldown:Timer;
		
		public function Enemy(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("enemy.png"), 60, 23, 13, 23 );
			this.lastPosition = new Point(x, y);
			this.heading = true;
			this.fleeMode = false;
			this.heading = Boolean(Math.round(Math.random()));
			this.speed = Math.random();
			this.hitpoints = 15;
			this.maxHealth = 15;
			this.confusionTimer = new Timer(1000, 0);
			this.fleeCooldown = new Timer(1000, 0);
			
			this.graphic.add("stand", [0], 6, true);
			this.graphic.add("walk", [0, 1, 2, 3], 6, true);
			this.graphic.add("die", [6, 7, 8, 9], 6, false);
			this.graphic.add("shocked", [10, 11, 12, 13], 6, false);
			this.graphic.play("walk");
		}
		
		/**
		 * 
		 */
		override public function think():void 
		{
			super.think();
			
			this.testHealth();
			
			if (isDestroyed) return;
			
			this.findPlatform();
			
			this.adjustHeading();
			
			this.beginOffense();
			
			this.beginFlee();
			
			this.endFlee();
			
			this.move();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			this.graphic.play("die");
			if (HUD.health.width <= 170) HUD.health.width += 30;
			else HUD.health.width += 200 - HUD.health.width;
		}
		
		/**
		 * AI synapse
		 * Check health and destroy enemy if below 0
		 */
		private function testHealth():void
		{
			if (this.hitpoints <= 0 && !isDestroyed)	this.destroy();
			if (this.isDestroyed && this.graphic.playing != "die")
			{
				this.comeToRest();
				this.removeChild(collisionHull);
			}
		}
		
		/**
		 * AI synapse
		 * Search the platform list and decide which platform, if any, to restrict movement to
		 */
		private function findPlatform():void
		{
			var found:Boolean = false;
			for (var i:int = 0; i < World.Platforms.length; i++) 
			{
				if (World.Platforms[i].collide(this) && World.Platforms[i].rotation == 0)
				{
					leftBound = World.Platforms[i].x - World.Platforms[i].width / 2;
					rightBound = World.Platforms[i].x + World.Platforms[i].width / 2;
					found = true;
					this.platformIndex = i;
					break;
				}
			}
			
			if (!found)
			{
				this.leftBound = 0;
				this.rightBound = Game.dimensions.x;
				this.platformIndex = -1;
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
		 * Attepmt to attack player if on the same platform
		 */
		private function beginOffense():void
		{
			if (this.platformIndex >= 0 && !fleeMode)
			{
				if (World.Platforms[this.platformIndex].collide(Game.man) && Game.man.y < World.Platforms[platformIndex].y)
				{
					if (this.x >= Game.man.x) heading = false;	else heading = true;
					if (heading)	{	if (Game.man.x > this.x) this.shoot();	}
					else			{	if (Game.man.x < this.x) this.shoot();	}
				}
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
		 * Update movement
		 */
		private function move():void
		{
			if (this.graphic.playing != "shocked" && this.graphic.playing != "die")	this.graphic.play("walk");
			
			this.lastPosition.x = this.x;
			this.lastPosition.y = this.y;
			
			this.rotationY = this.heading ? 0 : 180;
			
			if (fleeMode)
			{
				
				if (heading)
				{
					if (Game.man.x > this.x && platformIndex >= 0 && World.Platforms[this.platformIndex].collide(Game.man)) this.shoot();
					this.x += 5;
				}
				else
				{
					if (Game.man.x < this.x && platformIndex >= 0 && World.Platforms[this.platformIndex].collide(Game.man)) this.shoot();
					x -= 5;
				}
				
			}
			else
			{
				if (heading) this.x += 1 + this.speed;  else x -= 1 + speed;
			}
		}
		
		
	}

}