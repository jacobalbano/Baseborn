package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import com.jacobalbano.Input;
	
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
			super( x, y, Library.IMG("mageWalk.png"), 18, 25 );
			this.friendly = true;
		}
		
		override public function think():void 
		{
			super.think();
			if (!Input.isKeyDown(Input.SPACE))
			{
				this.canJump = true;
			}
			else
			{
				this.canJump = false;
			}
		}
	}
}