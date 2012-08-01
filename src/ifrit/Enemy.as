package ifrit
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * @author Jake Albano
	 */
	public class Enemy extends Mob
	{
		public static const NO_FEAR:uint = 1 << 0;
		public static const NO_MELEE:uint = 1 << 1;
		public static const NO_RANGED:uint = 1 << 2;
		public static const STAND_GROUND:uint = 1 << 3;
		public static const PASSIVE:uint = 1 << 4;
		public static const AFRAID:uint = 1 << 5;
		public static const BRAIN_DEAD:uint = 1 << 6;
		
		public var brainDead:Boolean;
		public var heading:Boolean;
		public var lastHeading:Boolean;
		public var fleeMode:Boolean;
		public var holdingGround:Boolean;
		public var attacking:Boolean;
		
		protected var behaviorFlags:uint;
		protected var tipsOverWhenDead:Boolean; //	Ultra stupid variable name
		protected var lastPosition:Point;
		protected var speed:Number;
		protected var confusionTimer:Timer;
		protected var fleeCooldown:Timer;
		protected var pickup:Pickup;
		
		private var homeRect:Rectangle;
		private var alertedThisFrame:Boolean;
		
		private const debug:Boolean = Game.DEBUG_MODE;
		private var homeRectDebug:Sprite;
		
		public var healthRect:Sprite;
		
		public function Enemy(x:Number, y:Number, bitmap:Bitmap, frameWidth:int, frameHeight:int, collisionWidth:int, collisionHeight:int, behaviorFlags:uint = 0)
		{
			super(x, y, bitmap, frameWidth, frameHeight, collisionWidth, collisionHeight);
			
			this.lastPosition = new Point(x, y);
			
			this.behaviorFlags = behaviorFlags;
			
			if ((this.behaviorFlags & BRAIN_DEAD) > 0)
				this.brainDead = true;
			
			this.heading = true;
			this.fleeMode = false;
			this.attacking = false;
			this.holdingGround = true;
			this.heading = Boolean(Math.round(Math.random()));
			this.speed = Math.random();
			this.confusionTimer = new Timer(1000, 0);
			this.fleeCooldown = new Timer(1000, 0);
			this.homeRect = new Rectangle;
			this.tipsOverWhenDead = true;
			
			if (!(this is Doppleganger) && !(this is Boss))
			{
				this.healthRect = new Sprite();
				Game.stage.addChild(healthRect);
			}
			
			Game.stage.addChild(this.homeRectDebug = new Sprite);
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
			
			if (this.healthRect)
			{
				var healthColor:Number = 0;
				
				if 		(this.hitpoints / this.maxHealth <= 0.25)	healthColor = 0xE13800;
				else if (this.hitpoints / this.maxHealth <= 0.50)	healthColor = 0xE19300;
				else if (this.hitpoints / this.maxHealth <= 0.75)	healthColor = 0xDCE100;
				else 												healthColor = 0x1EC600;
				
				if (this.isFrozen) healthColor = 0x00D9CE;
				
				this.healthRect.graphics.clear();
				this.healthRect.graphics.beginFill(healthColor);
				this.healthRect.graphics.drawRect(this.x, this.y, (this.hitpoints / this.maxHealth) * 40, 2.5);
				this.healthRect.graphics.endFill();
				this.healthRect.x = this.container.x + 2.5;
				this.healthRect.y = this.container.y - 5;
				
				this.healthRect.alpha =  75 / Math.max(Point.distance(new Point(Game.man.x, Game.man.y), new Point(this.x, this.y)), 1);
			}
		}
		
		override public function think():void
		{
			super.think();
			
			this.checkPickup();
			
			if (this.brainDead)
				return;
			
			this.testHealth();
			
			if (isDestroyed)
				return;
			
			this.updateView();
			
			this.adjustHeading();
			
			this.beginOffense();
			
			this.beginFlee();
			
			this.endFlee();
			
			this.move();
		}
		
		override public function destroy():void
		{
			if (this.isDestroyed)
				return;
			super.destroy();
			
			this.sound.playSFX("die");
			this.graphic.play("die");
			
			if (healthRect) Game.stage.removeChild(this.healthRect);
			
			if (!(this.behaviorFlags & PASSIVE) > 0)
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
					
					//	2/3 chance of dropping a pickup
					if (new Boolean(Math.round(Math.random() + 0.5)) && !(this is Boss))
					{
						if (HUD.ammoCount <= 0.5)
						{
							switch (Game.man.type)
							{
								case Player.MAGE: 
									addChild(this.pickup = new Pickup(this.x, this.y, new Boolean(Math.round(Math.random())) ? Pickup.HEALTH : Pickup.MANA));
									break;
								case Player.FIGHTER: 
									addChild(this.pickup = new Pickup(this.x, this.y, new Boolean(Math.round(Math.random() - 0.40)) ? Pickup.HEALTH : Pickup.ARROW));
									break;
								case Player.ROGUE: 
									addChild(this.pickup = new Pickup(this.x, this.y, new Boolean(Math.round(Math.random() - 0.40)) ? Pickup.HEALTH : Pickup.SHURIKEN));
									break;
								default: 
									throw new Error("How did you manage to kill an enemy without having a class?");
									break;
							}
						}
						else
						{
							switch (Game.man.type)
							{
								case Player.MAGE: 
									addChild(this.pickup = new Pickup(this.x, this.y, new Boolean(Math.round(Math.random())) ? Pickup.HEALTH : Pickup.MANA));
									break;
								case Player.FIGHTER: 
									addChild(this.pickup = new Pickup(this.x, this.y, Pickup.HEALTH));
									break;
								case Player.ROGUE: 
									addChild(this.pickup = new Pickup(this.x, this.y, Pickup.HEALTH));
									break;
								default: 
									throw new Error("How did you manage to kill an enemy without having a class?");
									break;
							}
						}
					}
				}
			}
			
			if (this.tipsOverWhenDead)
			{
				this.collisionHull.x += this.collisionHull.width * 1.5;
			}
		}
		
		/**
		 * Check if the dropped pickup is colliding with the player or if pickup lifetime is reached.
		 */
		private function checkPickup():void
		{
			if (!this.pickup)
			{
				return;
			}
			
			if (this.pickup.alpha < 1)
			{
				this.pickup.alpha -= 0.1;
			}
			
			if (this.pickup.alpha <= 0)
			{
				this.pickup.parent.removeChild(this.pickup);
				this.pickup = null;
				return;
			}
			
			if (!Game.man.isDestroyed)
			{
				if (this.pickup.hitTestObject(Game.man.collisionHull))
				{
					
					switch (this.pickup.type)
					{
						case Pickup.HEALTH:
							HUD.healPlayer(10.00, true);
							World.audio.playSFX("pickup");
							break;
						case Pickup.MANA:
							HUD.restoreMana(25);
							World.audio.playSFX("pickup");
							break;
						case Pickup.KEY:
							Game.man.hasKey = true;
							World.audio.playSFX("keys");
							break;
						case Pickup.ARROW:
						case Pickup.SHURIKEN:
							HUD.restoreAmmo(5);
							break;
						default:
							throw new Error("Congratulations, you just broke the universe. I hope you know the Doctor.");
					}
					
					this.pickup.parent.removeChild(this.pickup);
					this.pickup = null;
				}
			}
		
		}
		
		/**
		 * AI synapse
		 * Check health and destroy enemy if below 0
		 */
		private function testHealth():void
		{
			if (!isDestroyed)
			{
				if (this.hitpoints <= 0)
				{
					this.destroy();
				}
			}
		}
		
		/**
		 * AI synapse
		 * Update the search rectangle
		 */
		private function updateView():void
		{
			if (this.lastHeading != this.heading || (!Game.man.isDestroyed && homeRect.contains(Game.man.x, Game.man.y)))
			{
				if (!Game.man.isDestroyed && !homeRect.contains(Game.man.x, Game.man.y))
				{
					this.alertedThisFrame = false;
				}
			}
			
			this.homeRect.height = 60;
			this.homeRect.width = 300;
			
			this.homeRect.x = this.heading ? this.x - 100 : this.x - 200;
			this.homeRect.y = this.y - 30;
			
			if (debug)
			{
				Game.stage.removeChild(this.homeRectDebug);
				this.homeRectDebug = new Sprite;
				this.homeRectDebug.graphics.beginFill(0x00ffff, 0.1);
				this.homeRectDebug.graphics.drawRect(this.homeRect.x, this.homeRect.y, this.homeRect.width, this.homeRect.height);
				this.homeRectDebug.graphics.endFill();
				Game.stage.addChild(this.homeRectDebug);
			}
		}
		
		/**
		 * AI synapse
		 * Turn around if the edge of a platform is reached or an obstacle is struck
		 */
		private function adjustHeading():void
		{
			this.lastHeading = heading;
			
			var reverse:int = 0;
			var facePlayer:int = 1;
			var noChange :int = 2;
			
			var lookDirection:int = noChange;
			
			var manInView:Boolean = this.homeRect.contains(Game.man.x, Game.man.y) && !Game.man.isDestroyed && Game.man.y <= this.y + this.height / 2 && !wallIsOccluding();
			
			//	If the enemy isn't supposed to be standing still...
			if (!(this.behaviorFlags & STAND_GROUND) > 0 || this.fleeMode)
			{
				if (!holdingGround)
				{
					//	...turn him around when he hits an obstacle
					if (heading)
					{
						if (this.x <= this.lastPosition.x)
						{
							lookDirection = reverse;
						}
					}
					else
					{
						if (this.x >= this.lastPosition.x)
						{
							lookDirection = reverse;
						}
					}
				}
			}
			
			if (!fleeMode)
			{				
				if (findEdge())
				{
					//	If the enemy is on an edge but the player is in view
					if (manInView)
					{
						lookDirection = facePlayer;
					}
					
					holdingGround = false;
				}
				else
				{
					//	If the enemy is on an edge but the player is in view, wait on the edge
					if (manInView)
					{
						holdingGround = true;
						lookDirection = facePlayer;
					}
					else
					{
						//	Otherwise turn around so as to not fall off the edge
						if (castDown(1))
						{
							lookDirection = reverse;
						}
					}
				}
			}
			
			switch (lookDirection)
			{
				case reverse:
					heading = !heading;
					break;
				case facePlayer:
					this.heading = this.x < Game.man.x;
					break;
				case noChange:
					break;
				default:
					throw new Error("This will never happen while the compiler is sane");
			}
			
		}
		
		/**
		 * AI synapse
		 * Attepmt to attack player
		 */
		private function beginOffense():void
		{
			if (!fleeMode)
			{
				if (this.homeRect.contains(Game.man.x, Game.man.y) && !Game.man.isDestroyed)// && Game.man.y <= this.y + this.height / 2)
				{
					if (wallIsOccluding())
						return;
					
					if (!this.alertedThisFrame)
					{
						this.sound.playSFX("alerted");
						this.alertedThisFrame = true;
					}
					
					if (!(this.behaviorFlags & PASSIVE) > 0)
					{
						if (heading)
						{
							if (Game.man.x > this.x && this.rotationY == 0)
								this.attack();
						}
						else
						{
							if (Game.man.x < this.x && this.rotationY == 180)
								this.attack();
						}
					}
					
					if ((this.behaviorFlags & AFRAID) > 0)
					{
						if (Point.distance(new Point(Game.man.x, Game.man.y), new Point(this.x, this.y)) < this.homeRect.width / 4)
						{
							fleeMode = true;
							
							this.heading = this.x > Game.man.x;
							
							this.fleeCooldown.stop();
							this.fleeCooldown.reset();
							this.fleeCooldown.start();
						}
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
			if (!(behaviorFlags & NO_FEAR) > 0)
			{
				if (this.hitpoints <= this.maxHealth / 3 && !fleeMode)
				{
					fleeMode = true;
					
					fleeMode = true;
					
					if (this.homeRect.contains(Game.man.x, Game.man.y))
					{
						if (this.x <= Game.man.x)
							heading = false;
						else
							heading = true;
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
				if (!(this.behaviorFlags & AFRAID) > 0 && !this.isFrozen)
				{
					this.hitpoints++;
				}
			}
		}
		
		/**
		 * AI synapse
		 * Update movement
		 */
		private function move():void
		{
			if (this.graphic.playing != "shocked" && this.graphic.playing != "die" && this.graphic.playing != "attack")
			{
				this.graphic.play("walk");
			}
			
			if (holdingGround)
			{
				if (!attacking)
				{
					this.graphic.play("stand");
				}
			}

			this.lastPosition.x = this.x;
			this.lastPosition.y = this.y;
			
			this.rotationY = this.heading ? 0 : 180;
			
			if (fleeMode)
			{
				
				if (heading)
				{
					if (Game.man.x > this.x && !Game.man.isDestroyed && this.homeRect.contains(Game.man.x, Game.man.y) && (this.behaviorFlags & NO_RANGED) <= 0)
						this.shoot();
					this.x += 5;
				}
				else
				{
					if (Game.man.x < this.x && !Game.man.isDestroyed && this.homeRect.contains(Game.man.x, Game.man.y) && (this.behaviorFlags & NO_RANGED) <= 0)
						this.shoot();
					x -= 5;
				}
				
			}
			else
			{
				if (!(this.behaviorFlags & STAND_GROUND) > 0 && !this.holdingGround)
				{
					if (heading)
					{
						this.x += (1 + this.speed);
					}
					else
					{
						x -= (1 + this.speed);
					}
				}
			}
		}
		
		private function attack():void
		{
			if (!Game.man.isDestroyed)
			{
				if (Point.distance(new Point(this.x, this.y), new Point(Game.man.x, Game.man.y)) > this.collisionHull.width)
				{
					if (!(behaviorFlags & NO_RANGED) > 0)
					{
						shoot();
						return;
					}
				}
				
				
				if (Point.distance(new Point(this.x, this.y), new Point(Game.man.x, Game.man.y)) <= ((this.collisionHull.width / 2) + (Game.man.collisionHull.width / 2) + 10)) // a little extra padding
				{
					if (!(behaviorFlags & NO_MELEE) > 0)
					{
						attacking = true;
						this.graphic.play("attack");
						stab();
						return;
					}
				}
				
				attacking = false;
			}
		}
		
		private function castDown(steps:int = 10):Boolean
		{
			var offset:int = 0;
			
			for (var step:uint = 0; step < steps; step++)
			{
				
				if (debug)
				{
					WorldUtils.addDecal(new Bitmap(new BitmapData(2, 2)), x + (heading ? offset : -offset), y + 5 + (collisionHull.height / 2) + step * 10, function(d:Decal):*
						{
							//Function won't run until next frame
							//So removing it immediately is fine
							Game.stage.removeChild(d);
						});
				}
				
				for (var i:uint = 0; i < World.Platforms.length; i++)
				{
					if (World.Platforms[i].hitTestPoint(x + (heading ? offset : -offset), y + 5 + (collisionHull.height / 2) + step * 10))
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		private function findEdge():Boolean
		{
			var check:Number = 5;
			
			if (debug)
			{
				WorldUtils.addDecal(new Bitmap(new BitmapData(2, 2, false, 0xff0000)), heading ? x + check : x - check, y + collisionHull.height / 2 + 10, function(d:Decal):*
					{
						//Function won't run until next frame
						//So removing it immediately is fine
						Game.stage.removeChild(d);
					});
			}
			
			for (var i:uint = 0; i < World.Platforms.length; i++)
			{
				if (World.Platforms[i].hitTestPoint(heading ? x + check : x - check, y + collisionHull.height / 2 + 10))
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Determine if a wall exists between this enemy and the player
		 * @return	If a wall exists between this enemy and the player
		 */
		private function wallIsOccluding(steps:int = 20):Boolean
		{			
			for (var step:uint = 0; step < steps; step++)
			{
				var test:Point = new Point(this.x + (step * (this.x < Game.man.x ? 10 : -10)), this.y);
				
				if (debug)
				{
					WorldUtils.addDecal(new Bitmap(new BitmapData(2, 2)), test.x, test.y, function(d:Decal):*
						{
							//Function won't run until next frame
							//So removing it immediately is fine
							Game.stage.removeChild(d);
						});
				}
				
				if (Game.man.collisionHull.hitTestPoint(test.x, test.y))
				{
					return false;
				}
				
				for (var i:uint = 0; i < World.Platforms.length; ++i)
				{
					if (World.Platforms[i].hitTestPoint(test.x, test.y))
					{
						return true;
					}
				}
			}
			
			return false;
		}
	}

}