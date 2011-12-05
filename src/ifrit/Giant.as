package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Giant extends Enemy
	{
		
		public function Giant(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("enemies.giant.png"), 174, 399, 63, 399, Enemy.BRAIN_DEAD | Enemy.PASSIVE);
			
			this.graphic.add("sleep", [0, 1, 2, 3], 6, true);
			//this.graphic.add("walk", [0, 1, 2, 3], 3, true);
			//this.graphic.add("attack", [4, 5, 6, 7], 6, false);
			//this.graphic.add("die", [8, 9, 10, 11], 6, false);
			//this.graphic.add("shocked", [12, 13, 14, 15], 6, false);
			this.graphic.play("sleep");
			
			this.hitpoints = 9001;
			this.maxHealth = 9001;
		}
		
	}

}