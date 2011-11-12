package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * @author Chris Logsdon
	 */
	public class Shuriken extends Projectile
	{
		
		public function Shuriken(direction:int, x:Number, y:Number, friendly:Boolean = true) 
		{
			super(Library.IMG("shuriken.png"), 10, 10, direction, x, y, friendly );
		}
		
		override public function update():void 
		{
			super.update();
			if (dx < 0) { this.rotation -= 20; }
			else if (dx > 0) { this.rotation += 20; }
			
			this.hasPhysics = true;
		}
		
	}

}