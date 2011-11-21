package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * @author Jake Albano
	 */
	public class ElfMage extends Enemy 
	{
		
		public function ElfMage(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("enemies.elfMage.png"), 60, 23, 13, 23);
			this.rangedType = Fireball;
		}
		
	}

}