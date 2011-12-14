package ifrit 
{
	import flash.geom.Point;
	
	/**
	 * @author Jake Albano
	 */
	
	public class PansyArcher extends Archer
	{
		
		public function PansyArcher(x:int, y:int) 
		{
			super(x, y);
			this.behaviorFlags = Enemy.STAND_GROUND | Enemy.NO_MELEE | Enemy.AFRAID;
			this.rangedType = UltraArrow;
		}
		
		override public function preThink():void 
		{
			super.preThink();
			
			if (!Game.man.isDestroyed && Point.distance(new Point(Game.man.x, Game.man.y), new Point(this.x, this.y)) < 200 && Math.abs(this.y - Game.man.y) < 15 && this.y < Game.man.y + 5)
			{
				this.shoot();
			}
		}
		
		override public function postThink():void 
		{
			super.postThink();
			
			
			if (this.fleeMode)	this.graphic.play("walk");
			else				this.graphic.play("stand");
		}
		
	}

}