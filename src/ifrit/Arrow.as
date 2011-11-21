package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	/**
	 * @author Chris Logsdon
	 */
	public class Arrow extends Projectile
	{
		
		public function Arrow(direction:int, x:Number, y:Number, friendly:Boolean = true) 
		{
			super(Library.IMG("arrow.png"), 22, 6, direction, x, y, friendly, 0, true);
			
			if (this.friendly)	HUD.buyAction(10, HUD.AMMO);
			
			this.hasPhysics = true;
			
			this.damage = 5;
		}
		
		override protected function update():void 
		{
			super.update();
		}
		
	}

}