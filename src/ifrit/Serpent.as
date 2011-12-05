package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Serpent extends Enemy
	{
		
		public function Serpent(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("enemies.serpent.png"), 75, 34, 65, 20, NO_RANGED | NO_FEAR);
			
			this.graphic.add("stand", [1], 6, true);
			this.graphic.add("walk", [0, 1, 2, 3, 4, 5], 6, true);
			this.graphic.add("attack", [6, 7, 8, 9], 6, false);
			this.graphic.add("die", [12, 13, 14, 15, 16, 17], 6, false);
			this.graphic.add("shocked", [18, 19, 20, 21], 6, false);
			this.graphic.play("walk");
			
			this.hitpoints = 15;
			this.maxHealth = 15;
		}
		
	}

}