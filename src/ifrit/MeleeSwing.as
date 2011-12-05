package ifrit 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * @author Jake Albano
	 */
	public class MeleeSwing extends Projectile 
	{
		
		public function MeleeSwing(direction:int, x:Number, y:Number, damage:int, friendly:Boolean = true)
		{
			super(new Bitmap(new BitmapData(10, 10, false, 0x000000)), 10, 10, direction, x, y, friendly, 2);
			this.alpha = 0;
			this.hasPhysics = false;
			this.damage = damage;
		}
		
	}

}