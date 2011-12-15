package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Wolf extends Enemy
	{
		
		public function Wolf(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("enemies.wolf.png"), 42, 31, 38, 29, Enemy.NO_FEAR | Enemy.NO_RANGED);
			
			this.graphic.add("stand", [1], 6, true);
			this.graphic.add("walk", [0, 1, 2, 3], 3, true);
			this.graphic.add("attack", [4, 5, 6, 7], 6, false);
			this.graphic.add("die", [8, 9, 10, 11], 6, false);
			this.graphic.add("shocked", [12, 13, 14, 15], 6, false);
			this.graphic.play("walk");
			
			this.sound.addSFX("stab", Library.SND("audio.sfx.wolfAttack.mp3"));
			
			this.hitpoints = 15;
			this.maxHealth = 15;
			this.tipsOverWhenDead = false;
		}
		
	}

}