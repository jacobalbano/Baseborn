package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 * @author Jake Albano
	 */
	public class Player extends Mob
	{		
		public function Player(x:Number, y:Number) 
		{
			super( x, y, Library.IMG("rogue.png") );
			this.friendly = true;
		}
	}
}