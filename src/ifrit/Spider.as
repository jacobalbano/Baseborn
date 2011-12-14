package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Spider extends Enemy
	{
		
		public function Spider(x:Number, y:Number) 
		{
			super(x, y, Library.IMG("enemies.spider.png"), 61, 22, 58, 22, Enemy.NO_MELEE | Enemy.AFRAID);
			this.rangedType = Web;
			
			this.graphic.add("stand", [1], 6, true);
			this.graphic.add("walk", [0, 1, 2, 3], 6, true);
			this.graphic.add("attack", [8, 9, 10, 11], 6, false);
			this.graphic.add("die", [4, 5, 6, 7], 6, false);
			this.graphic.add("shocked", [12, 13, 14, 15], 6, false);
			this.graphic.play("walk");
			
			this.sound.addSFX("attack", Library.SND("audio.sfx.spiderHiss.mp3"));
			
			this.hitpoints = 15;
			this.maxHealth = 15;
			this.tipsOverWhenDead = false;
		}
		
	}

}