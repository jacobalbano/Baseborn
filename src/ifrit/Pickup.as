package ifrit 
{
	import com.jacobalbano.Animation;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Pickup extends IfritObject
	{
		public static const HEALTH:uint = 0;
		public static const MANA:uint 	= 2;
		public static const	KEY:uint	= 4;
		public static const	ARROW:uint	= 8;
		public static const	SHURIKEN:uint	= 16;
		
		public var animation:Animation;
		protected var container:Sprite;
		
		public var type:uint;
		
		public var lifetime:int;
		
		/**
		 * Add a health or mana pickup item to the stage
		 * @param	x			X position of the pickup
		 * @param	y			Y position of the pickup
		 * @param	type		The type of pickup to drop, from static option flags
		 */
		public function Pickup(x:Number, y:Number, type:uint)
		{
			this.container = new Sprite;
			addChild(this.container);
			
			if 		(type == 0) this.animation = new Animation(Library.IMG("misc.healthDrop.png"), 15, 15);
			else if (type == 2)	this.animation = new Animation(Library.IMG("misc.manaDrop.png"), 15, 15);
			else if (type == 4) this.animation = new Animation(Library.IMG("misc.keyDrop.png"), 9, 21);
			else if (type == 8) this.animation = new Animation(Library.IMG("misc.arrowDrop.png"), 22, 9);
			else if (type == 16) this.animation = new Animation(Library.IMG("misc.shurikenDrop.png"), 10, 13);
			
			container.x = -15 /2;
			container.y = -15 /2;
			
			container.addChild(animation);
			
			this.animation.add("float", [0, 1, 2, 3, 4, 5], 10, true);
			this.animation.play("float");
			
			this.type = type;
		}
		
		override protected function update():void
		{
			if (this.type == Pickup.HEALTH || this.type == Pickup.MANA)
			{
				this.rotation += 10;
				lifetime++;
			}
		}
		
	}

}