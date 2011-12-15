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
		
		public var hasKey:Boolean;
		
		public var hasCaltrop:Boolean;
		public var activeCaltrop:Caltrop;
		public var canDropCaltrop:Boolean;	
		
		public static const MAGE:uint = 0;
		public static const ROGUE:uint = 2;
		public static const FIGHTER:uint = 4;
		public static const NONE:uint = 8;
		
		public static const SKILL_A:uint = 0;
		public static const SKILL_S:uint = 2;
		public static const SKILL_D:uint = 4;
		
		private	var idle:Boolean;
		
		public function Player(x:Number, y:Number, type:uint) 
		{
			var animationName:String;
			var frameWidth:int = 18;
			var frameHeight:int = 25;
			
			switch (type)
			{
				case 0:		animationName = "mage.png";		        frameWidth = 65;	frameHeight = 25;		break;
				case 2:		animationName = "rogue.png";		    frameWidth = 36;	frameHeight = 25;		break;
				case 4:		animationName = "fighter.png";			frameWidth = 64;	frameHeight = 33;		break;
				case 8:		animationName = "unclassed.png";		frameWidth = 57;	frameHeight = 25;		break;
			}
			
			super( x, y, Library.IMG(animationName), frameWidth, frameHeight, 18, 25);
			
			switch (type)
			{
				case 0:
					this.rangedType = Fireball;
					
					graphic.add("walk", [0, 1, 2, 3], 6, true);
					graphic.add("stand", [3], 0, true);
					graphic.add("attack", [4, 5, 6, 7], 12, false);
					graphic.add("casting", [4, 4, 4, 4], 12, false, true);
					graphic.add("climbUp", [8, 9, 10, 11], 8, true);
					graphic.add("climbDown", [11, 10, 9, 8], 8, true);
					graphic.add("climbIdle", [9], 0, true);
					graphic.add("death", [12, 13, 14, 15], 6, false, true);
					
					sound.addSFX("shoot", Library.SND("audio.sfx.fireball.mp3"));
					
					break;
				case 2:
					this.rangedType = Shuriken;
					
					graphic.add("walk", [0, 1, 2, 3], 6, true);
					graphic.add("stand", [3], 0, true);
					graphic.add("attack", [4, 5, 6, 7], 12, false);
					graphic.add("climbUp", [8, 9, 10, 11], 8, true);
					graphic.add("climbDown", [11, 10, 9, 8], 8, true);
					graphic.add("climbIdle", [9], 0, true);
					graphic.add("death", [12, 13, 14, 15], 6, false, true);
					
					this.sound.addSFX("shoot", Library.SND("audio.sfx.throw.mp3"));
					this.sound.addSFX("stab", Library.SND("audio.sfx.daggerStab.mp3"));
					this.sound.addSFX("blink", Library.SND("audio.sfx.blink.mp3"));
					
					break;
				case 4:
					this.rangedType = Arrow;
					
					graphic.add("walk", [0, 1, 2, 3], 6, true);
					graphic.add("stand", [3], 0, true);
					graphic.add("attack", [4, 5, 6, 7], 12, false);
					graphic.add("shield", [8, 9, 10, 11], 20, false, true);
					graphic.add("pull", [12, 13, 14, 15], 12, false, true);
					graphic.add("release", [16, 17, 18, 19], 18, false);
					graphic.add("climbUp", [20, 21, 22, 23], 8, true);
					graphic.add("climbDown", [23, 22, 21, 20], 8, true);
					graphic.add("climbIdle", [21], 0, true);
					graphic.add("death", [25, 26, 27, 28], 6, false, true);
					
					this.sound.addSFX("shoot", Library.SND("audio.sfx.bow.mp3"));
					this.sound.addSFX("stab", Library.SND("audio.sfx.swordSlash.mp3"));
					
					break;
				case 8:
					graphic.add("stand", [4], 0, true);
					graphic.add("walk", [0, 1, 2, 3], 6, true);
					graphic.add("getUp", [8, 9, 10, 11], 3, false);
				default:	
			}
			
			this.classType = type;
			
			graphic.play("stand");
			
			this.friendly = true;
			this.idle = false;
			
			this.hasCaltrop = true;
			this.blinkTimer = new Timer(0, 7);
			this.lightningAttack = null;
			this.boltPlaying = false;
			
			//TODO: Jake, could you make this be saved in SaveState, please?
			this.knowsA = SaveState.knowsA;
			this.knowsS = SaveState.knowsS
			this.knowsD = SaveState.knowsD;
		}
		
		public function get knowsA():Boolean
		{
			return SaveState.knowsA;
		}
		
		public function set knowsA(p:Boolean):void
		{
			SaveState.knowsA = p;
		}
		
		public function get knowsS():Boolean
		{
			return SaveState.knowsS;
		}
		
		public function set knowsS(p:Boolean):void
		{
			SaveState.knowsS = p;
		}
		
		public function get knowsD():Boolean
		{
			return SaveState.knowsD;
		}
		
		public function set knowsD(p:Boolean):void
		{
			SaveState.knowsD = p;
		}
		
		override public function think():void 
		{			
			if (HUD.healthAmount <= 0)
			{
				this.destroy();
				this.graphic.play("death");
			}
			
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
			this.graphic.playing != "release"		&&
			this.graphic.playing != "getUp"
			) this.idle = true;
			
			else this.idle = false;
			
			return this.idle;
		}
		
		override public function destroy():void 
		{
			if (this.isDestroyed)	return;
			
			var x:int = this.x <= Game.dimensions.x / 2 ? this.x - 50 : this.x + 50;
			WorldUtils.addDecal(Library.IMG("misc.enter.png"), x, this.y, function (d:Decal):*	{	d.alpha += 0.01;	}, function (d:Decal):*	{	d.alpha = 0;	} );
			
			super.destroy();
		}
		
		override public function preThink():void 
		{
			super.preThink();
			
			if (this.classType == Player.MAGE)	HUD.restoreMana(0.05);
		}
	}
}