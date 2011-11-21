package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * @author Jake Albano
	 */
	public class Enemy extends Mob 
	{
		//	Which way the enemy patrols
		//	If true, right, else left
		public var heading:Boolean;
		public var lastHeading:Boolean;
		public var fleeMode:Boolean;
		
		private var rightBound:Number;
		private var leftBound:Number;
		private var lastPosition:Point;
		private var speed:Number;
		private var confusionTimer:Timer;
		private var fleeCooldown:Timer;
		private var pickup:Pickup;
		
		private var homeRect:Rectangle;
		
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
			this.homeRect = new Rectangle;
			
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
			
			if (this.pickup)	this.checkPickup();
			
			if (isDestroyed) 	return;
			
			this.testHealth();
			
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
			
			//	Only drop pickups some of the time
			if (new Boolean(Math.round(Math.random() + 0.3)))
			{
				if (Game.man.type == Player.MAGE)
				{
					addChild(this.pickup = new Pickup(this.x, this.y, new Boolean(Math.round(Math.random()))));
				}
				else
				{
					addChild(this.pickup = new Pickup(this.x, this.y, true));
				}
			}
			
			this.collisionHull.x += this.collisionHull.width * 1.5;
		}
		
		/**
		 * Check if the dropped pickup is colliding with the player or if pickup lifetime is reached.
		 */
		private function checkPickup():void
		{
			if (this.pickup.alpha < 1)	this.pickup.alpha -= 0.1;
			
			if (this.pickup.alpha <= 0)
			{
				this.pickup.parent.removeChild(this.pickup);
				this.pickup = null;
			}
			else if (this.pickup.hitTestObject(Game.man.collisionHull))
			{
				if (this.pickup.type) 	HUD.healPlayer(10, true);
				else 					HUD.restoreMana(25);
				
				this.pickup.parent.removeChild(this.pickup);
				this.pickup = null;
			}
			else if (this.pickup.lifetime == 270)
			{
				this.pickup.alpha = 0.9;
			}
			
			
		}
		
		/**
		 * AI synapse
		 * Check health and destroy enemy if below 0
		 */
		private function testHealth():void
		{
			if (this.hitpoints <= 0 && !isDestroyed)	this.destroy();
			else if (this.hitpoints <= this.maxHealth)	this.hitpoints += 0.05
		}
		
		/**
		 * AI synapse
		 * Search the platform list and decide which platform, if any, to restrict movement to
		 */
		private function findPlatform():void
		{
			if (homeRect.contains(Game.man.x, Game.man.y) || !homeRect.contains(this.x, this.y) || this.lastHeading != this.heading)
			{			
				var found:Boolean = false;
				var collision:Boolean = false;
				
				for (var i:int = 0; i < World.Platforms.length; i++) 
				{
					if (World.Platforms[i].collide(this) && World.Platforms[i].rotation == 0 && World.Platforms[i].y > this.y)
					{
						collision = true;
						leftBound = World.Platforms[i].x - World.Platforms[i].width / 2;
						rightBound = World.Platforms[i].x + World.Platforms[i].width / 2;
						found = true;
						
						var li:int = -1;
						var ri:int = -1;

						
						for (var ii:int = 0; ii < World.Platforms.length; ii++)
						{
							if (li == ii || ri == ii || i == ii)		continue;
							
							if (World.Platforms[ii].y != World.Platforms[i].y) continue;
							
							var distance:int = Math.abs(World.Platforms[ii].x - World.Platforms[i].x) ;
							
							if (World.Platforms[ii].x < World.Platforms[i].x)	//	Platform is to the left
							{								
								if (distance <= 215)	//	Enemies can pass over a 15 pixel gap without turning
								{
									li = ii;
									leftBound = World.Platforms[ii].x - World.Platforms[ii].width / 2;
								}
								continue;
							}
							else if (World.Platforms[ii].x > World.Platforms[i].x)	//	Platform is to the right
							{
								if (distance <= 215)	//	Enemies can pass over a 15 pixel gap without turning
								{
									ri = ii;
									rightBound = World.Platforms[ii].x + World.Platforms[ii].width / 2;
								}
								continue;
							}
						}
						
						break;
					}
				}
				
				if (!found)
				{
					this.leftBound = 0;
					this.rightBound = Game.dimensions.x;
				}
				
				if (collision)
				{
					this.homeRect.height = 60;
					this.homeRect.width = 300;
					this.homeRect.x = this.heading ? this.x - 100 : this.x - 200;
					this.homeRect.y = this.y - 30;
					
					/**
					 * Uncomment to see debugging view for search rectangle
					 * Warning: Creates a huge amount of sprites when AI is in chase mode
					 */
					var r:Sprite = new Sprite;
					r.graphics.beginFill(0x00ffff, 0.1);
					r.graphics.drawRect(this.homeRect.x, this.homeRect.y, this.homeRect.width, this.homeRect.height);
					r.graphics.endFill();
					Game.stage.addChild(r);
				}
			}
		}
		
		/**
		 * AI synapse
		 * Turn around if the edge of a platform is reached or an obstacle is struck
		 */
		private function adjustHeading():void
		{
			this.lastHeading = heading;
			
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
			if (!fleeMode)
			{
				if (this.homeRect.contains(Game.man.x, Game.man.y) && Game.man.y <= this.y)
				{
					if (this.x >= Game.man.x) heading = false;	else heading = true;
					if (heading)	{	if (Game.man.x > this.x && this.rotationY == 0) this.attack();	}
					else			{	if (Game.man.x < this.x && this.rotationY == 180) this.attack();	}
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
					if (Game.man.x > this.x && this.homeRect.contains(Game.man.x, Game.man.y)) this.shoot();
					this.x += 5;
				}
				else
				{
					if (Game.man.x < this.x && this.homeRect.contains(Game.man.x, Game.man.y)) this.shoot();
					x -= 5;
				}
				
			}
			else
			{
				if (heading) this.x += 1 + this.speed;  else x -= 1 + speed;
			}
		}
		
		private function attack():void
		{
			if (Point.distance(new Point(this.x, this.y), new Point(Game.man.x, Game.man.y)) > 25)
			{
				shoot();
			}
			else
			{
				stab();
			}
		}		
		
	}

}