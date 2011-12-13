package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * @author Jake Albano
	 */
	public class Enemy extends Mob 
	{
		public static var NO_FEAR:uint = 1;
		public static var NO_MELEE:uint = 2;
		public static var NO_RANGED:uint = 4;
		public static var FLYING:uint = 8;
		public static var PASSIVE:uint = 16;
		public static var AFRAID:uint = 32;
		public static var BRAIN_DEAD:uint = 64;
		
		public var brainDead:Boolean;
		public var heading:Boolean;
		public var lastHeading:Boolean;
		public var fleeMode:Boolean;
		
		protected var behaviorFlags:uint;
		protected var tipsOverWhenDead:Boolean;	//	Ultra stupid variable name
		protected var rightBound:Number;
		protected var leftBound:Number;
		protected var lastPosition:Point;
		protected var speed:Number;
		protected var confusionTimer:Timer;
		protected var fleeCooldown:Timer;
		protected var pickup:Pickup;
		
		private var homeRect:Rectangle;
		
		public function Enemy(x:Number, y:Number, bitmap:Bitmap, frameWidth:int, frameHeight:int, collisionWidth:int, collisionHeight:int, behaviorFlags:uint = 0) 
		{
			super(x, y, bitmap, frameWidth, frameHeight, collisionWidth, collisionHeight);
			
			this.lastPosition = new Point(x, y);
			
			this.behaviorFlags = behaviorFlags;
			
			if ( (this.behaviorFlags & FLYING) > 0)		this.hasGravity = false;
			if ( (this.behaviorFlags & BRAIN_DEAD) > 0)	this.brainDead = true;
			
			this.heading = true;
			this.fleeMode = false;
			this.heading = Boolean(Math.round(Math.random()));
			this.speed = Math.random();
			this.confusionTimer = new Timer(1000, 0);
			this.fleeCooldown = new Timer(1000, 0);
			this.homeRect = new Rectangle;
			this.tipsOverWhenDead = true;
		}
		
		override public function preThink():void 
		{
			super.preThink();
			
			if (freezeTimer)
			{
				if (this.freezeTimer.currentCount >= 3)
				{
					this.freezeTimer.stop();
					this.frozen = false;
					this.struck = false;
				}
				
				if (this.freezeTimer.running)
				{
					this.graphic.play("stand");
					skipThink = true;
				}
			}
		}
		
		override public function think():void 
		{
			super.think();
			
			this.checkPickup();
			
			if (this.brainDead)	return;
			
			this.testHealth();
			
			if (isDestroyed) 	return;
			
			this.findPlatform();
			
			this.adjustHeading();
			
			this.beginOffense();
			
			this.beginFlee();
			
			this.endFlee();
			
			this.move();
		}
		
		override public function destroy():void 
		{
			if (this.isDestroyed) return;
			super.destroy();
			
			this.graphic.play("die");
			
			if ( ! (this.behaviorFlags & PASSIVE) > 0)
			{
				var enemiesKilled:int = 0;
				
				for (var w:int = 0; w < World.Mobs.length; w++)
				{
					if (World.Mobs[w].hitpoints <= 0)
					{
						enemiesKilled++;
					}
				}
				
				if (World.hasKey && enemiesKilled == World.Mobs.length)
				{
					addChild(this.pickup = new Pickup(this.x, this.y, Pickup.KEY));
				}
				else
				{
					//Only drop pickups some of the time
					if (new Boolean(Math.round(Math.random() + 0.3)))
					{
						if (Game.man.type == Player.MAGE)
						{
							var typeM:uint = new Boolean(Math.round(Math.random())) ? Pickup.HEALTH : Pickup.MANA;
							addChild(this.pickup = new Pickup(this.x, this.y, typeM));
						}
						else if (Game.man.type == Player.FIGHTER)
						{
							if (HUD.ammoCount <= 0.5)
							{
								var typeF:uint = new Boolean(Math.round(Math.random())) ? Pickup.HEALTH : Pickup.ARROW;
								addChild(this.pickup = new Pickup(this.x, this.y, typeF));
							}
							else	addChild(this.pickup = new Pickup(this.x, this.y, Pickup.HEALTH));
						}
						else if (Game.man.type == Player.ROGUE)
						{
							if (HUD.ammoCount <= 0.5)
							{
								var typeR:uint = new Boolean(Math.round(Math.random())) ? Pickup.HEALTH : Pickup.SHURIKEN;
								addChild(this.pickup = new Pickup(this.x, this.y, typeR));
							}
							else	addChild(this.pickup = new Pickup(this.x, this.y, Pickup.HEALTH));
						}
					}
				}
			}
			
			if (this.tipsOverWhenDead)	this.collisionHull.x += this.collisionHull.width * 1.5;
		}
		
		/**
		 * Check if the dropped pickup is colliding with the player or if pickup lifetime is reached.
		 */
		private function checkPickup():void
		{
			if (!this.pickup)	return;
			
			if (this.pickup.alpha < 1)	this.pickup.alpha -= 0.1;
			
			if (this.pickup.alpha <= 0)
			{
				this.pickup.parent.removeChild(this.pickup);
				this.pickup = null;
			}
			else if (!Game.man.isDestroyed && this.pickup.hitTestObject(Game.man.collisionHull))
			{
				if 		(this.pickup.type == Pickup.HEALTH) 	HUD.healPlayer(10, true);
				else if (this.pickup.type == Pickup.MANA)		HUD.restoreMana(25);
				else if (this.pickup.type == Pickup.KEY)		Game.man.hasKey = true;
				else if (this.pickup.type == Pickup.ARROW)		HUD.restoreAmmo(1);
				else if (this.pickup.type == Pickup.SHURIKEN)	HUD.restoreAmmo(1);
				
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
			if (this.lastHeading != this.heading || (!Game.man.isDestroyed && homeRect.contains(Game.man.x, Game.man.y)) || !homeRect.contains(this.x + homeRect.width / 3, this.y) || !homeRect.contains(this.x - homeRect.width / 3, this.y))
			{			
				var found:Boolean = false;
				var collision:Boolean = false;
				
				if ( ! ( this.behaviorFlags & FLYING) > 0)
				{
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
									if (distance <= 210)	//	Enemies can pass over a 10 pixel gap without turning
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
				}
				
				if (!found || (this.behaviorFlags & FLYING) > 0 )
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
					//var r:Sprite = new Sprite;
					//r.graphics.beginFill(0x00ffff, 0.1);
					//r.graphics.drawRect(this.homeRect.x, this.homeRect.y, this.homeRect.width, this.homeRect.height);
					//r.graphics.endFill();
					//Game.stage.addChild(r);
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
				
				if (this.homeRect.contains(Game.man.x, Game.man.y) && !Game.man.isDestroyed && Game.man.y <= this.y + this.height / 2)
				{
					this.sound.playSFX("attack");
					
					if ( ! (this.behaviorFlags & PASSIVE) > 0)
					{
						if (this.x >= Game.man.x) heading = false;	else heading = true;
						if (heading)	{	if (Game.man.x > this.x && this.rotationY == 0) this.attack();	}
						else			{	if (Game.man.x < this.x && this.rotationY == 180) this.attack();	}
					}
					
					if ( (this.behaviorFlags & AFRAID) > 0)
					{
						fleeMode = true;
						if (this.x <= Game.man.x) heading = false;	else heading = true;
						
						this.fleeCooldown.stop();
						this.fleeCooldown.reset();
						this.fleeCooldown.start();
					}
				}
			}
		}
		
		/**
		 * AI synapse
		 * Test if hitpoints are at the panic level and begin the flee procedure
		 */
		private function beginFlee():void
		{
			if ( ! (behaviorFlags & NO_FEAR) > 0)
			{
				if ( this.hitpoints <= this.maxHealth / 2 && !fleeMode)
				{
					fleeMode = true;
					
					fleeMode = true;

					if (this.homeRect.contains(Game.man.x, Game.man.y))
					{
						if (this.x <= Game.man.x) heading = false;	else heading = true;
					}
					else
					{
						this.heading = !this.heading;
					}
					
					this.fleeCooldown.start();
				}
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
			if (this.graphic.playing != "shocked" && this.graphic.playing != "die" && this.graphic.playing != "attack")	this.graphic.play("walk");
			
			this.lastPosition.x = this.x;
			this.lastPosition.y = this.y;
			
			this.rotationY = this.heading ? 0 : 180;
			
			if (fleeMode)
			{
				
				if (heading)
				{
					if (Game.man.x > this.x && !Game.man.isDestroyed && this.homeRect.contains(Game.man.x, Game.man.y) && (this.behaviorFlags & NO_RANGED) <= 0) this.shoot();
					this.x += 5;
				}
				else
				{
					if (Game.man.x < this.x && !Game.man.isDestroyed && this.homeRect.contains(Game.man.x, Game.man.y) && (this.behaviorFlags & NO_RANGED) <= 0) this.shoot();
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
			if ( !Game.man.isDestroyed)
			{
				if (Point.distance(new Point(this.x, this.y), new Point(Game.man.x, Game.man.y)) > this.width )
				{
					if (! (behaviorFlags & NO_RANGED) > 0 )	
					{
						shoot();
					}
				}
				else
				{
					if (! (behaviorFlags & NO_MELEE) > 0 )
					{
						this.graphic.play("attack");
						stab();
					}
				}
			}
		}		
		
	}

}