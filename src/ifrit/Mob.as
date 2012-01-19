package ifrit
{
	import com.jacobalbano.Animation;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	
	
	/**
	 * @author Chris Logsdon
	 * @author Jake Albano
	 */
	
	public class Mob extends IfritObject
	{
		//	Graphical representation
		public var graphic:Animation;
		protected var container:Sprite;
		
		public var sound:Audio;
		
		public var attackTimer:Timer;
		protected var freezeTimer:Timer;
		protected var frozen:Boolean;
		public var struck:Boolean;
		
		//	Physics
		public var gravUp:Boolean;
		public var jumping:Boolean;
		public var canJump:Boolean;
		public var jumpTimer:Timer;
		public var velocity:Point;
		protected var speedLimit:Point;
		
		public var collisionHull:Sprite;
		protected var halfSize:Point;
		protected var classType:uint;
		private var healthMeter:Sprite;
		protected var skipThink:Boolean;
		
		public var walkRight:Number;
		public var walkLeft:Number;
		public var friendly:Boolean;
		public var hitpoints:int;
		public var maxHealth:uint;		
		public var hasGravity:Boolean;
		public var rangedType:Class;
		
		public var meleeDamage:int;
		
		public function Mob(x:Number, y:Number, bitmap:Bitmap, frameWidth:Number, frameHeight:Number, collisionWidth:Number, collisionHeight:Number)
		{
			this.container = new Sprite;
			addChild(container);
			graphic = new Animation(bitmap, frameWidth, frameHeight);
			
			sound = new Audio;
			
			container.x = -frameWidth / 2; // Set registration point to center
			container.y = -frameHeight / 2;
			container.addChild(graphic);
			
			attackTimer = new Timer(0, 20);
			jumpTimer = new Timer(0, 2);
			freezeTimer = new Timer(60 * 2, 0);
			this.meleeDamage = 5;
			velocity = new Point;
			
			this.x = x;
			this.y = y;
			
			this.canJump = true;
			
			this.collisionHull = new Sprite;
			this.collisionHull.addChild(new Bitmap(new BitmapData(collisionWidth, collisionHeight, false, 0x000000)));
			this.collisionHull.x = -collisionWidth / 2;
			this.collisionHull.y = -collisionHeight / 2;
			
			this.collisionHull.y -= (collisionHeight - this.height) / 2;
			
			this.collisionHull.visible = false;
			this.addChild(collisionHull);
			
			this.halfSize = new Point(this.collisionHull.width / 2, this.collisionHull.height / 2);
			
			this.speedLimit = new Point(7, 15);
			
			this.hasGravity = true;
			
			this.rangedType = MeleeSwing;
		}
		
		public function collideWithMob(obj:Mob):Boolean
		{
			if (this.friendly == obj.friendly || this is Doppleganger || obj is Doppleganger)
				return false;
				
			if (this.isDestroyed || obj.isDestroyed)
				return false;
			
			var dx:Number = obj.x - this.x; // Distance between objects (X)
			var dy:Number = obj.y - this.y; // Distance between objects (Y)
			
			var ox:Number = Math.abs(((this.collisionHull.width / 2) + (obj.collisionHull.width / 2)) - Math.abs(dx)); // Overlap on X axis
			var oy:Number = Math.abs(((this.collisionHull.height / 2) + (obj.collisionHull.height / 2)) - Math.abs(dy)); // Overlap on Y axis
			
			if (this.collisionHull.hitTestObject(obj.collisionHull))
			{
				if (obj.x <= this.x)
				{
					this.x += ox; // left
					obj.x -= ox;
				}
				else if (obj.x >= this.x)
				{
					this.x -= ox; // right
					obj.x += ox; // right
				}
				else if (obj.y <= this.y) // top
				{
					this.hitpoints -= 5;
					obj.y -= oy;
					obj.gravUp = false;
					obj.jumpTimer.reset();
				}
				else if (obj.y >= this.y) // bottom
				{
					obj.y += oy;
					obj.jumpReset();
				}
				
				return true;
			}
			
			return false;
		
		}
		
		public function get isFrozen():Boolean	{	return this.frozen;		}
		/**
		 * Override this to add AI
		 */
		public function think():void
		{
		
		}
		
		public function jumpReset():void
		{
			velocity.y = 0;
		}
		
		public function shoot(ammo:Class = null):Projectile
		{
			if (attackTimer.currentCount == attackTimer.repeatCount)
			{
				attackTimer.reset();
			}
			
			var ammunition:Class;
			var shot:Projectile = null;
			
			if (ammo)
			{
				ammunition = ammo;
			}
			else
			{
				ammunition = this.rangedType;
			}
			
			if (!attackTimer.running)
			{
				this.sound.playSFX("shoot");
				
				attackTimer.start();
				
				if (this.rotationY == 180)
				{
					if (this.classType == Player.FIGHTER)
						stage.addChild(shot = new ammunition(-15, this.x - this.halfSize.x + 6, this.y + 6, this.friendly));
					else
						stage.addChild(shot = new ammunition(-10, this.x - this.halfSize.x + 10, this.y, this.friendly));
				}
				else
				{
					if (this.classType == Player.FIGHTER)
						stage.addChild(shot = new ammunition(15, this.x - this.halfSize.x + 16, this.y + 6, this.friendly));
					else
						stage.addChild(shot = new ammunition(10, this.x - this.halfSize.x + 10, this.y, this.friendly));
				}
				
				World.Projectiles.push(shot);
			}
			
			return shot;
			
		}
		
		public function stab():void 
		{
			if (attackTimer.currentCount == attackTimer.repeatCount)
			{
				attackTimer.reset();
			}
			
			if (!attackTimer.running)
			{
				this.sound.playSFX("stab");
				
				if (this.rotationY == 180)
					stage.addChild(new MeleeSwing(-10, this.x - this.collisionHull.width / 2, this.y, this.meleeDamage, this.friendly));
				else
					stage.addChild(new MeleeSwing(10, this.x + this.collisionHull.width / 2, this.y, this.meleeDamage, this.friendly));
				
				World.Projectiles.push(stage.getChildAt(stage.numChildren - 1));
			}
			
			attackTimer.start();
		}
		
		public function freeze():void
		{
			if (this.isDestroyed)	return;
			
			freezeTimer.stop();
			freezeTimer.reset();
			freezeTimer.start();
			this.frozen = true;
		}
		
		public function webbed(d:Decal):void
		{
			this.x = d.x
			d.y = this.y
			
			if (this.freezeTimer.currentCount >= 20)
			{
				stage.removeChild(d);
				this.freezeTimer.stop();
				this.frozen = false;
				this.struck = false;
			}
		}
		
		public function comeToRest():void
		{
			stopUpdating();
		}
		
		override protected function update():void 
		{			
			preThink();
			
			if (!skipThink)	think();
			skipThink = false;
			
			postThink();
			
			if (gravUp)
				velocity.y += Rules.gravity;
			else
				velocity.y = 0;
			
			if (jumping && jumpTimer.currentCount < jumpTimer.repeatCount && velocity.y <= 1)
			{
				if (!jumpTimer.running)
					jumpTimer.start();
			}
			
			if (jumpTimer.running)
				velocity.y += -5;
			
			if (jumpTimer.currentCount == jumpTimer.repeatCount)
				jumpTimer.stop();
			
			if (velocity.x >= speedLimit.x)
			{
				velocity.x = speedLimit.x;
			}
			if (velocity.x < -speedLimit.x)
			{
				velocity.x = -speedLimit.x;
			}
			if (velocity.y >= speedLimit.y)
			{
				velocity.y = speedLimit.y;
			}
			if (velocity.y <= -speedLimit.x)
			{
				velocity.y = -speedLimit.x;
			}
			
			// Apply physics to player movement
			this.x += velocity.x;
			this.y += velocity.y;
			
			if (hasGravity) gravUp = true;
			
			// Wrap mob position to stay in the stage
			if (this.x + this.halfSize.x > stage.stageWidth)
			{
				this.x = stage.stageWidth - this.halfSize.x;
			}
			
			if (this.x - this.halfSize.x < 0)
			{
				this.x = 0 + this.halfSize.x;
			}
			
			if (this.y + this.halfSize.y > Game.dimensions.y)
			{
				velocity.x = 0;
				velocity.y = 0;
				this.y = Game.dimensions.y - this.halfSize.y;
				
				jumpTimer.reset(); // Reset when on floor, to avoid constant jumping in air
			}
			
			this.collisionHull.rotationY = 0;
		}
		
		/**
		 * Override this; Called before think phase
		 */
		public function preThink():void 
		{
			
		}
		
		/**
		 * Override this; Called after think phase
		 */
		public function postThink():void 
		{
			
		}
	
	}

}