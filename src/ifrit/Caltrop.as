package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.display.Sprite;
	
	/**
	 * @author Jake Albano
	 */
	public class Caltrop extends IfritObject 
	{
		
		public var friendly:Boolean;
		public var lastPosition:Point;
		
		public var hasPhysics:Boolean;
		public var stopped:Boolean;
		public var isStatic:Boolean;
		public var damage:Number;
		protected var container:Sprite;
		protected var dx:int;
		protected var vy:Number;
		protected var vx:Number;
		public var sound:Audio;
		
		public function Caltrop()
		{
			super();
			//Library.IMG("caltrop.png"), 12, 9, direction, x, y, friendly, 0, true);
			
			var graphic:Bitmap = Library.IMG("caltrop.png");
			
			if (Game.man.rotationY == 0)	this.vx = 3;
			else							this.vx = -3;
			
			this.hasPhysics = true;
			
			this.container = new Sprite;
			addChild(container);
			
			sound = new Audio;
			
			container.x = -graphic.width / 2; // Set registration point to center
			container.y = -graphic.height / 2;
			container.addChild(graphic);
			
			
			this.damage = 10;
			this.isStatic = true;
			
			this.vy = 0;
			
			this.x = Game.man.x;
			this.y = Game.man.y;
			
			this.lastPosition = new Point(this.x, this.y);
		}
		
		override protected function update():void 
		{
			super.update();
			
			this.lastPosition.x = this.x;
			this.lastPosition.y = this.y;
			
			for each(var p:Platform in World.Platforms)
			{
				if (this.hitTestObject(p))
				{
					if (this.y + this.height / 2 > p.y - p.height / 2)
					{
						this.y = p.y - p.height / 2 - this.height / 2;
					}
					this.stopped = true;
				}
			}
			
			if (!this.stopped)
			{
				this.sound.playSFX("fly");
				
				if (this.hasPhysics)
				{
					if (this.dx > 0)   	this.vx -= 0.05;
					if (this.dx < 0)   	this.vx += 0.05;
					
					this.vy += Rules.gravity;
					
					this.y += this.vy < 10 ? this.vy : 10;
					
				}
				
				this.x += vx;
				
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
					d.rotation = Math.atan2( y + vy - y, x + vx - x) * 180 / Math.PI;
				});
			}
		}
		
	}

}