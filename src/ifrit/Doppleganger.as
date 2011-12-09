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
			//TODO: This needs to work with rogue doppelgangers
			
			var imageString:String;
			var animWidth:int;
			var animHeight:int;
			
			if (Game.playerClass == Player.FIGHTER)
			{
				imageString = "enemies.fighterDop.png";
				animHeight = 33;
				animWidth = 64;
			}
			if (Game.playerClass == Player.ROGUE)
			{
				imageString = "enemies.rogueDop.png";
				animHeight = 25;
				animWidth = 36;
			}
			if (Game.playerClass == Player.MAGE)
			{
				imageString = "enemies.mageDop.png";
				animHeight = 25;
				animWidth = 65;
			}
			
			super(x, y, Library.IMG(imageString), animWidth, animHeight, 18, 25, BRAIN_DEAD | NO_RANGED);
			
			
			this.graphic.add("stand", [1], 6, true);
			this.graphic.add("walk", [0, 1, 2, 3], 6, true);
			this.graphic.add("attack", [8, 9, 10, 11], 6, false);
			this.graphic.add("die", [4, 5, 6, 7], 6, false);
			this.graphic.add("shocked", [12, 13, 14, 15], 6, false);
			this.graphic.play("stand");
			
			this.hitpoints = 300;
			this.maxHealth = 300;
			this.tipsOverWhenDead = false;
		}
		
		override public function postThink():void
		{
			this.hitpoints += 0.05;
			if (this.hitpoints <= 0)	this.destroy();
		}
		
	}

}