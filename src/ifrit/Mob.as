package ifrit 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import com.jacobalbano.Animation;
	
	/**
	 * @author Chris Logsdon
	 * @author Jake Albano
	 */
	
	public class Mob extends Sprite
	{
		//	Graphical representation
		public var graphic:Animation;
		protected var container:Sprite;
		
		private var shootTimer:Timer;
		private var freezeTimer:Timer;
		
		//	Physics
		public var gravUp:Boolean;
		public var jumping:Boolean;
		public var canJump:Boolean;
		public var jumpTimer:Timer;
		public var velocity:Point;
		protected var speedLimit:Point;
		
		public var collisionHull:Sprite;
		protected var halfSize:Point;
		
		public var walkRight:Number;
		public var walkLeft:Number;
		public var friendly:Boolean;
		public var hitpoints:int;
		public var maxHealth:uint;
		
		public function Mob(x:Number, y:Number, bitmap:Bitmap, frameWidth:Number, frameHeight:Number, collisionWidth:Number, collisionHeight:Number) 
		{			
			this.container = new Sprite;
			addChild(container);
			graphic = new Animation(bitmap, frameWidth, frameHeight);
			
			container.x = -frameWidth / 2; // Set registration point to center
			container.y = -frameHeight / 2;
			container.addChild(graphic);
			
			shootTimer = new Timer(0, 20);
			jumpTimer = new Timer(0, 2);
			freezeTimer = new Timer(60 * 2, 0);
			
			velocity = new Point;			
			
			this.x = x;
			this.y = y;
			
			this.collisionHull = new Sprite;
			this.collisionHull.addChild(new Bitmap(new BitmapData(collisionWidth, collisionHeight, false, 0x000000)));
			this.collisionHull.x = -collisionWidth / 2;
			this.collisionHull.y = -collisionHeight / 2;
			
			this.collisionHull.y -= (collisionHeight - this.height) / 2;
			
			this.collisionHull.visible = false;
			this.addChild(collisionHull);
			
			this.halfSize = new Point(this.collisionHull.width / 2, this.collisionHull.height / 2);
			
			speedLimit = new Point(7, 20);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function collideWithMob(obj:Mob):Boolean
		{
			if (this.friendly == obj.friendly)	return false;
			var dx:Number = obj.x - this.x; // Distance between objects (X)
			var dy:Number = obj.y - this.y; // Distance between objects (Y)
			
			var ox:Number = Math.abs( ( (this.collisionHull.width / 2) + (obj.collisionHull.width / 2) ) - Math.abs(dx ) ); // Overlap on X axis
			var oy:Number = Math.abs( ( (this.collisionHull.height / 2) + (obj.collisionHull.height / 2) ) - Math.abs(dy) ); // Overlap on Y axis
			
			if (this.collisionHull.hitTestObject(obj.collisionHull))
			{
				
				if (obj.x < this.x)
				{
					this.x += ox; // left
					obj.x -= ox;
				}
				else if (obj.x > this.x)
				{
					this.x -= ox; // right
					obj.x += ox; // right
				}
				else if (obj.y < this.y) // top
				{
					this.hitpoints -= 5;
					obj.y -= oy;
					obj.gravUp = false;
					obj.jumpTimer.reset();					
				}
				else if (obj.y > this.y) // bottom
				{
					obj.y += oy;
					obj.jumpReset();
				}
				
				return true;
			}
			
			return false;
		
		}
		
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
		
		public function shoot():void
		{
			if (shootTimer.currentCount == shootTimer.repeatCount) {  shootTimer.reset();  }
			
			if (!shootTimer.running)
			{
				if (this.rotationY == 180) stage.addChild(new Fireball(-10, this.x - this.halfSize.x, this.y, this.friendly));
				else stage.addChild(new Fireball(10, this.x + this.halfSize.x, this.y, this.friendly));
				
				Game.Projectiles.push(stage.getChildAt(stage.numChildren - 1));
			}
			
			shootTimer.start();
		}
		
		public function freeze():void
		{
			freezeTimer.stop();
			freezeTimer.reset();
			freezeTimer.start();
		}
		
		public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (!this.freezeTimer.running)
			{
				think();
			}
			
			if (this.freezeTimer.currentCount >= 3)
			{
				this.freezeTimer.stop();
			}
			
			if (gravUp)	velocity.y += Rules.gravity;
			else velocity.y = 0;
			
			if (jumping && jumpTimer.currentCount < jumpTimer.repeatCount && velocity.y <=1)
			{
				if (!jumpTimer.running)
					jumpTimer.start();
			}
			
			if (jumpTimer.running)  velocity.y += -5;
			
			if (jumpTimer.currentCount == jumpTimer.repeatCount)
				jumpTimer.stop();
				
			if (velocity.x >= speedLimit.x) { velocity.x = speedLimit.x; }
			if (velocity.x < -speedLimit.x) { velocity.x = -speedLimit.x; }
			if (velocity.y >= speedLimit.y) { velocity.y = speedLimit.y; }
			if (velocity.y <= -speedLimit.x) { velocity.y = -speedLimit.x; }
				
			// Apply physics to player movement
			this.x += velocity.x;
			this.y += velocity.y;
			
			gravUp = true;
			
			this.collisionHull.rotationY = 0;
		}
		
	}

}