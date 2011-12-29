package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class HUDutils
	{
		/*****************************************************
		 * 					Draw Functions
		 *****************************************************/
		
		public static function drawArea():void
		{
			HUD.area = Library.IMG("HUD.bg.png");
			HUD.area.x = 0;
			HUD.area.y = 400.
			Game.stage.addChild(HUD.area);
		}
			
		public static function drawResources():void
		{
			/**
			 * MAGE
			 */
			HUD.mana = new Sprite();
			HUD.mana.graphics.beginFill(0x006BD7);
			HUD.mana.graphics.drawRect(0, 0, 200, 9);
			HUD.mana.graphics.endFill();
			HUD.mana.x = 750;
			HUD.mana.y = 442;
			
			HUD.manaTxt = new TextField();
			HUD.manaTxt.type = TextFieldType.DYNAMIC;
			HUD.manaTxt.textColor = 0xFFF584;
			HUD.manaTxt.x = HUD.mana.x;
			HUD.manaTxt.y = HUD.mana.y - 4;
			HUD.manaTxt.height = 14;
			HUD.manaTxt.width = 200;
			
			HUD.manaTxtFormat = new TextFormat();
			HUD.manaTxtFormat.size = 10;
			HUD.manaTxtFormat.align = "center";
			HUD.manaTxt.defaultTextFormat = HUD.manaTxtFormat;
			
			HUD.energy = new Sprite();
			HUD.energy.graphics.beginFill(0xD9D300);
			HUD.energy.graphics.drawRect(0, 0, 200, 9);
			HUD.energy.graphics.endFill();
			HUD.energy.x = 750;
			HUD.energy.y = 454;
			
			HUD.energyTxt = new TextField();
			HUD.energyTxt.type = TextFieldType.DYNAMIC;
			HUD.energyTxt.textColor = 0x00376F;
			HUD.energyTxt.x = HUD.energy.x;
			HUD.energyTxt.y = HUD.energy.y - 4;
			HUD.energyTxt.height = 14;
			HUD.energyTxt.width = 200;
			
			HUD.energyTxtFormat = new TextFormat();
			HUD.energyTxtFormat.size = 10;
			HUD.energyTxtFormat.align = "center";
			HUD.energyTxt.defaultTextFormat = HUD.energyTxtFormat;
			
			
			
			/**
			 * ROGUE
			 */
			HUD.shuriken = new Sprite();
			HUD.shuriken.graphics.beginFill(0x000000);
			HUD.shuriken.graphics.drawRect(0, 0, 200, 9);
			HUD.shuriken.graphics.endFill();
			HUD.shuriken.x = 750;
			HUD.shuriken.y = 442;
			
			HUD.shurikenTxt = new TextField();
			HUD.shurikenTxt.type = TextFieldType.DYNAMIC;
			HUD.shurikenTxt.textColor = 0xFFFFFF;
			HUD.shurikenTxt.x = HUD.shuriken.x;
			HUD.shurikenTxt.y = HUD.shuriken.y - 4;
			HUD.shurikenTxt.height = 14;
			HUD.shurikenTxt.width = 200;
			
			HUD.shurikenTxtFormat = new TextFormat();
			HUD.shurikenTxtFormat.size = 10;
			HUD.shurikenTxtFormat.align = "center";
			HUD.shurikenTxt.defaultTextFormat = HUD.shurikenTxtFormat;
			
			HUD.caltrops = new Sprite();
			HUD.caltrops.graphics.beginFill(0x000000);
			HUD.caltrops.graphics.drawRect(0, 0, 200, 9);
			HUD.caltrops.graphics.endFill();
			HUD.caltrops.x = 750;
			HUD.caltrops.y = 454;
			
			HUD.blink = new Sprite();
			HUD.blink.graphics.beginFill(0x9AC193);
			HUD.blink.graphics.drawRect(0, 0, 200, 9);
			HUD.blink.graphics.endFill();
			HUD.blink.x = 750;
			HUD.blink.y = 454;
			
			
			
			 /**
			  * FIGHTER
			  */
			HUD.arrows = new Sprite();
			HUD.arrows.graphics.beginFill(0x793300);
			HUD.arrows.graphics.drawRect(0, 0, 200, 9);
			HUD.arrows.graphics.endFill();
			HUD.arrows.x = 750;
			HUD.arrows.y = 442;
			
			HUD.arrowTxt = new TextField();
			HUD.arrowTxt.type = TextFieldType.DYNAMIC;
			HUD.arrowTxt.textColor = 0xC7C8C9;
			HUD.arrowTxt.x = HUD.arrows.x;
			HUD.arrowTxt.y = HUD.arrows.y - 4;
			HUD.arrowTxt.height = 14;
			HUD.arrowTxt.width = 200;
			
			HUD.arrowTxtFormat = new TextFormat();
			HUD.arrowTxtFormat.size = 10;
			HUD.arrowTxtFormat.align = "center";
			HUD.arrowTxt.defaultTextFormat = HUD.arrowTxtFormat;
			
			HUD.shield = new Sprite();
			HUD.shield.graphics.beginFill(0xA5B5C7);
			HUD.shield.graphics.drawRect(0, 0, 200, 9);
			HUD.shield.graphics.endFill();
			HUD.shield.x = 750;
			HUD.shield.y = 454;
			
			drawClass(); // Player class-specific
			
			HUD.icon1.x = 842;
			HUD.icon1.y = 419;
			Game.stage.addChild(HUD.icon1);
			
			HUD.icon2.x = 842;
			HUD.icon2.y = 472;
			Game.stage.addChild(HUD.icon2);
		}
		
		public static function drawHealth():void
		{
			HUD.health = new Sprite();
			HUD.lowHealth = new Timer(1000);
			HUD.health.graphics.beginFill(0xD70000);
			HUD.health.graphics.drawRect(0, 0, 200, 21);
			HUD.health.graphics.endFill();
			HUD.health.x = 50;
			HUD.health.y = 442;
			Game.stage.addChild(HUD.health);
			
			HUD.healthTxt = new TextField();
			HUD.healthTxt.type = TextFieldType.DYNAMIC;
			HUD.healthTxt.textColor = 0xFFFFFF;
			HUD.healthTxt.x = HUD.health.x;
			HUD.healthTxt.y = HUD.health.y - 2;
			HUD.healthTxt.height = 20;
			HUD.healthTxt.width = 200;
			
			HUD.healthTxtFormat = new TextFormat();
			HUD.healthTxtFormat.size = 18;
			HUD.healthTxtFormat.align = "center";
			HUD.healthTxt.defaultTextFormat = HUD.healthTxtFormat;
			
			Game.stage.addChild(HUD.healthTxt);
			
			HUD.healthIcon = Library.IMG("icons.healthIcon.png");
			HUD.healthIcon.x = HUD.health.x - 22
			HUD.healthIcon.y = HUD.health.y + 2;
			Game.stage.addChild(HUD.healthIcon);
			
			switch (Game.playerClass)
			{
				case Player.MAGE:		HUD.healthScale = 1;
					break;
				case Player.ROGUE:		HUD.healthScale = 2;
					break;
				case Player.FIGHTER:	HUD.healthScale = 3;
					break;
				default: throw new Error("How do you have a Heads Up Display without having a class?");
			}
			
			HUD.totalHealth = (200 * HUD.healthScale);
			HUD.totalMana = 200;
		}
		
		public static function drawSkills():void
		{
			HUD.boxA = Library.IMG("HUD.emptyA.png");
			HUD.boxA.x = 430;
			HUD.boxA.y = 432;
			HUD.skillA.x = 430;
			HUD.skillA.y = 432;
			HUD.boxA.alpha = 0;
			HUD.skillA.alpha = 0;
			Game.stage.addChild(HUD.skillA);
			Game.stage.addChild(HUD.boxA);
			
			HUD.boxS = Library.IMG("HUD.emptyS.png");
			HUD.boxS.x = 480;
			HUD.boxS.y = 432;
			HUD.skillS.x = 480;
			HUD.skillS.y = 432;
			HUD.boxS.alpha = 0;
			HUD.skillS.alpha = 0;
			Game.stage.addChild(HUD.skillS);
			Game.stage.addChild(HUD.boxS);
			
			HUD.boxD = Library.IMG("HUD.emptyD.png");
			HUD.boxD.x = 530;
			HUD.boxD.y = 432;
			HUD.skillD.x = 530;
			HUD.skillD.y = 432;
			HUD.boxD.alpha = 0;
			HUD.skillD.alpha = 0;
			Game.stage.addChild(HUD.skillD);
			Game.stage.addChild(HUD.boxD);
		}
		
		public static function drawMisc():void
		{
			// Inventory
			HUD.inv = Library.IMG("HUD.keyDrop.png");
			HUD.inv.x = 484;
			HUD.inv.y = 410;
			Game.stage.addChild(HUD.inv);
			
			// Audio State
			HUD.audUnmute = Library.IMG("HUD.unmuted.png");
			HUD.audUnmute.x = 635;
			HUD.audUnmute.y = 445;
			Game.stage.addChild(HUD.audUnmute);
			
			HUD.audMute = Library.IMG("HUD.muted.png");
			HUD.audMute.x = 635;
			HUD.audMute.y = 445;
			Game.stage.addChild(HUD.audMute);
		}
		
		/******************************************************
		 * 					Update Functions
		 ******************************************************/
		
		public static function updateHealth():void
		{
			if (HUD.health.width > 200) HUD.health.width = 200;
			
			HUD.remainingHealth = (HUD.health.width * HUD.healthScale);
			
			HUD.healthTxt.text = String(HUD.remainingHealth) + "/" + String(HUD.totalHealth);
			
			if (HUD.health.width <= 50)
			{
				HUD.lowHealth.start();
				
				HUD.health.graphics.clear();
				if (HUD.lowHealth.currentCount % 2 == 0)
				{
					HUD.health.graphics.beginFill(0x770000);
					HUD.health.graphics.drawRect(0, 0, 200, 21);
					HUD.health.graphics.endFill();
				}
				else
				{
					HUD.health.graphics.beginFill(0xFF5B5B);
					HUD.health.graphics.drawRect(0, 0, 200, 21);
					HUD.health.graphics.endFill();
				}
			}
			
			if (HUD.health.width > 50 && HUD.lowHealth.running)
			{
				HUD.lowHealth.stop();
				HUD.lowHealth.reset();
				
				HUD.health.graphics.clear();
				HUD.health.graphics.beginFill(0xD70000);
				HUD.health.graphics.drawRect(0, 0, 200, 21);
				HUD.health.graphics.endFill();
			}
		}
		
		public static function updateResources():void
		{
			if (HUD.mana)  HUD.manaTxt.text = String(Math.round(HUD.mana.width)) + "/" + String(HUD.totalMana);
			if (HUD.energy) {   if (HUD.energy.width < 200)   HUD.energy.width += 1.5;   }
			
			if (HUD.shuriken)  HUD.shurikenTxt.text = String(Math.round(HUD.shuriken.width / 20)) + "/" + String(200 / 20)
			if (HUD.blink)	{	if (HUD.blink.width < 200)	HUD.blink.width += .75;	}
			
			if (HUD.arrows)  HUD.arrowTxt.text = String(Math.round(HUD.arrows.width / 10)) + "/" + String(200 / 10);
			if (HUD.shield) {   if (HUD.shield.width < 200)   HUD.shield.width += 1.0;   }
		}
		
		public static function updateSkills():void
		{
			if (Game.man.knowsA)
			{
				HUD.boxA.alpha = 1;
				
				if (Game.man.type == Player.FIGHTER || Game.man.type == Player.ROGUE)
				{
					if (HUD.ammoCount <= 0) HUD.skillA.alpha = 0.5;
					else HUD.skillA.alpha = 1;
				}
				if (Game.man.type == Player.MAGE)
				{
					if (!HUD.testCost(Fireball.energyCost, Fireball.manaCost)) HUD.skillA.alpha = 0.5;
					else HUD.skillA.alpha = 1;
				}
			}
			if (Game.man.knowsS)
			{
				HUD.boxS.alpha = 1;
				
				if (Game.man.type == Player.FIGHTER)
				{
					if (HUD.shield.width <= 0) HUD.skillS.alpha = 0.5;
					else HUD.skillS.alpha = 1;
				}
				if (Game.man.type == Player.ROGUE)
				{
					if (!Game.man.hasCaltrop) HUD.skillS.alpha = 0.25;
					else HUD.skillS.alpha = 1;
				}
				if (Game.man.type == Player.MAGE)
				{
					if (!HUD.testCost(LightningBolt.energyCost, LightningBolt.manaCost)) HUD.skillS.alpha = 0.5;
					else HUD.skillS.alpha = 1;
				}
			}
			if (Game.man.knowsD)
			{
				HUD.boxD.alpha = 1;
				
				if (Game.man.type == Player.FIGHTER || Game.man.type == Player.ROGUE)
				{
					HUD.skillD.alpha = 1;
				}
				if (Game.man.type == Player.MAGE)
				{
					if (!HUD.testCost(FrostBolt.energyCost)) HUD.skillD.alpha = 0.5;
					else HUD.skillD.alpha = 1;
				}
			}
		}
		
		public static function updateInv():void
		{
			if (Game.man.hasKey)	HUD.inv.alpha = 1.0;
			else					HUD.inv.alpha = 0.1;
		}
		
		public static function updateAudioState():void
		{
			if (Audio.isMuted)
			{
				HUD.audUnmute.alpha	= 0;
				HUD.audMute.alpha	= 1;
			}
			else
			{
				HUD.audUnmute.alpha	= 1;
				HUD.audMute.alpha	= 0;
			}
		}
		
		/*******************
		 * Private Functions
		 *******************/
		
		private static function drawClass():void
		{
			if (Game.playerClass == Player.MAGE)
			{
				HUD.icon1 = Library.IMG("icons.manaIcon.png");
				HUD.icon2 = Library.IMG("icons.energyIcon.png");
				
				HUD.skillA = Library.IMG("HUD.fire.png");
				HUD.skillS = Library.IMG("HUD.bolt.png");
				HUD.skillD = Library.IMG("HUD.ice.png");
				
				Game.stage.addChild(HUD.mana);
				Game.stage.addChild(HUD.manaTxt);
				
				Game.stage.addChild(HUD.energy);
				Game.stage.addChild(HUD.energyTxt);
			}
			
			if (Game.playerClass == Player.ROGUE)
			{
				HUD.icon1 = Library.IMG("icons.shurikenIcon.png");
				HUD.icon2 = Library.IMG("icons.blinkIcon.png");
				
				HUD.skillA = Library.IMG("HUD.shuriken.png");
				HUD.skillS = Library.IMG("HUD.caltrop.png");
				HUD.skillD = Library.IMG("HUD.daggers.png");
				
				Game.stage.addChild(HUD.shuriken);
				Game.stage.addChild(HUD.shurikenTxt);
				
				Game.stage.addChild(HUD.blink);
			}
		
			if (Game.playerClass == Player.FIGHTER)
			{
				HUD.icon1 = Library.IMG("icons.arrowIcon.png");
				HUD.icon2 = Library.IMG("icons.shieldIcon.png");
				
				HUD.skillA = Library.IMG("HUD.bow.png");
				HUD.skillS = Library.IMG("HUD.shield.png");
				HUD.skillD = Library.IMG("HUD.sword.png");
				
				Game.stage.addChild(HUD.arrows);
				Game.stage.addChild(HUD.arrowTxt);
				
				Game.stage.addChild(HUD.shield);
			}
		}
	}

}