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
			this.rangedType = Fireball;
		}
		
	}

}