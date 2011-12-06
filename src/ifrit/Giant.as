package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Giant extends Enemy
	{
		
		private var fixedPosition:Point;
		
		public function Giant(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("enemies.giant.png"), 219, 399, 63, 399, Enemy.BRAIN_DEAD | Enemy.PASSIVE);
			
			this.fixedPosition = new Point(x, y);
			this.graphic.add("sleep", [0, 1, 2, 3], 6, true);
			this.graphic.play("sleep");
			
			//	IT'S OVER 9000! :D
			this.hitpoints = 9001;
			this.maxHealth = 9001;
			
			this.collisionHull.visible = true;
			this.collisionHull.alpha = 0.5;
		}
		
		override public function preThink():void 
		{
			super.preThink();
			
			this.x = this.fixedPosition.x;
			this.y = this.fixedPosition.y;
		}
		
	}

}