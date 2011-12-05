package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
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
		
		private var area:Bitmap;
		private var icon1:Bitmap;
		private var icon2:Bitmap;
		private var skills:Bitmap;
		
		private static var health:Sprite;
		private var healthIcon:Bitmap;
		private var lowHealth:Timer;
		private static var totalHealth:Number;
		private static var healthScale:Number;
		private static var remainingHealth:Number;
		private var healthTxt:TextField;
		private var healthTxtFormat:TextFormat;
		
		private static var mana:Sprite;
		private static var totalMana:Number;
		private var manaTxt:TextField;
		private var manaTxtFormat:TextFormat;
		private static var energy:Sprite;
		private var energyTxt:TextField;
		private var energyTxtFormat:TextFormat;
		
		private static var shuriken:Sprite;
		private var shurikenTxt:TextField
		private var shurikenTxtFormat:TextFormat;
		private static var caltrops:Sprite;
		private static var blink:Sprite;
		
		private static var arrows:Sprite;
		private var arrowTxt:TextField
		private var arrowTxtFormat:TextFormat;
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
			
			healthTxt = new TextField();
			healthTxt.type = TextFieldType.DYNAMIC;
			healthTxt.textColor = 0xFFFFFF;
			healthTxt.x = health.x;
			healthTxt.y = health.y - 2;
			healthTxt.height = 20;
			healthTxt.width = 200;
			
			healthTxtFormat = new TextFormat();
			healthTxtFormat.size = 18;
			healthTxtFormat.align = "center";
			healthTxt.defaultTextFormat = healthTxtFormat;
			
			addChild(healthTxt);
			
			healthIcon = Library.IMG("icons.healthIcon.png");
			healthIcon.x = health.x - 22
			healthIcon.y = health.y + 2;
			addChild(healthIcon);
			
			
			mana = new Sprite();
			mana.graphics.beginFill(0x006BD7);
			mana.graphics.drawRect(0, 0, 200, 9);
			mana.graphics.endFill();
			mana.x = 750;
			mana.y = 442;
			
			manaTxt = new TextField();
			manaTxt.type = TextFieldType.DYNAMIC;
			manaTxt.textColor = 0xFFF584;
			manaTxt.x = mana.x;
			manaTxt.y = mana.y - 4;
			manaTxt.height = 14;
			manaTxt.width = 200;
			
			manaTxtFormat = new TextFormat();
			manaTxtFormat.size = 10;
			manaTxtFormat.align = "center";
			manaTxt.defaultTextFormat = manaTxtFormat;
			
			
			energy = new Sprite();
			energy.graphics.beginFill(0xD9D300);
			energy.graphics.drawRect(0, 0, 200, 9);
			energy.graphics.endFill();
			energy.x = 750;
			energy.y = 454;
			
			energyTxt = new TextField();
			energyTxt.type = TextFieldType.DYNAMIC;
			energyTxt.textColor = 0x00376F;
			energyTxt.x = energy.x;
			energyTxt.y = energy.y - 4;
			energyTxt.height = 14;
			energyTxt.width = 200;
			
			energyTxtFormat = new TextFormat();
			energyTxtFormat.size = 10;
			energyTxtFormat.align = "center";
			energyTxt.defaultTextFormat = energyTxtFormat;
			
			if (Game.playerClass == Player.MAGE)
			{	
				healthScale = 1;
				
				icon1 = Library.IMG("icons.manaIcon.png");
				icon2 = Library.IMG("icons.energyIcon.png");
				skills = Library.IMG("mageSkills.png");
				
				addChild(mana);
				addChild(manaTxt);
				
				addChild(energy);
				addChild(energyTxt);
			}
			
			shuriken = new Sprite();
			shuriken.graphics.beginFill(0x000000);
			shuriken.graphics.drawRect(0, 0, 200, 9);
			shuriken.graphics.endFill();
			shuriken.x = 750;
			shuriken.y = 442;
			
			shurikenTxt = new TextField();
			shurikenTxt.type = TextFieldType.DYNAMIC;
			shurikenTxt.textColor = 0xFFFFFF;
			shurikenTxt.x = shuriken.x;
			shurikenTxt.y = shuriken.y - 4;
			shurikenTxt.height = 14;
			shurikenTxt.width = 200;
			
			shurikenTxtFormat = new TextFormat();
			shurikenTxtFormat.size = 10;
			shurikenTxtFormat.align = "center";
			shurikenTxt.defaultTextFormat = shurikenTxtFormat;
			
			caltrops = new Sprite();
			caltrops.graphics.beginFill(0x000000);
			caltrops.graphics.drawRect(0, 0, 200, 9);
			caltrops.graphics.endFill();
			caltrops.x = 750;
			caltrops.y = 454;
			
			blink = new Sprite();
			blink.graphics.beginFill(0x9AC193);
			blink.graphics.drawRect(0, 0, 200, 9);
			blink.graphics.endFill();
			blink.x = 750;
			blink.y = 454;
			
			if (Game.playerClass == Player.ROGUE)
			{
				healthScale = 2;
				
				icon1 = Library.IMG("icons.shurikenIcon.png");
				icon2 = Library.IMG("icons.blinkIcon.png");
				skills = Library.IMG("rogueSkills.png");
				
				addChild(shuriken);
				addChild(shurikenTxt);
				
				addChild(blink);
			}
			
			arrows = new Sprite();
			arrows.graphics.beginFill(0x793300);
			arrows.graphics.drawRect(0, 0, 200, 9);
			arrows.graphics.endFill();
			arrows.x = 750;
			arrows.y = 442;
			
			
			arrowTxt = new TextField();
			arrowTxt.type = TextFieldType.DYNAMIC;
			arrowTxt.textColor = 0xC7C8C9;
			arrowTxt.x = arrows.x;
			arrowTxt.y = arrows.y - 4;
			arrowTxt.height = 14;
			arrowTxt.width = 200;
			
			arrowTxtFormat = new TextFormat();
			arrowTxtFormat.size = 10;
			arrowTxtFormat.align = "center";
			arrowTxt.defaultTextFormat = arrowTxtFormat;
			
			
			
			
			shield = new Sprite();
			shield.graphics.beginFill(0xA5B5C7);
			shield.graphics.drawRect(0, 0, 200, 9);
			shield.graphics.endFill();
			shield.x = 750;
			shield.y = 454;

			if (Game.playerClass == Player.FIGHTER)
			{
				healthScale = 3;
				
				addChild(arrows);
				addChild(arrowTxt);
				
				addChild(shield);
				
				icon1 = Library.IMG("icons.arrowIcon.png");
				icon2 = Library.IMG("icons.shieldIcon.png");
				skills = Library.IMG("fighterSkills.png");
				
			}
				
			
			icon1.x = 842;
			icon1.y = 419;
			addChild(icon1);
			
			icon2.x = 842;
			icon2.y = 472;
			addChild(icon2);
			
			skills.x = 420;
			skills.y = 432;
			addChild(skills);
			
			totalHealth = (200 * healthScale);
			totalMana = 200;
		}
		
		override protected function update():void 
		{
			
			if (health.width > 200) health.width = 200;
			
			remainingHealth = (health.width * healthScale);
			
			healthTxt.text = String(remainingHealth) + "/" + String(totalHealth);
			
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
			
			if (mana)  manaTxt.text = String(Math.round(mana.width)) + "/" + String(totalMana);
			if (energy) {   if (energy.width < 200)   energy.width += 1.5;   }
			
			if (shuriken)  shurikenTxt.text = String(Math.round(shuriken.width / 20)) + "/" + String(200 / 20)
			//if (caltrops)  caltropTxt.text = String(Math.round(caltrops.width / 13.33)) + "/" + String(Math.round(200 / 13.33));
			if (blink)	{	if (blink.width < 200)	blink.width += .75;	}
			
			if (arrows)  arrowTxt.text = String(Math.round(arrows.width / 10)) + "/" + String(200 / 10);
			if (shield) {   if (shield.width < 200)   shield.width += 1.0;   }
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
				s <= blink.width);
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
				
				if (type == SPECIAL)
				{
					//var remainingCaltrops:Number = caltrops.width;
					var remainingBlink:Number = blink.width;
					
					if (cost <= remainingBlink)
					{
						blink.width -= cost;
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
		
	}

}