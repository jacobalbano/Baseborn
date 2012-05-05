package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Archer extends Enemy
	{
		
		public function Archer(x:Number, y:Number) 
		{
			super(x, y, Library.getImage("enemies.archer.png"), 60, 23, 13, 23, Enemy.NO_MELEE);
			this.rangedType = Arrow;
			
			this.graphic.add("stand", [1], 6, true);
			this.graphic.add("walk", [0, 1, 2, 3], 6, true);
			this.graphic.add("attack", [8, 9, 10, 11], 6, false);
			this.graphic.add("die", [4, 5, 6, 7], 6, false);
			this.graphic.add("shocked", [12, 13, 14, 15], 6, false);
			this.graphic.play("walk");
			
			this.sound.addSFX("shoot", Library.getSound("audio.sfx.bow.mp3"));
			
			this.hitpoints = 20;
			this.maxHealth = 20;
		}
		
	}

}