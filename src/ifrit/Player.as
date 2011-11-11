package ifrit 
{
	import com.jacobalbano.Input;
	import com.thaumaturgistgames.flakit.Library;
	
	
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
			graphic.add("casting", [8, 9], 12, false);
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