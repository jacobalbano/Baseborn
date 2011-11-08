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
		
		private var shootTimer:Timer = new Timer(0, 20);
		
		//	Physics
		public var gravUp:Boolean;
		public var jumping:Boolean;
		public var canJump:Boolean;
		public var jumpTimer:Timer = new Timer(0, 2);
		public var velocity:Point = new Point(0, 0);
		protected var speedLimit:Point;
		
		public var collisionHull:Sprite;
		protected var halfSize:Point;
		
		public var friendly:Boolean;
		public var hitpoints:int;
		public var maxHealth:uint;
		
		public function Mob(x:Number, y:Number, bitmap:Bitmap, frameWidth:Number, frameHeight:Number, collisionWidth:Number, collisionHeight:Number) 
		{			
			this.container = new Sprite;
			addChild(container);
			graphic = new Animation(bitmap, frameWidth, frameHeight);
			
			graphic.add("stand", [1], 0, true);
			graphic.add("walk", [0, 1, 2, 3], 6, true);
			graphic.add("attack", [6, 7, 8, 9], 12, false);
			graphic.play("stand");
			
			container.x = -frameWidth / 2; // Set registration point to center
			container.y = -frameHeight / 2;
			container.addChild(graphic);
			
			
			this.x = x;
			this.y = y;
			
			this.collisionHull = new Sprite;
			this.collisionHull.addChild(new Bitmap(new BitmapData(collisionWidth, collisionHeight, false, 0x000000)));
			this.collisionHull.x = -collisionWidth / 2;
			this.collisionHull.y = -collisionHeight / 2;
			
			//this.collisionHull.x -= (collisionWidth + this.width);
			this.collisionHull.y -= (collisionHeight - this.height) / 2;
			
			this.collisionHull.visible = false;
			addChild(collisionHull);
			
			this.halfSize = new Point(this.collisionHull.width / 2, this.collisionHull.height / 2);
			
			speedLimit = new Point(7, 20);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
				if (this.rotationY == 180) stage.addChild(new Fireball(-10, this.x, this.y));
				else stage.addChild(new Fireball(10, this.x, this.y));
				
				Game.Projectiles.push(stage.getChildAt(stage.numChildren - 1));
			}
			
			shootTimer.start();
		}
		
		public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			think();
			
			if (gravUp)	velocity.y += Rules.gravity;
			else velocity.y = 0;
			
			// Jump(rise) until spacebar up or until timer ends.
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