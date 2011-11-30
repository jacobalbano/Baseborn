package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * @author Jake Albano
	 */
	public class SkeletonMage extends Enemy
	{
		
		public function SkeletonMage(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("enemies.skeletonMage.png"), 30, 47, 13, 47, Enemy.NO_FEAR);
			this.rangedType = Fireball;
		}
		
	}

}