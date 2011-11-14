package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Arrow extends Projectile
	{
		
		public function Arrow(direction:int, x:Number, y:Number, friendly:Boolean = true) 
		{
			super(Library.IMG("arrow.png"), 22, 6, direction, x, y, friendly );
		}
		
		override protected function update():void 
		{
			super.update();
			
			this.hasPhysics = true;
		}
		
	}

}