package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Zombie extends Enemy
	{
		
		public function Zombie(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("enemies.zombie.png"), 36, 25, 15, 25, Enemy.NO_FEAR | Enemy.NO_RANGED);
			
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