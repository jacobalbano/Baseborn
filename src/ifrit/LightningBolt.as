package ifrit 
{
	import com.jacobalbano.Animation;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Sprite;
	
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class LightningBolt extends IfritObject
	{
		public var wisp:Animation;
		protected var wispC:Sprite = new Sprite();
		
		public var bolt:Animation;
		protected var boltC:Sprite = new Sprite();
		
		public var boltHalfHeight:Number;
		
		public var vortex:Animation;
		protected var vortexC:Sprite = new Sprite();
		
		private var dir:Boolean; // True = right, False = left
		private var vx:Number;
		private var acceleration:Number;
		private var struckEnemies:Vector.<int>;
		
		public static var manaCost:Number = 25;
		public static var energyCost:Number = 95;
		
		private var sound:Audio;
		
		public function LightningBolt(direction:Boolean, x:Number, y:Number) 
		{
			sound = new Audio;
			sound.addSFX("wisp", Library.getSound("audio.sfx.Wisp.mp3"));
			sound.addSFX("bolt", Library.getSound("audio.sfx.bolt.mp3"));
			sound.playSFX("wisp");
			
			addChild(wispC);
			wisp = new Animation(Library.getImage("wisp.png"), 15, 15);
			wispC.x = -20 / 2;
			wispC.y = -20 / 2;
			wispC.addChild(wisp);
			
			addChild(boltC);
			bolt = new Animation(Library.getImage("lightningBolt.png"), 10, 75);
			boltC.x = -10 / 2;
			boltC.y = -75 / 2;
			boltHalfHeight = bolt.height / 2;
			
			addChild(vortexC);
			vortex = new Animation(Library.getImage("vortex.png"), 20, 15);
			vortexC.x = -20 / 2;
			vortexC.y = -15 / 2;
			
			
			wisp.add("wisp", [0, 1, 2, 3], 10, true);
			bolt.add("strike", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 30, false);
			vortex.add("vortex", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 15, false);
			
			wisp.play("wisp", true);
			
			dir = direction;
			wisp.x = x;
			wisp.y = y;
			
			vx = 0;
			if (direction)  { acceleration = 0.3; }
			else if (!direction)  { acceleration = -0.3; }
			
			this.struckEnemies = new Vector.<int>;
		}
		
		override protected function update():void 
		{
			vx += acceleration;
			wisp.x += vx;
		}
		
		public function sendBolt():void
		{
			sound.stopSFX("wisp");
			
			if (this.contains(wispC)) this.removeChild(wispC);
			
			if (wisp.x > 0 && wisp.x < 1000)
			{
				vx = 0;
				bolt.x = wisp.x;
				bolt.y = wisp.y - (bolt.height / 2);
				vortex.x = bolt.x;
				vortex.y = bolt.y - (bolt.height / 2);
				
				boltC.addChild(bolt);
				vortexC.addChild(vortex);
				
				
				if (bolt.playing != "strike" && vortex.playing != "vortex")
				{
					if (sound)	sound.playSFX("bolt");
					HUD.buyAction(energyCost, HUD.ENERGY);
					HUD.buyAction(manaCost, HUD.MANA);
				}
				
				
				bolt.play("strike");
				vortex.play("vortex");
			}
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