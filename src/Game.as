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
		
		public static var man:Player;
		public static var Projectiles:Vector.<Fireball>;
		public static var Mobs:Vector.<Mob>;
		public static var Platforms:Vector.<Platform>;
		
		//////////////////////
		private var boltAttack:LightningBolt;
		private var bolting:Boolean; // Lightning bolt animation is playing
		public var boltTime:Timer = new Timer(30, 0);
		
		//////////////////////
		
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
			addEnemy(1000, 400);
			
			addWall(250, 375, false);
			addWall(450, 350, false);
			addWall(170, 320, false);
			addWall(30, 280, false);
			addWall(310, 250, false);
			addWall(640, 250, false);
			addWall(700, 320, true);
			
			boltAttack = null;
			bolting = false;
			
			addChild(text);
		}
		
		private function enterFrame(e:Event):void
		{
			if (Input.isKeyDown(Input.LEFT))
			{
				stopBolt();
				if (man.graphic.playing != "attack") man.graphic.play("walk");
				man.x -= 7;
				man.rotationY = 180;
			}
			else if (Input.isKeyDown(Input.RIGHT))
			{
				stopBolt();
				if (man.graphic.playing != "attack") man.graphic.play("walk");
				man.x += 7;
				man.rotationY = 0;
			}
			else
			{
				if (man.graphic.playing != "attack") man.graphic.play("stand", true);
			}
			
			if (man.canJump)
			{
				if (Input.isKeyDown(Input.SPACE))
				{
					man.jumping = true;
					man.canJump = false;
				}
			}
			else man.jumping = false;
			
			if (Input.isKeyDown(Input.D) )
			{
				man.graphic.play("attack");
				man.shoot();
			}
			
			//////////////////Magic Targeting System///////////////////
			//FIXME: Stop player from moving when shooting target spell
			if (Input.isKeyDown(Input.S))
			{
				if ( !(Input.isKeyDown(Input.LEFT) || Input.isKeyDown(Input.RIGHT) ) )
				{
					man.graphic.play("attack"); //TODO: Stop animation on last frame
					if (!boltAttack)
					{
						if (man.rotationY == 0)
						{
							boltAttack = new LightningBolt(true, man.x, man.y);
							stage.addChild(boltAttack);
						}
						else if (man.rotationY == 180)
						{
							boltAttack = new LightningBolt(false, man.x, man.y);
							stage.addChild(boltAttack);
						}
					}
				}
			}
			else
			{
				if (boltAttack)
				{
					boltTime.start();
					boltAttack.sendBolt();
				}
			}
			
			if (boltTime.currentCount >= 12)
			{
				stopBolt();
			}
			///////////////////////////////////////////////////////////
			
			if (Mobs.length > 0)
			{
				for (var l:int = Mobs.length - 1; l >= 0; l--)
				{
					var removed:Boolean = false;
					
					if (Projectiles.length > 0)
					{						
						for (var k:int = Projectiles.length - 1; k >= 0; k--) 
						{
							if (Projectiles[k].hitTestObject(Mobs[l]))
							{
								if (Projectiles[k].friendly != Mobs[l].friendly)
								{
									stage.removeChild(Projectiles[k]);
									Projectiles.splice(k, 1);
									
									//Mobs[l].destroy();
									//stage.removeChild(Mobs[l]);
									//Mobs.splice(l, 1);
									Mobs[l].hitpoints -= 5;
									
									removed = true;
									
									break;
								}
							}
						}
					}
					
					if (boltAttack && boltTime.running)
					{
						bolting = true;
						
						if (boltTime.currentCount >= 4)
						{
							if (bolting && Mobs[l].hitTestObject(boltAttack.bolt))
							{
								if (!Mobs[l].friendly)
								{
									Mobs[l].hitpoints -= 10;
								}
							}
						}
					}
					
					if (removed) break;
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
		
		private function stopBolt():void
		{
			if (!boltAttack) return;
			
			boltTime.stop();
			bolting = false;
			boltTime.reset();
			stage.removeChild(boltAttack);
			boltAttack = null;
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