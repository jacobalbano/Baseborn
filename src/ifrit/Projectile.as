package ifrit 
{
	import com.jacobalbano.Animation;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	/**
	 * @author Jake Albano
	 */
	public class Projectile extends IfritObject
	{
		
		public var friendly:Boolean;
		public var animation:Animation;
		public var lastPosition:Point;
		
		public var hasPhysics:Boolean;
		public var stopped:Boolean;
		public var isStatic:Boolean;
		public var damage:Number;
		protected var container:Sprite;
		protected var dx:int;
		protected var vy:Number;
		protected var vx:Number;
		protected var isBallistic:Boolean;
		protected var lifetime:uint;
		protected var timeToLive:uint;
		protected var hasLifetime:Boolean;
		
		public var sound:Audio = new Audio;
		
		public function Projectile(bitmap:Bitmap, frameWidth:int, frameHeight:int, direction:int, x:Number, y:Number, friendly:Boolean = true, timeToLive:uint = 0, isBallistic:Boolean = false) 
		{
			
			this.container = new Sprite;
			addChild(container);
			
			this.animation = new Animation(bitmap, frameWidth, frameHeight);
			
			this.container.x = -frameWidth /2;
			this.container.y = -frameHeight /2;
			
			this.container.addChild(this.animation);
			
			this.dx = direction;
			this.x = x;
			this.y = y;
			
			this.lastPosition = new Point;
			
			this.vy = 0;
			this.vx = this.dx;
			this.friendly = friendly;
			
			if (timeToLive > 0)
			{
				this.hasLifetime = true;
				this.lifetime = 0;
				this.timeToLive = timeToLive;
			}
			
			this.isBallistic = isBallistic;
			
			if (!this.isBallistic)
			{
				this.rotationY = direction > 0 ? 0 : 180;
			}
		}
		
		public function stop():void
		{
			this.vx = 0;
			this.vy = 0;
			this.stopped = true;
		}
		
		override protected function update():void 
		{
			super.update();
			
			this.lastPosition.x = this.x;
			this.lastPosition.y = this.y;
			
			if (!this.stopped)
			{
				this.sound.playSFX("fly");
				
				if (this.hasPhysics)
				{
					if (this.dx > 0)   	this.vx -= 0.05;
					if (this.dx < 0)   	this.vx += 0.05;
					
					if (Math.abs(this.vx) < 6)	this.vy += 0.2;
					else						this.vy += 0.05;
					
					
					if (this.isBallistic)
					{
						this.rotation = Math.atan2( this.y + this.vy - this.y, this.x + this.vx - this.x) * 180 / Math.PI;
					}
					
					this.y += this.vy;
					
				}
				
				if (this.hasLifetime)
				{
					if (this.lifetime++ >= this.timeToLive)
					{
						this.alpha -= 0.2;
					}
					
					if (this.alpha <= 0)
					{
						this.destroy();
						return;
					}
				}
				
				this.x += vx;
				
				if (!(this is MeleeSwing || this is Web))
				{
					var pix:BitmapData = new BitmapData(this.width, this.height, true, 0);
					pix.draw(this);
					var bmp:Bitmap = new Bitmap(new BitmapData(10, 2, false, pix.getPixel(0, 0)));
					
					bmp.x = this.x;
					bmp.y = this.y;
					WorldUtils.addDecal(bmp, bmp.x, bmp.y,
					function (d:Decal):void
					{
						if (d.alpha > 0) 	d.alpha -= 0.05;
						if (d.alpha <= 0)	Game.stage.removeChild(d);
					},
					function (d:Decal):void
					{
						d.alpha = alpha;
						d.rotation = Math.atan2( y + vy - y, x + vx - x) * 180 / Math.PI;
					});
				}
			}
		}
		
	}

}