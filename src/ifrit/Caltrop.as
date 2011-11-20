package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * @author Jake Albano
	 */
	public class Caltrop extends Projectile 
	{
		
		public function Caltrop(direction:int, x:Number, y:Number, friendly:Boolean = true)
		{
			super(Library.IMG("caltrop.png"), 12, 9, direction, x, y, friendly, 0, true);
			this.hasPhysics = true;
			this.isBallistic = false;
			if (direction > 0)	this.vx = 3;
			if (direction < 0)	this.vx = -3;
			
			this.damage = 10;
			this.static = true;
			
			if (this.friendly)	HUD.buyAction(13.3, HUD.SPECIAL);
		}
		
		override protected function update():void 
		{
			super.update();

			if (!this.stopped)
			{
				this.vy += Rules.gravity / 2;
			}
		}
		
	}

}