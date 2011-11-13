package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class HUD extends IfritObject
	{
		private var area:Bitmap;
		
		public static var health:Sprite;
		public static var mana:Sprite;
		public static var energy:Sprite;
		public static var ammo:Sprite;
		
		private var healthBarColor:Boolean; // True: dark, False: light
		
		public function HUD() 
		{
			area = Library.IMG("HUD.png");
			
			health = new Sprite();
			mana = new Sprite();
			energy = new Sprite();
			ammo = new Sprite();
			
			area.x = 0;
			area.y = 400.
			addChild(area);
			
			health.graphics.beginFill(0xD70000);
			health.graphics.drawRect(0, 0, 200, 21);
			health.graphics.endFill();
			health.x = 50;
			health.y = 442;
			
			mana.graphics.beginFill(0x006BD7);
			mana.graphics.drawRect(0, 0, 200, 9);
			mana.graphics.endFill();
			mana.x = 750;
			mana.y = 442;
			
			energy.graphics.beginFill(0xD9D300);
			energy.graphics.drawRect(0, 0, 200, 9);
			energy.graphics.endFill();
			energy.x = 750;
			energy.y = 454;
			
			
			//ammo.graphics.beginFill(0xD70000);
			//ammo.graphics.drawRect(0, 0, 200, 21);
			//ammo.graphics.endFill();
			//ammo.x = 50;
			//ammo.y = 375;
			
			
			addChild(health);
			addChild(mana);
			addChild(energy);
			//addChild(ammo);
			
			healthBarColor = true;
		}
		
		override protected function update():void 
		{
			if (energy.width < 200) { energy.width += 1.5; }
			
			//FIXME: Health bar color
			/*
			 * Health bar color doesn't go back to normal color if it was
			 * flashing and then restored above 30
			 */
			if (health.width <= 50)
			{
				health.graphics.clear();
				if (healthBarColor)
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
				healthBarColor = !healthBarColor;
			}
		}
		
	}

}