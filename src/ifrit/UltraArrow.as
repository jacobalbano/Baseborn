package ifrit 
{
	/**
	 * @author Jake Albano
	 */
	public class UltraArrow extends Arrow 
	{
		
		public function UltraArrow(direction:int, x:int, y:int, friendly:Boolean = true) 
		{
			super(direction, x, y, friendly);
			this.damage = 30;
		}
		
	}

}