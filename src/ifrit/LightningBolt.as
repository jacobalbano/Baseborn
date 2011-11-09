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
		private var struckEnemies:Vector.<int>;
		
		public function LightningBolt(direction:Boolean, x:Number, y:Number) 
		{
			addChild(wispC);
			wisp = new Animation(Library.IMG("wisp.png"), 15, 15);
			wispC.x = -20 / 2;
			wispC.y = -20 / 2;
			wispC.addChild(wisp);
			
			addChild(boltC);
			bolt = new Animation(Library.IMG("lightningBolt.png"), 10, 75);
			boltC.x = -10 / 2;
			boltC.y = -75 / 2;
			boltHalfHeight = bolt.height / 2;
			
			wisp.add("wisp", [0, 1, 2, 3], 10, true);
			bolt.add("strike", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 30, false);
			wisp.play("wisp", true);
			
			dir = direction;
			wisp.x = x;
			wisp.y = y;
			
			vx = 0;
			if (direction)  { acceleration = 0.3; }
			else if (!direction)  { acceleration = -0.3; }
			
			this.struckEnemies = new Vector.<int>;
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void 
		{
			vx += acceleration;
			wisp.x += vx;
		}
		
		public function sendBolt():void
		{
			vx = 0;
			bolt.x = wisp.x;
			bolt.y = wisp.y - (bolt.height / 2);
			
			if (this.contains(wispC)) this.removeChild(wispC);
			
			boltC.addChild(bolt);
			bolt.play("strike");
		}
		
		public function strikeEnemy(index:int):void
		{
			struckEnemies.push(index);
		}
		
		public function isEnemyStruck(index:int):Boolean
		{
			for (var i:int = 0; i < struckEnemies.length; i++)
			{
				if (this.struckEnemies[i] == index)	return true;
			}
			
			return false;
		}
		
	}

}