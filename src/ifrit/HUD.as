package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class HUD extends IfritObject
	{
		private var area:Bitmap;
		
		private static var health:Sprite;
		private var lowHealth:Timer;
		private static var totalHealth:Number;
		private static var healthScale:Number;
		
		private static var mana:Sprite;
		private static var totalMana:Number;
		private static var energy:Sprite;
		
		private static var caltrops:Sprite;
		private static var shuriken:Sprite;
		
		private static var arrows:Sprite;
		private static var shield:Sprite;
		
		
		
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
				
				shuriken = new Sprite();
				shuriken.graphics.beginFill(0xFFFFFF);
				shuriken.graphics.drawRect(0, 0, 200, 9);
				shuriken.graphics.endFill();
				shuriken.x = 750;
				shuriken.y = 442;
				addChild(shuriken);
				
				caltrops = new Sprite();
				caltrops.graphics.beginFill(0x000000);
				caltrops.graphics.drawRect(0, 0, 200, 9);
				caltrops.graphics.endFill();
				caltrops.x = 750;
				caltrops.y = 454;
				addChild(caltrops);
			}
			
			if (Game.man.type == Player.FIGHTER)
			{
				healthScale = 4;
				
				arrows = new Sprite();
				arrows.graphics.beginFill(0x793300);
				arrows.graphics.drawRect(0, 0, 200, 9);
				arrows.graphics.endFill();
				arrows.x = 750;
				arrows.y = 442;
				addChild(arrows);
				
				shield = new Sprite();
				shield.graphics.beginFill(0xA5B5C7);
				shield.graphics.drawRect(0, 0, 200, 9);
				shield.graphics.endFill();
				shield.x = 750;
				shield.y = 454;
				addChild(shield);
			}
			
			totalHealth = (200 * healthScale);
			totalMana = 200;
		}
		
		override protected function update():void 
		{
			if (energy)  {    if (energy.width < 200) { energy.width += 1.5; }    }
			if (shield) {   if (shield.width < 200) { shield.width += 1.0; }   }
			
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
			
			if (damageAmount > remainingHealth)		health.width -= health.width;
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
		
		/**
		 * Restore the player's mana.
		 * @param	amount		Literal amount of mana to restore (based off 200 point mana pool)
		 */
		public static function restoreMana(amount:Number):void
		{
			var missingMana:Number = (totalMana - (mana.width));
			
			if (amount > missingMana)	mana.width += missingMana;
			else						mana.width += amount;
		}
		
		
		//TODO: Clean this up and optimize it.
		/* Jake, if you have any suggestions for this, please let me know */
		/**
		 * Determines if there are enough resources to perform an action, and uses up the given resources if possible.
		 * @param	evaluation		TRUE: Performs check but no action, FALSE: Performs check and action
		 * @param	manaAmt			Literal cost of action in mana
		 * @param	energyAmt		Literal cost of action in energy
		 * @param	rangedAmt		Literal cost of action in shuriken or arrows
		 * @param	specialAmt		Literal cost of action in caltrops or shield
		 * @return	
		 */
		public static function actionCost(evaluation:Boolean = false, manaAmt:Number = 0, energyAmt:Number = 0, rangedAmt:uint = 0, specialAmt:uint = 0):Boolean
		{
			var allowed:Boolean = false;
			
			if (Game.man.type == Player.MAGE)
			{
				rangedAmt = 0;
				specialAmt = 0;
				
				var remainingMana:Number = mana.width;
				var remainingEnergy:Number = energy.width;
				
				if (manaAmt <= remainingMana && energyAmt <= remainingEnergy)
				{
					allowed = true;
					
					if (!evaluation)
					{
						mana.width -= manaAmt;
						energy.width -= energyAmt;
					}
				}
				else allowed = false;
			}
			
			if (Game.man.type == Player.ROGUE)
			{
				manaAmt = 0;
				energyAmt = 0;
				
				var remainingShuriken:Number = shuriken.width;
				var remainingCaltrops:Number = caltrops.width;
				
				if (rangedAmt <= remainingShuriken && specialAmt <= remainingCaltrops)
				{
					allowed = true;
					
					if (!evaluation)
					{
						shuriken.width -= rangedAmt;
						caltrops.width -= specialAmt;
					}
				}
				else allowed = false;
			}
			
			if (Game.man.type == Player.FIGHTER)
			{
				manaAmt = 0;
				energyAmt = 0;
				
				var remainingArrows:Number = arrows.width;
				var remainingShield:Number = shield.width;
				
				if (rangedAmt <= remainingArrows && specialAmt <= remainingShield)
				{
					allowed = true;
					
					if (!evaluation)
					{
						arrows.width -= rangedAmt;
						shield.width -= specialAmt;
					}
				}
				else allowed = false;
			}
			
			return allowed;
		}
		
		//TODO: Make the following functions:
		/*
		 * restoreEnergy()	" energy
		 * restoreAmmo()		" ammo
		 * 
		 * ######## Any ideas here, Jake? #########
		 * 
		 */
	}

}