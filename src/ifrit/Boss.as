package ifrit 
{
	
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/**
	 * @author Jake Albano
	 */
	public class Boss extends Enemy 
	{
		
		private var floatDirection:Boolean;
		private var sineTicks:Number;
		private var scythePoint:Point;
		private var scytheHeading:Boolean;
		private var canShoot:Boolean;
		private var target:Point;
		private var scytheOffScreenYet:Boolean;
		public var state:uint;
		
		public function Boss(x:int, y:int) 
		{
			super(x, y, Library.IMG("enemies.boss.png"), 60, 111, 60, 111, Enemy.BRAIN_DEAD);
			
			this.lastPosition = new Point(x, y);
			
			this.sineTicks = 0;
			
			this.hitpoints = 100;
			
			this.hasGravity = false;
			
			this.heading = false;
			
			this.scythePoint = new Point(this.x, this.y);
			
			this.scytheHeading = true;
			
			this.canShoot = true;
			
			this.target = new Point;
			
			this.state = 0;
		}
		
		override public function preThink():void 
		{
			super.preThink();
			
			if (this.state == 0 && Game.man.x < 500)	runState1();
		}
		
		private function runState1():void 
		{
			this.state = 1;
			this.throwScythe();
		}
		
		override public function postThink():void 
		{			
			super.postThink();
			
			if (!this.isDestroyed)
			{
				if (this.x > 500)
				{
					this.x -= 2;
					trace("turn");
					this.heading = true;
				}
				
				if (this.y < this.target.y)	y++;
				if (this.x < this.target.y)	x++;
				
				this.y += Math.sin(sineTicks += 0.1);
			}
		}
		
		public function throwScythe():void
		{
			if (!canShoot)	return;
			this.canShoot = false;
			
			this.scytheHeading = true;
			this.scytheOffScreenYet = false;
			this.scythePoint = new Point(this.x, this.y);
			
			WorldUtils.addDecal(Library.IMG("enemies.scythe.png"), Game.boss.x, Game.boss.y, function (d:Decal):*
			{
				d.rotation += scythePoint.x;
				
				d.x += scythePoint.x;
				
				if (d.x > Game.dimensions.x / 2)
				{
					scythePoint.x -= 2;
				}
				else
				{
					scythePoint.x += 2;
				}
				
				if (scytheHeading && d.x >= 500)
				{
					scytheHeading = false;
				}
				
				if (d.x > 1000)
				{
					scytheOffScreenYet = true;
				}
				
				if (!scytheHeading && d.rotationY < 180)
				{
					d.rotationY += 5;
				}
				
				if (d.y <= 250 && !scytheOffScreenYet)
				{
					d.y += 20;
				}
				else if (d.y >= 50 && d.x < Game.dimensions.x / 2 && !scytheHeading)
				{
					d.y -= 20;
				}
				
				if (Point.distance(new Point(Game.man.x, Game.man.y), new Point(d.x, d.y)) < 20)	HUD.damagePlayer(10, true);
				
				if (d.hitTestObject(Game.boss.collisionHull) && !scytheHeading)
				{
					Game.stage.removeChild(d);
					d.destroy();
					Game.boss.canShoot = true;
				}
				
				if (Math.abs(scythePoint.x) > 15 && !d.isDestroyed)
				{
					var decal:Decal = new Decal(new Bitmap(new BitmapData(d.width / 2, d.height / 2, true, 0x11666666)), 0, 0, function (dd:Decal):*
					{
						dd.alpha -= 0.0575;
						dd.rotation += 30;
						if (dd.alpha <= 0)	Game.stage.removeChild(dd);
					});
					
					decal.x = d.x;
					decal.y = d.y;
					
					decal.rotation = 45;
					Game.stage.addChildAt(decal, Game.stage.getChildIndex(d) - 1);
				}
			});
		}
		
	}

}