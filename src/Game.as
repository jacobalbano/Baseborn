package
{
	import com.jacobalbano.Animation;
	import com.jacobalbano.Input;
	
	import com.thaumaturgistgames.flakit.Engine;
	import com.thaumaturgistgames.flakit.Library;
	
	import ifrit.*;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Timer;
	
	[SWF(width = "1000", height = "400", backgroundColor = "0xFFFFFF")]
	public class Game extends Engine 
	{		
		public const MAX_X:uint = stage.stageWidth;
		public const MIN_X:uint = 0;
		public const MAX_Y:uint = stage.stageHeight;
		public const MIN_Y:uint = 0;
		
		public static var stage:Stage;
		public static var man:Player;
		public static var Projectiles:Vector.<Projectile>;
		public static var Mobs:Vector.<Mob>;
		public static var Platforms:Vector.<Platform>;
		
		public var exit:Bitmap;
		public var decal:Sprite;
		
		/**
		 * Lightning bolt
		 */
		private var lightningAttack:LightningBolt;
		private var bolting:Boolean; // Lightning bolt animation is playing
		public var boltTime:Timer = new Timer(30, 0);
		
		/**
		 * Frost bolt
		 */
		private var frostAttack:FrostBolt;
		
		
		public function Game()	{}
		
		override public function init():void 
		{
			super.init();
			
			Game.stage = this.stage;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			Input.init(stage);
			
			stage.scaleMode = "noScale";
			
			Platforms = new Vector.<Platform>;
			Projectiles = new Vector.<Projectile>;
			Mobs = new Vector.<Mob>;
			
			stage.addChild(Library.IMG("castle.bg.png"));
			
			addDecal(Library.IMG("castle.decals.stainedGlass.png"), 315.5, 18);
			
			addDecal(Library.IMG("castle.decals.shield.png"), 145, 69);
			addDecal(Library.IMG("castle.decals.shield.png"), 265, 69);
			addDecal(Library.IMG("castle.decals.torch.png"), 200, 60, [0, 1, 2, 3, 4, 5], 40, 40);
			
			addDecal(Library.IMG("castle.decals.shield.png"), 630, 69);
			addDecal(Library.IMG("castle.decals.shield.png"), 750  , 69);
			addDecal(Library.IMG("castle.decals.torch.png"), 685, 60, [0, 1, 2, 3, 4, 5], 40, 40);
			
			addDecal(Library.IMG("castle.decals.door.png"), 8, 326);
			addDecal(exit = Library.IMG("castle.decals.door.png"), 818, 326);
			
			this.makeBounds();
			
			Mobs.push(stage.addChild(man = new Player(50, 375)) as Mob);
			
			addEnemy(724, 75);
			addEnemy(924, 75);
			
			addWall( -25, 75, false);
			addWall(150, 250, true);
			addWall(255, 186, false);
			addWall(495, 229, false);
			addWall(495, 144, false);
			addWall(700, 110, false);
			addWall(913, 110, false);
			addWall(772, 414, true);
			addWall(600, 346, false);
			addWall(397, 371, false);
			addWall(829, 315, false);
			addWall(700, 272, false);
			addWall(227, 109, false);
			addWall(745, 187, false);
			addWall(1024, 315, false);
			
			lightningAttack = null;
			bolting = false;
		}
		
		private function enterFrame(e:Event):void
		{		
			var enemiesKilled:int = 0;
			
			for (var w:int = 0; w < Mobs.length; w++)
			{
				if (Mobs[w].hitpoints <= 0)
				{
					enemiesKilled++;
				}
			}
			
			if (man.collisionHull.hitTestObject(exit))
			{
				addDecal(Library.IMG("victory.png"), Game.stage.stageWidth / 2 - 64, Game.stage.stageHeight / 2 - 19);
			}
			
			if (enemiesKilled == Mobs.length)
			{
				Platforms[Platforms.length - 1].x++;
			}
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
			
			if (Input.isKeyDown(Input.A) )
			{
				man.graphic.play("attack");
				man.shoot();
			}
			
			if (Input.isKeyDown(Input.D))
			{
				if ( !(Input.isKeyDown(Input.LEFT) || Input.isKeyDown(Input.RIGHT) ) )
				{
					stopFrost();
					man.graphic.play("attack");
					stage.addChild(frostAttack = new FrostBolt(man.rotationY == 180, man.x, man.y)); 
				}
			}
			
			/**
			 * Lightning attack
			 */
			if (Input.isKeyDown(Input.S))
			{
				if ( !(Input.isKeyDown(Input.LEFT) || Input.isKeyDown(Input.RIGHT) ) )
				{
					man.graphic.play("attack"); //TODO: Stop animation on last frame
					if (!lightningAttack)
					{
						if (man.rotationY == 0)
						{
							lightningAttack = new LightningBolt(true, man.x, man.y);
							stage.addChild(lightningAttack);
						}
						else if (man.rotationY == 180)
						{
							lightningAttack = new LightningBolt(false, man.x, man.y);
							stage.addChild(lightningAttack);
						}
					}
				}
			}
			else
			{
				if (lightningAttack)
				{
					boltTime.start();
					lightningAttack.sendBolt();
				}
			}
			
			if (boltTime.currentCount >= 12)
			{
				stopBolt();
			}
			
			if (frostAttack && frostAttack.finished)
			{
				stopFrost();
			}
			
			if (Mobs.length > 0)
			{
				for (var l:int = Mobs.length - 1; l >= 0; l--)
				{
					for (var ll:int = Mobs.length - 1; ll >= 0; ll--)
					{
						if (Mobs[l].collideWithMob(Mobs[ll]))	{ }
					}
					var removed:Boolean = false;
					if (Projectiles.length > 0)
					{						
						for (var k:int = Projectiles.length - 1; k >= 0; k--) 
						{
							if (Projectiles[k].hitTestObject(Mobs[l].collisionHull))
							{
								if (Projectiles[k].friendly != Mobs[l].friendly)
								{
									stage.removeChild(Projectiles[k]);
									Projectiles[k].destroy();
									Projectiles.splice(k, 1);
									Mobs[l].hitpoints -= 5;
									
									removed = true;
									
									break;
								}
							}
						}
					}
					
					if (lightningAttack && boltTime.running)
					{
						bolting = true;
						
						if (boltTime.currentCount >= 4)
						{
							if (bolting && Mobs[l].collisionHull.hitTestObject(lightningAttack.bolt))
							{
								if (!Mobs[l].friendly)
								{
									if (!lightningAttack.isEnemyStruck(l))
									{
										Mobs[l].hitpoints -= 10;
										Mobs[l].graphic.play("shocked");
										lightningAttack.strikeEnemy(l);
									}
								}
							}
						}
					}
					
					if (frostAttack)
					{
						if (Mobs[l].collisionHull.hitTestObject(frostAttack))
						{
							if (Mobs[l].friendly != man.friendly)	Mobs[l].freeze();
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
								Projectiles[j].destroy();
								stage.removeChild(Projectiles[j]);
								Projectiles.splice(j, 1);
								continue;
							}
							
							if (Platforms[ii].collide(Projectiles[j] ) )
							{
								stage.removeChild( Projectiles[j] );
								Projectiles[j].destroy();
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
			if (!lightningAttack) return;
			
			boltTime.stop();
			bolting = false;
			boltTime.reset();
			stage.removeChild(lightningAttack);
			lightningAttack = null;
		}
		
		private function stopFrost():void
		{
			if (!frostAttack) return;
			stage.removeChild(frostAttack);
			frostAttack = null;
		}
		
		private function addWall(x:Number, y:Number, vertical:Boolean):void
		{
			Platforms.push(	stage.addChild(new Platform(x, y, vertical) ) );
		}
		
		private function addEnemy(x:Number, y:Number):void
		{
			Mobs.push(stage.addChild(new Enemy(x, y) ) as Mob);		
		}
		
		private function addDecal(bitmap:Bitmap, x:Number, y:Number, frames:Array = null, frameWidth:Number = 0, frameHeight:Number = 0 ):void
		{
			if (frames)
			{
				var a:Animation = new Animation(bitmap, frameWidth, frameHeight);
				a.add("loop", frames, 5, true);
				a.play("loop");
				a.x = x;
				a.y = y;
				stage.addChild(a);
			}
			else
			{
				var s:Sprite = new Sprite;
				s.addChild(bitmap);
				s.x = x;
				s.y = y;
				stage.addChild(s);
			}
		}
		
		/**
		 * Add platforms around the edges of the stage
		 */
		private function makeBounds():void
		{
			addWall(-5, 100, true);
			addWall(-5, 300, true);
			addWall( -5, 500, true);
			
			addWall(100, 405, false);
			addWall(300, 405, false);
			addWall(500, 405, false);
			addWall(700, 405, false);
			addWall(900, 405, false);
			
			addWall(1005, 100, true);
			addWall(1005, 300, true);
			addWall( 1005, 500, true);
			
			addWall(100, -5, false)
			addWall(300, -5, false)
			addWall(500, -5, false)
			addWall(700, -5, false)
			addWall(900, -5, false)
		}
		
	}

	//TODO: Create a "Class" class?
	/*
	 * Eventually we will have to be able to distinguish one class (rogue, mage, etc)
	 * from another. This is just a note for that in the future.
	 */
	
	
}