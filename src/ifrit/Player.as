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
				case 0:		animationName = "mage.png";		        frameWidth = 41;	frameHeight = 25;		break;
				case 2:		animationName = "rogue.png";		    frameWidth = 38;	frameHeight = 25;		break;
				case 4:		animationName = "fighter.png";			frameWidth = 48;	frameHeight = 33;		break;
				case 8:		animationName = "unclassed.png";		frameWidth = 15;	frameHeight = 25;		break;
			}
			
			super( x, y, Library.IMG(animationName), frameWidth, frameHeight, 18, 25);
			
			switch (type)
			{
				case 0:
					this.rangedType = Fireball;
					graphic.add("casting", [4, 4, 4, 4], 12, false, true);
					break;
				case 2:
					this.rangedType = Shuriken;
					break;
				case 4:
					this.rangedType = Arrow;
					graphic.add("shield", [8, 9, 10, 11], 20, false, true);
					graphic.add("pull", [12, 13, 14, 15], 12, false, true);
					graphic.add("release90", [16, 17, 18, 19], 18, false);
					break;
				case 8:
					graphic.add("standNoClass", [4], 0, true);
				default:	
			}
			
			this.classType = type;
			
			graphic.add("walk", [0, 1, 2, 3], 6, true);
			graphic.add("stand", [1], 0, true);
			graphic.add("attack", [4, 5, 6, 7], 12, false);
			graphic.add("climbUp", [20, 21, 22, 23], 8, true);
			graphic.add("climbDown", [23, 22, 21, 20], 8, true);
			graphic.add("climbIdle", [21], 0, true);
			graphic.add("death", [24, 25, 26, 27], 6, false);
			
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