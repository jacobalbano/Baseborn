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
			super(x, y, Library.getImage("enemies.elfMage.png"), 60, 23, 13, 23);
			this.rangedType = Fireball;
			
			this.graphic.add("stand", [0], 6, true);
			this.graphic.add("walk", [0, 1, 2, 3], 6, true);
			this.graphic.add("attack", [0], 6, false);
			this.graphic.add("die", [6, 7, 8, 9], 6, false);
			this.graphic.add("shocked", [10, 11, 12, 13], 6, false);
			this.graphic.play("walk");
			
			this.sound.addSFX("shoot", Library.getSound("audio.sfx.fireball.mp3"));
			
			this.hitpoints = 15;
			this.maxHealth = 15;
		}
		
	}

}