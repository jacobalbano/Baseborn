package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class HUD extends IfritObject
	{
		private var area:Bitmap;
		
		public static var health:Sprite;
		private var lowHealth:Timer;
		private static var totalHealth:Number;
		private static var healthScale:Number;
		
		public static var mana:Sprite;
		public static var energy:Sprite;
		
		public static var arrows:Sprite;
		
		public static var stars:Sprite;
		
		
		
		public function HUD() 
		{
			area = Library.IMG("HUD.png");
			area.x = 0;
			area.y = 400.
			addChild(area);
			
			health = new Sprite();
			lowHealth = new Timer(1000);
			health.graphics.beginFill(0xD70000);
			health.graphics.drawRect(0, 0, 200, 21);
			health.graphics.endFill();
			health.x = 50;
			health.y = 442;
			addChild(health);
			
			if (Game.man.type == Player.MAGE)
			{	
				healthScale = 1;
				
				mana = new Sprite();
				mana.graphics.beginFill(0x006BD7);
				mana.graphics.drawRect(0, 0, 200, 9);
				mana.graphics.endFill();
				mana.x = 750;
				mana.y = 442;
				addChild(mana);
				
				energy = new Sprite();
				energy.graphics.beginFill(0xD9D300);
				energy.graphics.drawRect(0, 0, 200, 9);
				energy.graphics.endFill();
				energy.x = 750;
				energy.y = 454;
				addChild(energy);
			}
			
			if (Game.man.type == Player.ROGUE)
			{
				healthScale = 2;
				
				stars = new Sprite();
				stars.graphics.beginFill(0x208000);
				stars.graphics.drawRect(0, 0, 200, 21);
				stars.graphics.endFill();
				stars.x = 750;
				stars.y = 442;
				addChild(stars);
			}
			
			if (Game.man.type == Player.FIGHTER)
			{
				healthScale = 4;
				
				arrows = new Sprite();
				arrows.graphics.beginFill(0x208000);
				arrows.graphics.drawRect(0, 0, 200, 21);
				arrows.graphics.endFill();
				arrows.x = 750;
				arrows.y = 442;
				addChild(arrows);
			}
			
			totalHealth = (200 * healthScale);
		}
		
		override protected function update():void 
		{
			if (energy)  {    if (energy.width < 200) { energy.width += 1.5; }    }
			
			if (health.width <= 50)
			{
				lowHealth.start();
				
				health.graphics.clear();
				if (lowHealth.currentCount % 2 == 0)
				{
					health.graphics.beginFill(0x770000);
					health.graphics.drawRect(0, 0, 200, 21);
					health.graphics.endFill();
				}
				else
				{
					health.graphics.beginFill(0xFF5B5B);
					health.graphics.drawRect(0, 0, 200, 21);
					health.graphics.endFill();
				}
			}
			
			if (health.width > 50 && lowHealth.running)
			{
				lowHealth.stop();
				lowHealth.reset();
				
				health.graphics.clear();
				health.graphics.beginFill(0xD70000);
				health.graphics.drawRect(0, 0, 200, 21);
				health.graphics.endFill();
			}
		}
		
		/**
		 * Damage the player by a literal amount, or by a percentage of total maximum health.
		 * @param	damage		The amount to damage the player 
		 * @param	percent		TRUE: damageAmount is a percentage amount, FALSE: damageAmount is a literal amount
		 */
		public static function damagePlayer(damageAmount:Number, percent:Boolean = false):void
		{
			var remainingHealth:Number = (health.width * healthScale);
			var damagePercentage:Number = (damageAmount * .01);
			
			if (percent)	damageAmount = (totalHealth * damagePercentage);
			else			damageAmount /= healthScale;
			
			if (damageAmount > remainingHealth)		health.width -= remainingHealth;
			else 									health.width -= damageAmount / healthScale;
		}
		
		
		/**
		 * Heal the player by a literal amount, or by a percentage of total maximum health.
		 * @param	healAmount		The amount to heal the player 
		 * @param	percent		TRUE: healAmount is a percentage amount, FALSE: healAmount is a literal amount
		 */
		public static function healPlayer(healAmount:Number, percent:Boolean = false):void
		{
			var missingHealth:Number = (totalHealth - (health.width * healthScale));
			var healPercentage:Number = (healAmount * .01);
			
			if (percent)	healAmount = (totalHealth * healPercentage);
			else			healAmount /= healthScale;
			
			if (healAmount > missingHealth)		health.width += missingHealth;
			else 								health.width += healAmount / healthScale;
		}
		
		//TODO: Make the following functions:
		/*
		 * restoreMana()	Restore player's mana by a specified amount
		 * restoreEnergy()	" energy
		 * restoreAmmo()		" ammo
		 * actionCost(mana, energy, ammo)		The mana, energy and/or ammo cost of a spell
		 * 
		 * ######## Any ideas here, Jake? #########
		 * 
		 */
	}

}