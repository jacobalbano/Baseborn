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
		
		private var vx:Number;
		private var vy:Number;
		private var speedLimit:Number;
		
		public static var gravity:Number;
		
		public static var L:Boolean;
		public static var R:Boolean;
		public static var SB:Boolean; // spacebar
		
		public static var jumpTimer:Timer = new Timer(0, 2);
		
		public static var gravUp:Boolean;
		
		public function Man(x:Number, y:Number) 
		{
			addChild(manC);
			manC.x = man.x - (man.width / 2); // Set registration point to center
			manC.y = man.y - (man.height / 2);
			man.smoothing = true;
			manC.addChild(man);
			
			this.x = x;
			this.y = y;
			
			vx = 0;
			vy = 0;
			speedLimit = 7;
			gravity = 1;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		//TODO: Make vy static var and reset from HorizontalWall class?
		/*
		 * Took out any tweaking of Man.jumpTimer() because it either reset at an
		 * inappropriate time, or it never reached it's repeat count (2). This cause the
		 * sticking to bottoms of platforms while Spacebar was down. In order to jump,
		 * the following must be true: currentCount < repeatCount. (see enter frame function).
		 */
		public function jumpReset():void
		{
			vy = 0;
		}
		
		
		//BUG: Upward thrust when player hits corner of platform
		private function onEnterFrame(e:Event):void
		{
			if (gravUp)	vy += gravity;
			else vy = 0;
			
			// Jump(rise) until spacebar up or until timer ends.
			if (SB && jumpTimer.currentCount < jumpTimer.repeatCount)
			{
				if (!jumpTimer.running) {  jumpTimer.start();  }
				
				vy += -5;
				
				if (vx >= speedLimit) {	vx = speedLimit; }
				if (vx < -speedLimit) {	vx = -speedLimit; }
				if (vy >= speedLimit) {	vy = speedLimit; }
				if (vy < -speedLimit) {	vy = -speedLimit; }
				
			}
			if (jumpTimer.currentCount == jumpTimer.repeatCount) {  jumpTimer.stop();  }
			
			// Apply physics to player movement
			this.x += vx;
			this.y += vy;
			
			// Stage boundaries
			var thisHalfW:uint = (this.width / 2);
			var thisHalfH:uint = (this.height / 2);
			if (this.x + thisHalfW > stage.stageWidth) {  this.x = stage.stageWidth - thisHalfW;  }
			if (this.x - thisHalfW < 0) {  this.x = 0 + thisHalfW;  }
			if (this.y + thisHalfH > stage.stageHeight)
			{
				vx = 0;
				vy = 0;
				this.y = stage.stageHeight - thisHalfH;
				
				jumpTimer.reset(); // Reset when on floor, to avoid constant jumping in air
			}
			if (this.y - thisHalfH < 0)
			{
				vx = 0;
				vy = 0;
				this.y = 0 + thisHalfH;
			}
			
			gravUp = true;
		} // End enter frame
	}
}