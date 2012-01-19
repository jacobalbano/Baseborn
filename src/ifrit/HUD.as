package ifrit 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	/**
	 * @author Chris Logsdon
	 */
	public class HUD extends IfritObject
	{
		public static const MANA:uint = 0;
		public static const ENERGY:uint = 2;
		public static const AMMO:uint = 4;
		public static const SPECIAL:uint = 6;
		
		// Background
		public static var area:Bitmap;
		
		// Skills
		public static var boxA:Bitmap;
		public static var skillA:Bitmap;
		public static var boxS:Bitmap;
		public static var skillS:Bitmap;
		public static var boxD:Bitmap;
		public static var skillD:Bitmap;
		
		// Health
		public static var health:Sprite;
		public static var healthIcon:Bitmap;
		public static var lowHealth:Timer;
		public static var totalHealth:Number;
		public static var healthScale:Number;
		public static var remainingHealth:Number;
		public static var healthTxt:TextField;
		public static var healthTxtFormat:TextFormat;
		
		// Mage Resources
		public static var mana:Sprite;
		public static var totalMana:Number;
		public static var manaTxt:TextField;
		public static var manaTxtFormat:TextFormat;
		public static var energy:Sprite;
		public static var energyTxt:TextField;
		public static var energyTxtFormat:TextFormat;
		
		// Rogue Resources
		public static var shuriken:Sprite;
		public static var shurikenTxt:TextField
		public static var shurikenTxtFormat:TextFormat;
		public static var caltrop:Sprite;
		public static var blink:Sprite;
		
		// Fighter Resources
		public static var arrows:Sprite;
		public static var arrowTxt:TextField
		public static var arrowTxtFormat:TextFormat;
		public static var shield:Sprite;
		
		// Misc.
		public static var inv:Bitmap;
		public static var audMute:Bitmap;
		public static var audUnmute:Bitmap;
		public static var icon1:Bitmap;
		public static var icon2:Bitmap;
		
		public function HUD() 
		{
			HUDutils.drawArea();
			HUDutils.drawResources();
			HUDutils.drawHealth();
			HUDutils.drawSkills();
			HUDutils.drawMisc();
		}
		
		override protected function update():void 
		{
			HUDutils.updateHealth();
			HUDutils.updateResources();
			HUDutils.updateAudioState();
			HUDutils.updateSkills();
			HUDutils.updateInv();
		}
		
		/**
		 * Damage the player by a literal amount, or by a percentage of total maximum health.
		 * @param	damage		The amount to damage the player 
		 * @param	percent		TRUE: damageAmount is a percentage amount, FALSE: damageAmount is a literal amount
		 */
		public static function damagePlayer(damageAmount:Number, percent:Boolean = false):void
		{
			var damagePercentage:Number = (damageAmount * .01);
			
			if (percent)	damageAmount = (totalHealth * damagePercentage);
			else			damageAmount /= healthScale;
			
			if (damageAmount > remainingHealth)		health.width -= health.width;
			else 									health.width -= Math.ceil(damageAmount / healthScale);
		}
		
		public static function get healthAmount():int
		{
			return remainingHealth;
		}
		
		
		/**
		 * Heal the player by a literal amount, or by a percentage of total maximum health.
		 * @param	healAmount		The amount to heal the player 
		 * @param	percent		TRUE: healAmount is a percentage amount, FALSE: healAmount is a literal amount
		 */
		public static function healPlayer(healAmount:Number, percent:Boolean = false):void
		{
			var missingHealth:Number = totalHealth - (health.width * healthScale);
			var healPercentage:Number = healAmount * .01;
			
			if (percent)	healAmount = totalHealth * healPercentage;
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
		
		/**
		 * Restore the player's ammunition.
		 * @param	amount		How much ammunition to restore
		 */
		public static function restoreAmmo(amount:Number):void
		{
			if (Game.man.type == Player.FIGHTER)
			{
				var missingArrows:Number = ((200 - arrows.width) / 10);
				
				if (amount > missingArrows)	arrows.width += missingArrows;
				else arrows.width += amount * 10;
			}
			
			if (Game.man.type == Player.ROGUE)
			{
				var missingShuriken:Number = ((200 - shuriken.width) / 20);
				
				if (amount > missingShuriken)	shuriken.width += missingShuriken;
				else shuriken.width += amount * 20;
			}
		}
		
		/**
		 * Determine whether enough energy, ammunition, mana or special ability remains to activate an action
		 * @param	e	Energy cost
		 * @param	m	Mana cost
		 * @param	a	Ammunition cost
		 * @param	s	Special ability cost
		 * @return	Whether the action can be activated
		 */
		public static function testCost(e:Number = 0, m:Number = 0, a:Number = 0, s:Number = 0):Boolean
		{
			return (
				e <= energy.width 	&&
				m <= mana.width		&&
				a <= shuriken.width	&&
				a <= arrows.width	&&
				s <= shield.width	&&
				s <= caltrop.width);
		}
		
		/**
		 * Determines if there are enough resources to perform an action, and uses up the given resources if possible.
		 * @param	cost			How much of the specified meter to deplete
		 * @param	type			A value of HUD.MANA, HUD.ENERGY, HUD.AMMO or HUD.SPECIAL
		 * @return					Whether the requested action can be performed
		 */
		public static function buyAction(cost:Number, type:uint):void
		{
			var allowed:Boolean = false;
			
			if (Game.man.type == Player.MAGE)
			{
				if (type == MANA)
				{
					var remainingMana:Number = mana.width;
					
					if (cost <= remainingMana)
					{
						mana.width -= cost;
					}
				}
				
				if (type == ENERGY)
				{
					var remainingEnergy:Number = energy.width;
					
					if (cost <= remainingEnergy)
					{
						energy.width -= cost;
					}
				}
			}
			
			if (Game.man.type == Player.ROGUE)
			{
				if (type == AMMO)
				{
					var remainingShuriken:Number = shuriken.width;
					if (cost <= remainingShuriken)
					{
						shuriken.width -= cost;
					}
				}
			}
			
			if (Game.man.type == Player.FIGHTER)
			{				
				if (type == AMMO)
				{
					var remainingArrows:Number = arrows.width;
					
					if (cost <= remainingArrows)
					{
						arrows.width -= cost;
					}

				}
				
				if (type == SPECIAL)
				{
					var remainingShield:Number = shield.width;
					
					if (cost <= remainingShield)
					{
						shield.width -= cost;
					}
				}
			}
		}
		
		/**
		 * Returns a decimal amount between 0 and 1, indicating the percentage of ammo remaining
		 */
		public static function get ammoCount():Number
		{
			var count:Number = 0;
			if 		(Game.man.type == Player.FIGHTER)	count = (arrows.width/10) / 20 ;
			else if (Game.man.type == Player.ROGUE)		count = (shuriken.width/20) / 10 ;
			
			return count;
		}
		
	}

}