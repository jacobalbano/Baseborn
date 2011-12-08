package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Demon extends Enemy
	{
		
		public function Demon(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("enemies.demon.png"), 16, 23, 14, 23, Enemy.NO_RANGED | Enemy.NO_FEAR);
			
			this.graphic.add("stand", [1], 6, true);
			this.graphic.add("walk", [0, 1, 2, 3], 6, true);
			this.graphic.add("attack", [8, 9, 10, 11], 6, false);
			this.graphic.add("die", [4, 5, 6, 7], 6, false);
			this.graphic.add("shocked", [12, 13, 14, 15], 6, false);
			this.graphic.play("walk");
			
			this.hitpoints = 15;
			this.maxHealth = 15;
		}
		
	}

}