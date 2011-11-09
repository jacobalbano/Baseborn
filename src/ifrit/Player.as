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
			super( x, y, Library.IMG("mageAtkWalk.png"), 18, 25, 18, 25);
			this.friendly = true;
			
			graphic.add("stand", [1], 0, true);
			graphic.add("walk", [0, 1, 2, 3], 6, true);
			graphic.add("attack", [6, 7, 8, 9], 12, false);
			graphic.play("stand");
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