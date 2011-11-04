package ifrit 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * @author Chris Logsdon
	 * @author Jake Albano
	 */
	
	public class Mob extends Sprite
	{
		//	Graphical representation
		public var bitmap:Bitmap;
		protected var container:Sprite = new Sprite;
		
		private var shootTimer:Timer = new Timer(0, 20);
		
		//	Physics
		public var gravUp:Boolean;
		public var jumping:Boolean;
		public var canJump:Boolean;
		public var jumpTimer:Timer = new Timer(0, 2);
		public var velocity:Point = new Point(0, 0);
		protected var speedLimit:Point;
		
		protected var halfSize:Point;
		
		public var friendly:Boolean;
		
		public function Mob(x:Number, y:Number, bitmap:Bitmap) 
		{
			this.bitmap = bitmap;
			
			addChild(container);
			
			container.x = bitmap.x - (bitmap.width / 2); // Set registration point to center
			container.y = bitmap.y - (bitmap.height / 2);
			bitmap.smoothing = true;
			container.addChild(bitmap);
			
			this.x = x;
			this.y = y;
			
			this.halfSize = new Point(this.width / 2, this.height / 2);
			
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
			if (velocity.y < -speedLimit.x) { velocity.y = -speedLimit.x; }
				
			// Apply physics to player movement
			this.x += velocity.x;
			this.y += velocity.y;
			
			// Wrap mob position to stay in the stage
			if (this.x + this.halfSize.x > stage.stageWidth) {  this.x = stage.stageWidth - this.halfSize.x;  }
			
			if (this.x - this.halfSize.x < 0) {  this.x = 0 + this.halfSize.x;  }
			
			if (this.y + this.halfSize.y > stage.stageHeight)
			{
				velocity.x = 0;
				velocity.y = 0;
				this.y = stage.stageHeight - this.halfSize.y;
				
				jumpTimer.reset(); // Reset when on floor, to avoid constant jumping in air
			}
			
			if (this.y - this.halfSize.y < 0)
			{
				velocity.x = 0;
				velocity.y = 0;
				this.y = 0 + this.halfSize.y;
			}
			
			gravUp = true;
		}
		
	}

}