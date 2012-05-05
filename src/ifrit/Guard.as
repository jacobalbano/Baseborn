package ifrit 
{
	import com.thaumaturgistgames.flakit.Library
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Guard extends Enemy
	{
		
		public function Guard(x:Number, y:Number) 
		{
			super(x, y, Library.getImage("enemies.guard.png"), 60, 23, 13, 23, NO_RANGED);
			
			this.graphic.add("stand", [1], 6, true);
			this.graphic.add("walk", [0, 1, 2, 3], 6, true);
			this.graphic.add("attack", [8, 9, 10, 11], 6, false);
			this.graphic.add("die", [4, 5, 6, 7], 6, false);
			this.graphic.add("shocked", [12, 13, 14, 15], 6, false);
			this.graphic.play("walk");
			
			this.sound.addSFX("stab", Library.getSound("audio.sfx.swordSlash.mp3"));
			
			this.hitpoints = 25;
			this.maxHealth = 25;
		}
		
	}

}