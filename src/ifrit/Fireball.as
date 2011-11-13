package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.events.AsyncErrorEvent;
	
	/**
	 * @author Jake Albano
	 */
	public class Fireball extends Projectile 
	{
		
		public function Fireball(direction:int, x:Number, y:Number, friendly:Boolean = true)
		{
			super(Library.IMG("fireballShot.png"), 25, 10, direction, x, y, friendly);
			this.animation.add("fly", [0, 1, 2, 3, 4, 5, 6, 7], 12, true);
			this.animation.play("fly");
			
			if (this.friendly)
			{
				HUD.mana.width -= 15;
				HUD.energy.width -= 75;
			}
		}
		
	}
	
}