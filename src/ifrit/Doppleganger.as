package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Doppleganger extends Enemy
	{
		
		public function Doppleganger(x:Number, y:Number) 
		{
			//TODO: Jake, how would I get the commented code below to happen?
			//I'm just not very comfortable or familiar with super()
			
			//if (Game.playerClass == Player.FIGHTER)
			//{
				super(x, y, Library.IMG("enemies.mageDop.png"), 65, 25, 18, 25, BRAIN_DEAD | NO_RANGED);
			//}
			//if (Game.playerClass == Player.ROGUE)
			//{
				//super(x, y, Library.IMG("enemies.fighterDop.png"), 64, 33, 18, 25, BRAIN_DEAD | NO_RANGED);
			//}
			//if (Game.playerClass == Player.MAGE)
			//{
				//super(x, y, Library.IMG("enemies.mageDop.png"), 65, 25, 18, 25, BRAIN_DEAD | NO_RANGED);
			//}
			
			
			this.graphic.add("stand", [1], 6, true);
			this.graphic.add("walk", [0, 1, 2, 3], 6, true);
			this.graphic.add("attack", [8, 9, 10, 11], 6, false);
			this.graphic.add("die", [4, 5, 6, 7], 6, false);
			this.graphic.add("shocked", [12, 13, 14, 15], 6, false);
			this.graphic.play("walk");
			
			this.hitpoints = 300;
			this.maxHealth = 300;
		}
		
		override public function postThink():void
		{
			this.hitpoints += 0.05;
			if (this.hitpoints <= 0)	this.destroy();
		}
		
	}

}