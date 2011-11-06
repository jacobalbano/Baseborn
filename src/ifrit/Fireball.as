package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.BitmapData;
	
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
		private var vy:Number;
		
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
			
			vy = 0;
			this.friendly = friendly;
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void 
		{
			this.vy += 0.02;
			this.y += this.vy;
			
			/**
			 * Debugging information; displays trajectory
			 * Uncomment the lines below to see in action
			 */
			//var bmp:Bitmap = new Bitmap(new BitmapData(10, 1, false, 0xff0000));
			//bmp.x = this.x;
			//bmp.y = this.y;
			//Game.stage.addChild(bmp);
			
			this.x += dx;
			if (dx < 0) { this.rotation -= 20; }
			else if (dx > 0) { this.rotation += 20; }
		}
		
	}

}