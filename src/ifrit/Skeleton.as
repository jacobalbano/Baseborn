package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Skeleton extends Enemy
	{
		
		public function Skeleton(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("enemies.skeleton.png"), 30, 47, 13, 47, Enemy.NO_FEAR | Enemy.NO_RANGED);
			
			this.graphic.add("stand", [0], 6, true);
			this.graphic.add("walk", [0, 1, 2, 3], 6, true);
			this.graphic.add("die", [6, 7, 8, 9], 3, false);
			this.graphic.add("shocked", [10, 11, 12, 13], 6, false);
			this.graphic.play("walk");
		}
		
	}

}