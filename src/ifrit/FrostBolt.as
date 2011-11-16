package ifrit 
{
	import com.jacobalbano.Animation;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Sprite;
	
	
	
	/**
	 * @author Jake Albano
	 */
	public class FrostBolt extends IfritObject
	{
		public var freeze:Animation;
		public var finished:Boolean;
		protected var container:Sprite;
		
		public function FrostBolt(direction:Boolean, x:Number, y:Number) 
		{
			container = new Sprite();
			addChild(container);
			freeze = new Animation(Library.IMG("iceBlast.png"), 22, 23);
			container.x = -22 / 2;
			container.y = -23 / 2;
			container.addChild(freeze);
			
			freeze.add("play", [0, 1, 2, 3], 15, false);
			freeze.play("play");
			
			if (direction)	this.x = x - 20;
			else 			this.x = x + 20;	
			
			this.y = y;
			
			if (direction)	this.rotationY = 180;
			else 			this.rotationY = 0;
			
			HUD.actionCost(false, 0, 50);
		}
		
		override protected function update():void 
		{
			if (this.freeze.playing != "play")
			{
				this.finished = true;
			}
		}
		
	}

}