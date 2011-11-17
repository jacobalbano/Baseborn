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
		
		public static const MAGE:uint = 0;
		public static const ROGUE:uint = 2;
		public static const FIGHTER:uint = 4;
		
		public function Player(x:Number, y:Number, type:uint) 
		{
			var animationName:String;
			var frameWidth:int = 18;
			var frameHeight:int = 25;
			
			switch (type)
			{
				case 0:		animationName = "mage.png";		        frameWidth = 18;	frameHeight = 25;		break;
				case 2:		animationName = "rogue.png";		    frameWidth = 24;	frameHeight = 25;		break;
				case 4:		animationName = "fighter.png";			frameWidth = 38;	frameHeight = 33;		break;
			}
			
			super( x, y, Library.IMG(animationName), frameWidth, frameHeight, 18, 25);
			
			switch (type)
			{
				case 0:
					graphic.add("attack", [6, 7, 8, 9], 12, false);
					graphic.add("casting", [6, 6, 6, 6], 12, false, true);
					
					break;
				case 2:
					graphic.add("attack", [6, 7, 8, 9], 12, false);
					break;
				case 4:
					graphic.add("attack", [6, 7, 8, 9], 12, false);
					graphic.add("archery", [14, 15, 16, 17], 12, false);
					graphic.add("shield", [10, 11, 12, 13], 20, false, true);
					break;
				default:	
			}
			
			this.classType = type;
			
			graphic.add("stand", [1], 0, true);
			graphic.add("walk", [0, 1, 2, 3], 6, true);
			graphic.add("shoot", [6, 7, 8, 9], 12, false);
			graphic.play("stand");
			
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
		
		public function get type():uint
		{
			return this.classType;
		}
	}
}