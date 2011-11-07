package ifrit 
{
	import com.jacobalbano.Animation;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.BitmapData;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
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
		}
		
	}

}