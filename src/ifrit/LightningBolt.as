package ifrit 
{
	import com.jacobalbano.Animation;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class LightningBolt extends Sprite
	{
		public var wisp:Animation;
		protected var wispC:Sprite = new Sprite();
		
		public var bolt:Animation;
		protected var boltC:Sprite = new Sprite();
		
		public var boltHalfHeight:Number;
		
		private var dir:Boolean; // True = right, False = left
		private var vx:Number;
		private var acceleration:Number;
		
		public var boltTime:Timer;
		
		public function LightningBolt(direction:Boolean, x:Number, y:Number) 
		{
			addChild(wispC);
			wisp = new Animation(Library.IMG("crosshair.png"), 20, 20);
			wispC.x = -20 / 2;
			wispC.y = -20 / 2;
			wispC.addChild(wisp);
			
			addChild(boltC);
			bolt = new Animation(Library.IMG("lightningBolt.png"), 10, 75);
			boltC.x = -10 / 2;
			boltC.y = -75 / 2;
			boltHalfHeight = bolt.height / 2;
			
			wisp.add("wisp", [0], 12, true);
			bolt.add("strike", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 30, false);
			
			boltTime = new Timer(10, 0);
			
			
			dir = direction;
			wisp.x = x;
			wisp.y = y;
			
			vx = 0;
			if (direction)  { acceleration = 0.3; }
			else if (!direction)  { acceleration = -0.3; }
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void 
		{
			vx += acceleration;
			wisp.x += vx;
		}
		
		//FIXME: Bolt child does not get removed
		/*
		 * Have not been able to figure out to make it work right,
		 * so the last chunk of the animation remains on the stage.
		 * You can see this by the small yellow specks that remain
		 * afterwards.
		 */
		//TODO: Figure out how what is being done wrong with the timer
		public function sendBolt():void
		{
			boltTime.start();
			bolt.x = wisp.x;
			bolt.y = wisp.y - (bolt.height / 2);
			this.removeChild(wispC);
			
			boltC.addChild(bolt);
			bolt.play("strike");
			//trace(boltTime.currentCount);
			//boltTime.stop();
			//boltTime.reset();
		}
		
	}

}