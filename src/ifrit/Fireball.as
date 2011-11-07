package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * @author Jake Albano
	 */
	public class Fireball extends Projectile 
	{
		
		public function Fireball(direction:int, x:Number, y:Number, friendly:Boolean = true)
		{
			super(Library.IMG("fireballShot.png"), 25, 10, direction, x, y, friendly);
			this.animation.add("fly", [0, 1], 7, true);
			this.animation.play("fly");
			//this.hasPhysics = true;
		}
		
	}

}