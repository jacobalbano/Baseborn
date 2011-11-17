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
		private var caltropTxt:TextField
		private var caltropTxtFormat:TextFormat;
		
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
				addChild(manaTxt);
				
				energy = new Sprite();
				energy.graphics.beginFill(0xD9D300);
				energy.graphics.drawRect(0, 0, 200, 9);
				energy.graphics.endFill();
				energy.x = 750;
				energy.y = 454;
				addChild(energy);
				
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
				addChild(energyTxt);
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
				
				shurikenTxt = new TextField();
				shurikenTxt.type = TextFieldType.DYNAMIC;
				shurikenTxt.textColor = 0x000000;
				shurikenTxt.x = shuriken.x;
				shurikenTxt.y = shuriken.y - 4;
				shurikenTxt.height = 14;
				shurikenTxt.width = 200;
				
				shurikenTxtFormat = new TextFormat();
				shurikenTxtFormat.size = 10;
				shurikenTxtFormat.align = "center";
				shurikenTxt.defaultTextFormat = shurikenTxtFormat;
				addChild(shurikenTxt);
				
				caltrops = new Sprite();
				caltrops.graphics.beginFill(0x000000);
				caltrops.graphics.drawRect(0, 0, 200, 9);
				caltrops.graphics.endFill();
				caltrops.x = 750;
				caltrops.y = 454;
				addChild(caltrops);
				
				caltropTxt = new TextField();
				caltropTxt.type = TextFieldType.DYNAMIC;
				caltropTxt.textColor = 0xFFFFFF;
				caltropTxt.x = caltrops.x;
				caltropTxt.y = caltrops.y - 4;
				caltropTxt.height = 14;
				caltropTxt.width = 200;
				
				caltropTxtFormat = new TextFormat();
				caltropTxtFormat.size = 10;
				caltropTxtFormat.align = "center";
				caltropTxt.defaultTextFormat = caltropTxtFormat;
				addChild(caltropTxt);
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
				addChild(arrowTxt);
				
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
			
			if (mana)  manaTxt.text = String(mana.width) + "/" + String(totalMana);
			if (energy) {   if (energy.width < 200)   energy.width += 1.5;   }
			
			if (shuriken)  shurikenTxt.text = String(shuriken.width / 20) + "/" + String(200 / 20)
			if (caltrops)  caltropTxt.text = String(Math.round(caltrops.width / 13.33)) + "/" + String(Math.round(200 / 13.33));
			
			if (arrows)  arrowTxt.text = String(arrows.width / 10) + "/" + String(200 / 10);
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
		
		
		//TODO: Clean up and optimize this if possible.
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