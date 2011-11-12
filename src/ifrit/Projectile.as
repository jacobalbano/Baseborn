package ifrit 
{
	import com.jacobalbano.Animation;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author Jake Albano
	 */
	public class Projectile extends Sprite implements IUnloadable
	{
		
		public var animation:Animation;
		protected var container:Sprite = new Sprite();
		
		protected var dx:int;
		protected var vy:Number;
		
		protected var hasPhysics:Boolean;
		
		public var friendly:Boolean;
		
		public function Projectile(bitmap:Bitmap, frameWidth:int, frameHeight:int, direction:int, x:Number, y:Number, friendly:Boolean = true) 
		{
			addChild(container);
			
			this.animation = new Animation(bitmap, frameWidth, frameHeight);
			
			container.x = -frameWidth /2;
			container.y = -frameHeight /2;
			
			container.addChild(animation);
			
			dx = direction;
			this.x = x;
			this.y = y;
			
			vy = 0;
			this.friendly = friendly;
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			this.rotationY = direction > 0 ? 0 : 180;
		}
		
		/**
		 * Override this; called in enterFrame
		 */
		public function update():void
		{
			
		}
		
		public function unload():void
		{
			destroy();
		}
		
		public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void 
		{
			this.vy += 0.01;
			if (this.hasPhysics)	this.y += this.vy;
			
			/**
			 * Debugging information; displays trajectory
			 * Uncomment the lines below to see in action
			 */
			//var bmp:Bitmap = new Bitmap(new BitmapData(10, 1, false, 0xff0000));
			//bmp.x = this.x;
			//bmp.y = this.y;
			//Game.stage.addChild(bmp);
			
			this.x += dx;
			
			this.update();
		}
		
	}

}