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
		public var animation:Animation;
		protected var container:Sprite;
		
		public var type:Boolean;
		
		public var lifetime:int;
		
		/**
		 * Add a health or mana pickup item to the stage
		 * @param	x			X position of the pickup
		 * @param	y			Y position of the pickup
		 * @param	type		TRUE: health pickup, FALSE: mana pickup
		 */
		public function Pickup(x:Number, y:Number, type:Boolean)
		{
			 this.container = new Sprite;
			addChild(this.container);
			
			if (type) this.animation = new Animation(Library.IMG("healthDrop.png"), 15, 15);
			else this.animation = new Animation(Library.IMG("manaDrop.png"), 15, 15);
			
			container.x = -15 /2;
			container.y = -15 /2;
			
			container.addChild(animation);
			
			this.animation.add("float", [0, 1, 2, 3, 4, 5], 10, true);
			this.animation.play("float");
			
			this.type = type;
		}
		
		override protected function update():void
		{
			this.rotation += 10;
			lifetime++;
		}
		
	}

}