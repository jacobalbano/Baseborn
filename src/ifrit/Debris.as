package ifrit 
{
	import com.thaumaturgistgames.flakit.Library
	import flash.geom.Point;
	import ifrit.IfritObject;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Debris extends Enemy
	{
		private var fixedPosition:Point;
		
		public function Debris(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("beach.dynamicDebris.png"), 54, 33, 57, 33, Enemy.BRAIN_DEAD | Enemy.PASSIVE);
			
			this.fixedPosition = new Point(x, y);
			this.graphic.add("togther", [0], 6, true);
			this.graphic.add("damage1", [1], 6, true);
			this.graphic.add("damage2", [2], 6, true);
			this.graphic.add("damage3", [3], 6, true);
			this.graphic.add("damage4", [4], 6, true);
			this.graphic.add("damage5", [5], 6, true);
			this.graphic.add("die", [5, 6, 7, 8, 9], 6, false, true);
			this.graphic.play("together");
			
			this.hitpoints = 30;
			this.maxHealth = 30;
		}
		
		override public function preThink():void 
		{
			super.preThink();
			
			this.x = this.fixedPosition.x;
			this.y = this.fixedPosition.y;
		}
		
		override public function postThink():void
		{	
			if (this.hitpoints < 30 && this.hitpoints >= 25)	this.graphic.play("damage1");
			if (this.hitpoints < 25 && this.hitpoints >= 20) 	this.graphic.play("damage2");
			if (this.hitpoints < 20 && this.hitpoints >= 15) 	this.graphic.play("damage3");
			if (this.hitpoints < 15 && this.hitpoints >= 10) 	this.graphic.play("damage4");
			if (this.hitpoints < 10 && this.hitpoints >= 5) 	this.graphic.play("damage5");
			if (this.hitpoints <= 0)	this.destroy();
		}
		
	}

}