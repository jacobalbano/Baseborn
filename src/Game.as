﻿package
{
	import com.jacobalbano.Animation;
	import com.jacobalbano.Input;
	import flash.geom.Point;
	
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
		public static const dimensions:Point = new Point(1000, 400);
		
		public static var stage:Stage;
		public static var man:Player;
		
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
			
			World.Platforms = new Vector.<Platform>;
			World.Projectiles = new Vector.<Projectile>;
			World.Mobs = new Vector.<Mob>;
			
			World.loadCastle_01();
		}
		
		private function enterFrame(e:Event):void
		{		
			var enemiesKilled:int = 0;
			
			for (var w:int = 0; w < World.Mobs.length; w++)
			{
				if (World.Mobs[w].hitpoints <= 0)
				{
					enemiesKilled++;
				}
			}
			
			if (man.collisionHull.hitTestObject(World.exit))
			{
				World.addDecal(Library.IMG("victory.png"), Game.dimensions.x / 2 - 64, Game.dimensions.y / 2 - 19);
				World.next();
			}
			
			if (enemiesKilled == World.Mobs.length && World.Platforms.length > 0)
			{
				World.Platforms[World.Platforms.length - 1].x++;
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
			
			if (World.Mobs.length > 0)
			{
				for (var l:int = World.Mobs.length - 1; l >= 0; l--)
				{
					for (var ll:int = World.Mobs.length - 1; ll >= 0; ll--)
					{
						if (World.Mobs[l].collideWithMob(World.Mobs[ll]))	{ }
					}
					var removed:Boolean = false;
					if (World.Projectiles.length > 0)
					{						
						for (var k:int = World.Projectiles.length - 1; k >= 0; k--) 
						{
							if (World.Projectiles[k].hitTestObject(World.Mobs[l].collisionHull))
							{
								if (World.Projectiles[k].friendly != World.Mobs[l].friendly)
								{
									if (!World.Projectiles[k].friendly)	{	HUD.damagePlayer(15, true);   }
									
									stage.removeChild(World.Projectiles[k]);
									World.Projectiles[k].destroy();
									World.Projectiles.splice(k, 1);
									World.Mobs[l].hitpoints -= 5;
									
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
							if (bolting && World.Mobs[l].collisionHull.hitTestObject(lightningAttack.bolt))
							{
								if (!World.Mobs[l].friendly)
								{
									if (!lightningAttack.isEnemyStruck(l))
									{
										World.Mobs[l].hitpoints -= 10;
										World.Mobs[l].graphic.play("shocked");
										lightningAttack.strikeEnemy(l);
									}
								}
							}
						}
					}
					
					//TODO: Make frost attack do damage (maybe 2.5?)
					if (frostAttack)
					{
						if (World.Mobs[l].collisionHull.hitTestObject(frostAttack))
						{
							if (World.Mobs[l].friendly != man.friendly)	World.Mobs[l].freeze();
						}
					}
					
					if (removed) break;
				}	
			}
			
			if (World.Platforms.length > 0)
			{
				for (var ii:int = World.Platforms.length - 1; ii >= 0; ii--)
				{
					if (World.Projectiles.length > 0)
					{						
						for (var j:int = World.Projectiles.length - 1; j >= 0; j--) 
						{
							if (World.Projectiles[j].x > Game.dimensions.x + 20 || World.Projectiles[j].x < -20)
							{
								World.Projectiles[j].destroy();
								stage.removeChild(World.Projectiles[j]);
								World.Projectiles.splice(j, 1);
								continue;
							}
							
							if (World.Platforms[ii].collide(World.Projectiles[j] ) )
							{
								stage.removeChild( World.Projectiles[j] );
								World.Projectiles[j].destroy();
								World.Projectiles.splice(j, 1);
								continue;
							}
						}
					}
					
					if (World.Mobs.length > 0)
					{
						for (var jj:int = World.Mobs.length - 1; jj >= 0; jj--) 
						{
							World.Platforms[ii].collide(World.Mobs[jj] );
						}
					}
				}
			}
		}
		
		private function doRangedAttack():void 
		{
			man.graphic.play("attack");
			if (man.type == Player.MAGE && man.friendly)
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