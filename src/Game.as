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
	
	[SWF(width = "1000", height = "500", backgroundColor = "0xFFFFFF")]
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
		
		public var decal:Sprite;
		
		/**
		 * Lightning bolt
		 */
		public static var lightningAttack:LightningBolt;
		public static var bolting:Boolean; // Lightning bolt animation is playing
		public var boltTime:Timer = new Timer(30, 0);
		
		/**
		 * Frost bolt
		 */
		private var frostAttack:FrostBolt;
		
		private var canMelee:Boolean;
		
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
			
			World.loadCastle_01();
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
			
			if (man.collisionHull.hitTestObject(World.exit))
			{
				//World.addDecal(Library.IMG("victory.png"), Game.stage.stageWidth / 2 - 64, Game.stage.stageHeight / 2 - 19);
				World.next();
			}
			
			if (enemiesKilled == Mobs.length && Platforms.length > 0)
			{
				Platforms[Platforms.length - 1].x++;
			}
			
			if (Input.isKeyDown(Input.J))
			{
				World.loadCastle_01();
			}
			
			if (Input.isKeyDown(Input.LEFT))
			{
				stopBolt();
				if (man.graphic.playing != "attack" && man.graphic.playing != "shoot") man.graphic.play("walk");
				man.x -= 7;
				man.rotationY = 180;
			}
			else if (Input.isKeyDown(Input.RIGHT))
			{
				stopBolt();
				if (man.graphic.playing != "attack" && man.graphic.playing != "shoot") man.graphic.play("walk");
				man.x += 7;
				man.rotationY = 0;
			}
			else
			{
				if (man.graphic.playing != "attack" && man.graphic.playing != "shoot") man.graphic.play("stand", true);
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
				doRangedAttack();
			}
			
			if (Input.isKeyDown(Input.D))
			{
				beginMeleeAttack();
			}
			else
			{
				finalizeMeleeAttack();
			}
			
			/**
			 * Lightning attack
			 */
			if (Input.isKeyDown(Input.S))
			{
				beginSpecialAttack();
			}
			else
			{
				finalizeSpecialAttack();
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
									if (!Projectiles[k].friendly)
									{
										if (HUD.health.width >= 20) HUD.health.width -= 20;
										if (HUD.health.width < 20) HUD.health.width -= HUD.health.width;
									}
									
									stage.removeChild(Projectiles[k]);
									//Projectiles[k].destroy();
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
								//Projectiles[j].destroy();
								stage.removeChild(Projectiles[j]);
								Projectiles.splice(j, 1);
								continue;
							}
							
							if (Platforms[ii].collide(Projectiles[j] ) )
							{
								stage.removeChild( Projectiles[j] );
								//Projectiles[j].destroy();
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
		
		private function doRangedAttack():void 
		{
			man.graphic.play("attack");
			if (man.friendly)
			{
				if (HUD.mana.width >= 15 && HUD.energy.width >= 75)   man.shoot();
			}
			else man.shoot();
		}
		
		private function beginMeleeAttack():void 
		{
			canMelee = true;
		}
		
		private function finalizeMeleeAttack():void
		{
			if (canMelee)
			{
				if (man.type == Player.MAGE)
				{
					if (!frostAttack && HUD.energy.width >= 50)
					{
						stopFrost();
						man.graphic.play("attack");
						stage.addChild(frostAttack = new FrostBolt(man.rotationY == 180, man.x, man.y)); 
					}
				}
				
				canMelee = false;
			}
		}
		
		private function beginSpecialAttack():void 
		{
			if (man.type == Player.MAGE)
			{
				if ( !(Input.isKeyDown(Input.LEFT) || Input.isKeyDown(Input.RIGHT) ) )
				{
					man.graphic.play("casting");
					
					if (HUD.mana.width >= 50 && HUD.energy.width >= 80)
					{
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
			}
		}
		
		private function finalizeSpecialAttack():void
		{
			if (man.type == Player.MAGE)
			{
				if (lightningAttack)
				{
					boltTime.start();
					lightningAttack.sendBolt();
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
		
	}

	//TODO: Create a "Class" class?
	/*
	 * Eventually we will have to be able to distinguish one class (rogue, mage, etc)
	 * from another. This is just a note for that in the future.
	 */
	
	
}