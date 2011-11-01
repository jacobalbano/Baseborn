package
{
	import com.jacobalbano.Input;
	import com.thaumaturgistgames.flakit.Engine;
	import flash.display.DisplayObject;
	import ifrit.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.geom.Point;
	
	
	
	[SWF(width = "1000", height = "400", backgroundColor = "0xFFFFFF")]
	public class Game extends Engine 
	{
		public static var text:TextField = new TextField();
		
		public const MAX_X:uint = stage.stageWidth;
		public const MIN_X:uint = 0;
		public const MAX_Y:uint = stage.stageHeight;
		public const MIN_Y:uint = 0;
		
		public var man:Player;
		public static var Projectiles:Vector.<Fireball>;
		public static var Mobs:Vector.<Mob>;
		public static var Platforms:Vector.<Platform>;
		
		public function Game()	{}
		
		override public function init():void 
		{
			super.init();
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			Input.init(stage);
			
			Platforms = new Vector.<Platform>;
			Projectiles = new Vector.<Fireball>;
			Mobs = new Vector.<Mob>;
			
			Mobs.push(stage.addChild(man = new Player(50, 260)) as Mob);
			
			addEnemy(250, 375);
			addEnemy(450, 350);
			addEnemy(170, 320);
			addEnemy(30, 280);
			addEnemy(310, 250);		
			addEnemy(640, 250);	
			
			addWall(250, 375, false);
			addWall(450, 350, false);
			addWall(170, 320, false);
			addWall(30, 280, false);
			addWall(310, 250, false);
			addWall(640, 250, false);
			addWall(700, 320, true);
			
			addChild(text);
		}
		
		private function enterFrame(e:Event):void
		{
			if (Input.isKeyDown(Input.LEFT))
			{
				man.x -= 7;
				man.rotationY = 180;
			}
			if (Input.isKeyDown(Input.RIGHT))
			{
				man.x += 7;
				man.rotationY = 0;
			}
			
			if (Input.isKeyDown(Input.SPACE))
			{
				man.jumping = true;
			}
			else man.jumping = false;
			
			if (Input.isKeyDown(Input.D) )
			{
				man.shoot();
			}
			
			if (Mobs.length > 0)
			{
				for (var l:int = Mobs.length - 1; l >= 0; l--)
				{
					if (Projectiles.length > 0)
					{						
						for (var k:int = Projectiles.length - 1; k >= 0; k--) 
						{
							if (Point.distance(new Point(Mobs[l].x, Mobs[l].y), new Point(Projectiles[k].x, Projectiles[k].y) ) <= Projectiles[k].width / 2)
							{
								if (Projectiles[k].friendly != Mobs[l].friendly)
								{
									stage.removeChild(Projectiles[k]);
									Projectiles.splice(k, 1);
									
									Mobs[l].destroy();
									stage.removeChild(Mobs[l]);
									Mobs.splice(l, 1);
									trace("hit");
									continue;
								}
							}
						}
					}
				}	
			}
			
			if (Platforms.length > 0)
			{
				for (var ii:int = Platforms.length - 1; ii >= 0; ii--)
				{
					if (Projectiles.length > 0)
					{						
						for (var j:int = Projectiles.length - 1; j >= 0; j--) 
						{
							if (Projectiles[j].x > stage.stageWidth + 20 || Projectiles[j].x < MIN_X - 20)
							{
								stage.removeChild(Projectiles[j]);
								Projectiles.splice(j, 1);
								continue;
							}
							
							if (Platforms[ii].collide(Projectiles[j] ) )
							{
								stage.removeChild( Projectiles[j] );
								Projectiles.splice(j, 1);
								continue;
							}
						}
					}
					
					if (Mobs.length > 0)
					{
						for (var jj:int = Mobs.length - 1; jj >= 0; jj--) 
						{
							Platforms[ii].collide(Mobs[jj] );
						}
					}
				}
			}
			
		}
		
		private function addWall(x:Number, y:Number, vertical:Boolean):void
		{
			Platforms.push(	addChild(new Platform(x, y, vertical) ) );
		}
		
		private function addEnemy(x:Number, y:Number):void
		{
			Mobs.push(stage.addChild(new Enemy(x, y) ) as Mob);		
		}
		
	}

}