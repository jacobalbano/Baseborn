package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Chris Logsdon
	 */
	public class Fireball extends Sprite
	{		
		public var fireball:Bitmap = Library.IMG("shuriken.png");
		protected var fireballC:Sprite = new Sprite();
		
		private var dx:int;
		
		public var friendly:Boolean;
		
		public function Fireball(direction:int, x:Number, y:Number, friendly:Boolean = true) 
		{
			addChild(fireballC);
			
			fireballC.x = fireball.x - (fireball.width / 2);
			fireballC.y = fireball.y - (fireball.height / 2);
			
			fireballC.addChild(fireball);
			
			dx = direction;
			this.x = x;
			this.y = y;
			
			this.friendly = friendly;
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void 
		{
			this.x += dx;
			if (dx < 0) { this.rotation -= 20; }
			else if (dx > 0) { this.rotation += 20; }
		}
		
	}

}