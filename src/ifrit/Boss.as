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
		private var stopped:Boolean;
		private var stateFunctions:Array;
		public var state:uint;
		
		public function Boss(x:int, y:int) 
		{
			super(x, y, Library.IMG("enemies.boss.png"), 150, 111, 60, 111, Enemy.BRAIN_DEAD);
			
			this.lastPosition = new Point(x, y);
			
			this.sineTicks = 0;
			
			this.hitpoints = 100;
			
			this.hasGravity = false;
			
			this.heading = false;
			
			this.scythePoint = new Point(this.x, this.y);
			
			this.scytheHeading = true;
			
			this.canShoot = true;
			
			this.target = new Point;
			
			this.state = 15;
			
			this.stateFunctions = [
				runState1,
				runState2,
				runState3,
				runState4,
				runState5,
				runState6,
				runState7,
				runState8,
				runState9,
				runState10,
				runState11,
				runState12,
				runState13,
				runState14,
				runState15,
				runState16
			];
		}
		
		override public function preThink():void 
		{
			super.preThink();
			
			this.stateFunctions[this.state]();
		}
		
		private function runState1():void
		{
			this.y = this.x = 0;
			this.state = 1;
		}
		
		private function runState2():void 
		{
			y++;
			
			if (this.y > this.lastPosition.y + 25)	this.state = 2;
		}
		
		private function runState3():void 
		{
			if (Game.man.x >= 500)	return;
			
			this.lastPosition.y = this.y;
			
			this.state = 3;
			this.throwScythe();
		}
		
		private function runState4():void
		{
			if (!this.canShoot)	return;
			
			var positions:Array =
			[
				[725, 185],
				[850, 165],
				[890, 270],
				[700, 270],
				[400, 270],
				[960, 145]
			];
			
			for (var i:uint = 0; i < positions.length; i++)
			{
				WorldUtils.addDecal(Library.IMG("hellther.portal.png"), positions[i][0], positions[i][1], function (d:Decal):*
				{
					d.rotation += 5;
					d.alpha = Math.abs(d.rotation) / 180;
					if (d.alpha >= 1)
					{
						WorldUtils.addEnemy(d.x, d.y, Demon);
					}
					
					if (d.alpha <= 0)	Game.stage.removeChild(d);
					
				} );
			}
			
			Game.boss.state = 4;
		}
		
		private function runState5():void
		{
			var numAlive:uint;
			
			for (var i:uint = 0; i < World.Mobs.length; i++)
			{
				if (!World.Mobs[i].isDestroyed)	numAlive++;
			}
			
			if (numAlive == 2 &&  World.Mobs.length > 2 && !Game.man.isDestroyed && !Game.boss.isDestroyed)	this.state = 5;
		}
		
		private function runState6():void
		{
			y++;
			
			if (this.y > 200)	this.state = 6;
		}
		
		private function runState7():void 
		{
			var positions:Array =
			[
				[525, 185],
				[300, 270],
				[700, 270],
				[400, 270],
				[460, 145]
			];
			
			for (var i:uint = 0; i < positions.length; i++)
			{
				WorldUtils.addDecal(Library.IMG("hellther.portal.png"), positions[i][0], positions[i][1], function (d:Decal):*
				{
					d.rotation += 5;
					d.alpha = Math.abs(d.rotation) / 180;
					if (d.alpha >= 1)
					{
						WorldUtils.addEnemy(d.x, d.y, (new Boolean(Math.round(Math.random()))) ? Skeleton : Zombie );
					}
					
					if (d.alpha <= 0)	Game.stage.removeChild(d);
					
				} );
			}
			
			Game.boss.state = 7;
		}
		
		private function runState8():void
		{
			var numAlive:uint;
			
			for (var i:uint = 0; i < World.Mobs.length; i++)
			{
				if (!World.Mobs[i].isDestroyed)	numAlive++;
			}
			
			if (numAlive == 2 &&  World.Mobs.length > 8 && !Game.man.isDestroyed && !Game.boss.isDestroyed)	this.state = 8;
		}
		
		private function runState9():void
		{
			throwScythe();
			this.state = 9;
		}
		
		private function runState10():void
		{
			y++;
			
			if (this.y > 200)	this.state = 10;
		}
		
		private function runState11():void 
		{
			var positions:Array =
			[
				[725, 185],
				[850, 165],
				[890, 270],
				[700, 270],
				[960, 145]
			];
			
			for (var i:uint = 0; i < positions.length; i++)
			{
				WorldUtils.addDecal(Library.IMG("hellther.portal.png"), positions[i][0], positions[i][1], function (d:Decal):*
				{
					d.rotation += 5;
					d.alpha = Math.abs(d.rotation) / 180;
					if (d.alpha >= 1)
					{
						WorldUtils.addEnemy(d.x, d.y, SkeletonMage);
					}
					
					if (d.alpha <= 0)	Game.stage.removeChild(d);
					
				} );
			}
			
			Game.boss.state = 11;
		}
		
		private function runState12():void
		{
			x++;
			
			if (this.x > 200)	this.state = 12;
		}
		
		private function runState13():void
		{
			var numAlive:uint;
			
			for (var i:uint = 0; i < World.Mobs.length; i++)
			{
				if (!World.Mobs[i].isDestroyed)	numAlive++;
			}
			
			if (numAlive == 2 &&  World.Mobs.length > 15 && !Game.man.isDestroyed && !Game.boss.isDestroyed)	this.state = 13;
		}
		
		private function runState14():void 
		{
			if (this.y <= this.lastPosition.y + 25)	y++;
			if (this.x <= 280)	x++;
			
			this.stopped = true;
			
			if (this.y >= this.lastPosition.y + 25 && this.x >= 280)	this.state = 14;
		}
		
		private function runState15():void
		{
			if (this.x < 290 )
			{
				this.x++;
			}
			else
			{
				this.lastPosition.x = this.x;
				this.lastPosition.y = this.y;
				
				this.state = 15;
			}
			
			this.hasGravity = true;
		}
		
		private function runState16():void
		{
			this.x = this.lastPosition.x;
			
			if (this.hitpoints <= 0)
			{
				// Hard-coded up the wazoo. This is the code for the boss death "animation".
				//
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s1.png"), 259, 239, null, function(d:Decal):* { d.y--; } );
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s2.png"), 266, 239, null, function(d:Decal):* { d.y++; } );
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s3.png"), 273, 239, null, function(d:Decal):* { d.y--; } );
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s4.png"), 280, 239, null, function(d:Decal):* { d.y++; } );
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s5.png"), 287, 239, null, function(d:Decal):* { d.y--; } );
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s6.png"), 294, 239, null, function(d:Decal):* { d.y++; } );
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s7.png"), 301, 239, null, function(d:Decal):* { d.y--; } );
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s8.png"), 308, 239, null, function(d:Decal):* { d.y++; } );
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s9.png"), 315, 239, null, function(d:Decal):* { d.y--; } );
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s10.png"), 322, 239, null, function(d:Decal):* { d.y++; } );
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s11.png"), 329, 239, null, function(d:Decal):* { d.y--; } );
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s12.png"), 336, 239, null, function(d:Decal):* { d.y++; } );
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s13.png"), 343, 239, null, function(d:Decal):* { d.y--; } );
				WorldUtils.addDecal(Library.IMG("enemies.bossDeath.s14.png"), 350, 239, null, function(d:Decal):* { d.y++; } );
			}
		}
		
		override public function postThink():void 
		{			
			super.postThink();
			
			if (!this.isDestroyed)
			{				
				if (!this.stopped)	this.y += Math.sin(sineTicks += 0.1);
			}
			else
			{
				
			}
		}
		
		public function throwScythe():void
		{
			if (!canShoot)	return;
			this.canShoot = false;
			
			this.scytheHeading = true;
			this.scytheOffScreenYet = false;
			this.scythePoint = new Point(this.x, this.y);
			
			/**
			 * World's longest anonymous function
			 * All the behaviour code for the scythe is in here
			 */
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
				
				if (d.y <= Game.man.y && !scytheOffScreenYet)
				{
					d.y += 20;
				}
				else if (d.y >= Game.boss.y && d.x < Game.man.x && !scytheHeading)
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