package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Web extends Projectile
	{
		
		public function Web(direction:int, x:Number, y:Number, friendly:Boolean = true)
		{
			super(Library.IMG("webShot.png"), 25, 10, direction, x, y, friendly, 40);
			this.animation.add("fly", [0, 1, 2, 3, 4, 5], 12, true);
			this.animation.play("fly");
			
			this.damage = 2;
		}
		
		override protected function update():void 
		{
			super.update();
		}
	}

}