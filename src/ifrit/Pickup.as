package ifrit 
{
	import com.jacobalbano.Animation;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Pickup extends IfritObject
	{
		public var animation:Animation;
		protected var container:Sprite = new Sprite();
		
		private var type:Boolean;
		
		/**
		 * Add a health or mana pickup item to the stage
		 * @param	x		X position of the pickup
		 * @param	y		Y position of the pickup
		 * @param	type	TRUE: health pickup, FALSE: mana pickup
		 */
		public function Pickup(x:Number, y:Number, type:Boolean) 
		{
			addChild(container);
			
			if (type) this.animation = new Animation(Library.IMG("healthDrop.png"), 15, 18);
			else this.animation = new Animation(Library.IMG("manaDrop.png"), 15, 18);
			
			container.x = -15 /2;
			container.y = -18 /2;
			
			container.addChild(animation);
			
			this.animation.add("float", [0, 1, 2, 3, 4, 5], 10, true);
			this.animation.play("float");
			
			this.type = type;
		}
		
		//TODO: Test if picked up. Possibly wrong location for this...
		//public function testCollision(player:DisplayObject):void
		//{
			//if (this.hitTestObject(player))
			//{
				//trace("pickup")
				//
				//if (type) HUD.healPlayer(10, true);
				//else HUD.restoreMana(10, true);
				//
				//stage.removeChild(this);
			//}
		//}
	}

}