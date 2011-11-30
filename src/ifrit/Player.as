package ifrit 
{
	import com.jacobalbano.Input;
	import com.thaumaturgistgames.flakit.Library;
	import flash.utils.Timer;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 * @author Jake Albano
	 */
	public class Player extends Mob
	{
		/**
		 * Lightning bolt
		 */
		public var lightningAttack:LightningBolt;
		public var boltPlaying:Boolean; // Lightning bolt animation is playing
		public var boltTime:Timer = new Timer(30, 0);
		
		/**
		 * Frost bolt
		 */
		public var frostAttack:FrostBolt;
		
		/**
		 * Shield
		 */
		public var shielding:Boolean;
		
		/**
		 * Blink
		 */
		public var blinkTimer:Timer;
		public var blinkTo:Point;
		public var endBlink:Boolean;
		public var canBlink:Boolean;
		 
		public var canMelee:Boolean;
		public var canShoot:Boolean;
		
		public var hasCaltrop:Boolean;
		public var activeCaltrop:Caltrop;
		public var canDropCaltrop:Boolean;	
		
		public static const MAGE:uint = 0;
		public static const ROGUE:uint = 2;
		public static const FIGHTER:uint = 4;
		public static const NONE:uint = 8;

		
		private	var idle:Boolean;
		
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
				case 8:		animationName = "unclassed.png";		frameWidth = 15;	frameHeight = 25;		break;
			}
			
			super( x, y, Library.IMG(animationName), frameWidth, frameHeight, 18, 25);
			
			switch (type)
			{
				case 0:
					this.rangedType = Fireball;
					graphic.add("stand", [1], 0, true);
					graphic.add("ladder", [11], 0, true);
					graphic.add("climb", [10, 11, 12, 13], 6, true);
					graphic.add("attack", [6, 7, 8, 9], 12, false);
					graphic.add("casting", [6, 6, 6, 6], 12, false, true);
					break;
				case 2:
					this.rangedType = Shuriken;
					graphic.add("stand", [1], 0, true);
					graphic.add("attack", [6, 7, 8, 9], 12, false);
					break;
				case 4:
					this.rangedType = Arrow;
					graphic.add("stand", [1], 0, true);
					graphic.add("ladder", [23], 0, true);
					graphic.add("climb", [22, 23, 24, 25], 6, true);
					graphic.add("attack", [4, 5, 6, 7], 12, false);
					graphic.add("shield", [8, 9, 10, 11], 20, false, true);
					graphic.add("pull", [12, 13, 14, 15], 12, false, true);
					graphic.add("release90", [18, 19, 20, 21], 18, false);
					break;
				case 8:
					graphic.add("stand", [4], 0, true);
				default:	
			}
			
			this.classType = type;
			
			graphic.add("walk", [0, 1, 2, 3], 6, true);
			graphic.add("shoot", [6, 7, 8, 9], 12, false);
			graphic.add("climbUp", [22, 23, 24, 25], 8, true);
			graphic.add("climbDown", [25, 24, 23, 22], 8, true);
			graphic.add("climbIdle", [23], 0, true);
			graphic.play("stand");
			
			this.friendly = true;
			this.idle = false;
			
			this.hasCaltrop = true;
			this.blinkTimer = new Timer(0, 7);
			this.lightningAttack = null;
			this.boltPlaying = false;
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
		
		/**
		 * Check if the player has no action animations playing.
		 * @return
		 */
		public function get isIdle():Boolean
		{
		if (this.graphic.playing != "attack"		&&
			this.graphic.playing != "casting"		&&
			this.graphic.playing != "shield" 		&&
			this.graphic.playing != "pull"			&&
			this.graphic.playing != "aimUp"			&&
			this.graphic.playing != "aimDown"		&&
			this.graphic.playing != "release90"		&&
			this.graphic.playing != "release45"		&&
			this.graphic.playing != "release135"
			) this.idle = true;
			
			else this.idle = false;
			
			return this.idle;
		}
	}
}