package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.utils.Timer;
	
	/**
	 * @author Jake Albano
	 */
	public class Fireball extends Projectile 
	{
		public static var manaCost:Number = 15;
		public static var energyCost:Number = 75;
		
		public function Fireball(direction:int, x:Number, y:Number, friendly:Boolean = true)
		{
			super(Library.IMG("fireballShot.png"), 25, 10, direction, x, y, friendly, 40);
			this.animation.add("fly", [0, 1, 2, 3, 4, 5, 6, 7], 12, true);
			this.animation.play("fly");
			
			//sound.addSFX("fly", Library.SND("audio.sfx.fireball.mp3"));
			
			
			if (this.friendly)
			{
				HUD.buyAction(manaCost, HUD.MANA);
				HUD.buyAction(energyCost, HUD.ENERGY);
			}
			
			this.damage = 5;
		}
		
	}
	
}