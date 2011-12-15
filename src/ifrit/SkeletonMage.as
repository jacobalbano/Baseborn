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
			
			this.graphic.add("stand", [0], 6, true);
			this.graphic.add("walk", [0, 1, 2, 3], 6, true);
			this.graphic.add("attack", [0], 6, false);
			this.graphic.add("die", [6, 7, 8, 9], 3, false);
			this.graphic.add("shocked", [0, 1, 2, 3], 6, false);
			this.graphic.play("walk");
			
			this.sound.addSFX("shoot", Library.SND("audio.sfx.fireball.mp3"));
			
			this.hitpoints = 15;
			this.maxHealth = 15;
			this.tipsOverWhenDead = false;
		}
		
	}

}