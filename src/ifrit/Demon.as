package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Demon extends Enemy
	{
		public function Demon(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("enemies.demon.png"), 16, 23, 14, 23, Enemy.NO_RANGED | Enemy.NO_FEAR);
			
			this.graphic.add("stand", [1], 6, true);
			this.graphic.add("walk", [0, 1, 2, 3], 6, true);
			this.graphic.add("die", [5, 6, 7, 8, 9], 9, false);
			this.graphic.add("attack", [10, 11, 12, 13], 6, false);
			this.graphic.add("shocked", [14, 15, 16, 17], 6, false);
			this.graphic.play("walk");
			
			this.sound.addSFX("attack", Library.SND("audio.sfx.demon.mp3"));
			
			this.hitpoints = 15;
			this.maxHealth = 15;
			this.tipsOverWhenDead = false;
		}
		
	}

}