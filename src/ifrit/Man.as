package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Man extends Sprite
	{		
		private var man:Bitmap = Library.IMG("rogue.png");
		private var manC:Sprite = new Sprite;
		
		public static var vx:Number;
		public static var vy:Number;
		private var speedLimitX:Number;
		private var speedLimitY:Number;
		
		public static var gravity:Number;
		
		public static var L:Boolean;
		public static var R:Boolean;
		public static var SB:Boolean; // spacebar
		
		public static var jumpTimer:Timer = new Timer(0, 2);
		
		public static var gravUp:Boolean;
		
		public function Man(x:Number, y:Number) 
		{
			addChild(manC);
			manC.x = man.x - (man.width / 2);
			manC.y = man.y - (man.height / 2);
			man.smoothing = true;
			manC.addChild(man);
			
			this.x = x;
			this.y = y;
			
			vx = 0;
			vy = 0;
			speedLimitX = 7;
			speedLimitY = 20;
			gravity = 1;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		//BUG: Upward thrust when player hits corner of platform
		private function onEnterFrame(e:Event):void
		{
			if (gravUp)	vy += gravity;
			else vy = 0;
			
			// Jump(rise) until spacebar up or until timer ends.
			if (SB && jumpTimer.currentCount < jumpTimer.repeatCount && vy <= 1)
			{
				if (!jumpTimer.running) {  jumpTimer.start();  }
				
				vy += -5;
			}
			if (jumpTimer.currentCount == jumpTimer.repeatCount) {  jumpTimer.stop();  }
			
			if (vx >= speedLimitX) {  vx = speedLimitX;  }
			if (vx < -speedLimitX) {  vx = -speedLimitX;  }
			if (vy >= speedLimitY) {  vy = speedLimitY;  }
			if (vy < -speedLimitY) {  vy = -speedLimitY;  }
			
			// Apply physics to player movement
			this.x += vx;
			this.y += vy;
			
			// Stage boundaries
			var thisHalfW:uint = (this.width / 2);
			var thisHalfH:uint = (this.height / 2);
			if (this.x + thisHalfW > stage.stageWidth)
			{
				this.x = stage.stageWidth - thisHalfW;
				vx = 0;
			}
			if (this.x - thisHalfW < 0)
			{
				this.x = 0 + thisHalfW;
				vx = 0;
			}
			if (this.y + thisHalfH > stage.stageHeight)
			{
				vy = 0;
				this.y = stage.stageHeight - thisHalfH;
				
				jumpTimer.reset();
			}
			if (this.y - thisHalfH < 0)
			{
				vy = 0;
				this.y = 0 + thisHalfH;
			}
			
			gravUp = true;
		} // End enter frame
	}
}