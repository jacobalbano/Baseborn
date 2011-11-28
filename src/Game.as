package
{
	import com.jacobalbano.Animation;
	import com.jacobalbano.Input;
	import com.thaumaturgistgames.flakit.Engine;
	import flash.net.SharedObject;
	import com.thaumaturgistgames.flakit.Library;
	import ifrit.IfritObject;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import ifrit.*;
	
	
	[SWF(width = "1000", height = "500", backgroundColor = "0x000000", frameRate = "30")]
	public class Game extends Engine 
	{
		public static const dimensions:Point = new Point(1000, 400);
		
		public static var stage:Stage;
		public static var man:Player;
		public static var playerClass:uint = Player.FIGHTER;
		
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
		
		/**
		 * Shield
		 */
		private var shielding:Boolean;
		
		/**
		 * Blink
		 */
		private var blinkTimer:Timer = new Timer(0, 7);
		private var blinkTo:Point;
		private var endBlink:Boolean;
		private var canBlink:Boolean;
		 
		private var canMelee:Boolean;
		private var canShoot:Boolean;
		
		public function Game()	{}
		
		override public function init():void 
		{
			super.init();
			
			Game.stage = this.stage;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			Input.init(stage);
			
			stage.scaleMode = "noScale";
			
			World.init();
			
			Game.playerClass = SaveState.playerClass;
			
			World.loadLevel( SaveState.level || "mainMenu");
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
			
			if (man)
			{
				if (enemiesKilled == World.Mobs.length && World.Platforms.length > 0)
				{
					World.Platforms[World.Platforms.length - 1].x++;
				}
				
				if (checkLadder())
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
					
					if (Input.isKeyDown(Input.UP))
					{
						man.y -= 5;
					}
					else if (Input.isKeyDown(Input.DOWN))
					{
						man.y += 5;
					}
					else
					{
						if (man.isIdle) 	man.graphic.play("stand", true);
					}
				}
				else
				{
					if (Input.isKeyDown(Input.LEFT))
					{
						stopBolt();
						
						if (man.graphic.playing != "attack" && man.graphic.playing != "shoot" && !shielding)
							man.graphic.play("walk");
							
						if (shielding)	man.x -= 2;
						else 			man.x -= 7;
						
						man.rotationY = 180;
						
						if (man.type == Player.ROGUE)
						{
							blinkTimer.start();
							if (canBlink)
							{
								blinkTo = new Point(man.x, man.y);
								while (Point.distance(new Point(man.x, man.y), blinkTo) <= 75 && !endBlink)
								{
									blinkTo.x -=  5;
									for (var a:int = World.Platforms.length - 1; a >= 0; a--)
									{
										if (World.Platforms[a].vertical)
										{
											if (World.Platforms[a].hitTestPoint(blinkTo.x, blinkTo.y))
											{
												endBlink = true;
												break;
											}
											else  endBlink = false;
										}
									 }
								}
								
								//TODO: See smokeFunc function definition below
								World.addDecal(Library.IMG("smoke.png"), man.x, man.y, removeSmoke, [0, 1, 2, 3, 4, 5], 40, 40, 10, false);
								man.x = blinkTo.x;
								canBlink = false;
								HUD.buyAction(200, HUD.SPECIAL);
							}
						}
						

					}
					else if (Input.isKeyDown(Input.RIGHT))
					{
						stopBolt();
						
						if (man.graphic.playing != "attack" &&	man.graphic.playing != "shoot" 	&& !shielding)
								man.graphic.play("walk");
							
						if (shielding)	man.x += 2;
						else			man.x += 7;
						
						man.rotationY = 0;
						
						if (man.type == Player.ROGUE)
						{
							blinkTimer.start();
							if (canBlink)
							{
								blinkTo = new Point(man.x, man.y);
								while (Point.distance(new Point(man.x, man.y), blinkTo) <= 75 && !endBlink)
								{
									blinkTo.x +=  5;
									for (var b:int = World.Platforms.length - 1; b >= 0; b--)
									{
										if (World.Platforms[b].vertical)
										{
											if (World.Platforms[b].hitTestPoint(blinkTo.x, blinkTo.y, true))
											{
												endBlink = true;
												break;
											}
											else  endBlink = false;
										}
									 }
								}
								
								World.addDecal(Library.IMG("smoke.png"), man.x, man.y, removeSmoke, [0, 1, 2, 3, 4, 5], 40, 40, 20, false);
								man.x = blinkTo.x;
								canBlink = false;
								HUD.buyAction(200, HUD.SPECIAL);
							}
						}
					}
					else
					{
						if (man.isIdle) 	man.graphic.play("stand", true);
						
						if (blinkTimer.running && HUD.testCost(0, 0, 0, 200))	canBlink = true;
						else canBlink = false;
						
						if (blinkTimer.currentCount == blinkTimer.repeatCount)
							if (!blinkTimer.running)	blinkTimer.reset();
					}
				}
				if (blinkTimer.currentCount == blinkTimer.repeatCount)	blinkTimer.stop();
				
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
					beginRangedAttack();
				}
				else
				{
					if (canShoot)
						finalizeRangedAttack();
				}
				
				if (Input.isKeyDown(Input.D))
				{
					if (man.type != Player.MAGE)	man.graphic.play("attack");
					beginMeleeAttack();
				}
				else
				{
					if (canMelee)
						finalizeMeleeAttack();
				}
				
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
			}
			
			if (World.Projectiles.length > 0)
			{
				for (var t:int = World.Projectiles.length; t --> 0; )
				{
					if (World.Projectiles[t].isDestroyed)
					{
						Game.stage.removeChild(World.Projectiles[t]);
						World.Projectiles.splice(t, 1);
					}
				}
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
								if (World.Projectiles[k].static || !World.Projectiles[k].stopped)
								{
									if (World.Projectiles[k].friendly != World.Mobs[l].friendly)
									{
										if (!World.Projectiles[k].friendly)
										{
											if (shielding && (World.Projectiles[k].rotationY != World.Mobs[l].rotationY)) HUD.damagePlayer(0);
											else	HUD.damagePlayer(15, true);
										}
										
										World.Mobs[l].hitpoints -= World.Projectiles[k].damage;
										stage.removeChild(World.Projectiles[k]);
										World.Projectiles[k].destroy();
										World.Projectiles.splice(k, 1);
										
										removed = true;
										
										break;
									}
								}
								else
								{
									if (World.Projectiles[k].friendly == World.Mobs[l].friendly && !World.Projectiles[k].static)
									{
										HUD.restoreAmmo(1);
										stage.removeChild(World.Projectiles[k]);
										World.Projectiles[k].destroy();
										World.Projectiles.splice(k, 1);
										
										break;
									}
								}
							}
						}
					}
					
					if (lightningAttack && boltTime.running)
					{
						bolting = true;
						
						if (boltTime.currentCount >= 4)
						{
							if (bolting && !World.Mobs[l].isDestroyed && World.Mobs[l].collisionHull.hitTestObject(lightningAttack.bolt))
							{
								if (!World.Mobs[l].friendly)
								{
									if (!lightningAttack.isEnemyStruck(l))
									{
										World.Mobs[l].hitpoints -= 12;
										World.Mobs[l].graphic.play("shocked");
										lightningAttack.strikeEnemy(l);
									}
								}
							}
						}
					}
					
					if (frostAttack)
					{
						if (World.Mobs[l].collisionHull.hitTestObject(frostAttack))
						{
							if (World.Mobs[l].friendly != man.friendly)
							{
								World.Mobs[l].freeze();
								if (!World.Mobs[l].struck)
								{
									World.Mobs[l].hitpoints -= 3;
									World.Mobs[l].struck = true;
								}
							}
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
								if (World.Projectiles[j].hasPhysics)
								{
									World.Projectiles[j].stop();
								}
								else
								{
									stage.removeChild( World.Projectiles[j] );
									World.Projectiles[j].destroy();
									World.Projectiles.splice(j, 1);
									continue;
								}
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
		
		private function removeSmoke(d:Decal):void 
		{
			if (d.animation.playing != "animation")	Game.stage.removeChild(d);
		}
		
		
		private function beginRangedAttack():void 
		{			
			if (man.type == Player.MAGE)
			{
				if (HUD.testCost(75, 15))
				{
					man.graphic.play("attack");
					man.shoot();
				}
			}
			else if (man.type == Player.FIGHTER)
			{
				if (HUD.testCost(0, 0, 10))
				{
					man.graphic.play("pull");
					canShoot = true;
				}
			}
			else if (man.type == Player.ROGUE)
			{
				man.graphic.play("throw");
				if (HUD.testCost(0, 0, 20))   man.shoot();
			}
		}
		
		private function finalizeRangedAttack():void 
		{
			if (man.type == Player.FIGHTER)
			{
				if (man.friendly)
				{
					man.graphic.play("release90");
					man.shoot();
				}
			}
			canShoot = false;
		}
		
		private function beginMeleeAttack():void 
		{
			canMelee = true;
			
			if (man.type != Player.MAGE)
			{
				man.stab();
				man.graphic.play("attack");
			}
		}
		
		private function finalizeMeleeAttack():void
		{
			if (man.type == Player.MAGE)
			{
				if (!frostAttack && HUD.testCost(50))
				{
					stopFrost();
					man.graphic.play("attack");
					stage.addChild(frostAttack = new FrostBolt(man.rotationY == 180, man.x, man.y));
				}
			}
			canMelee = false;
		}
		
		private function beginSpecialAttack():void 
		{
			if (man.type == Player.MAGE)
			{
				if ( !(Input.isKeyDown(Input.LEFT) || Input.isKeyDown(Input.RIGHT) ) )
				{					
					if (HUD.testCost(95, 25))
					{
						man.graphic.play("casting");
						
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
			
			if (man.type == Player.FIGHTER)
			{
				if (!shielding && HUD.testCost(0, 0, 0, 200))
				{
					HUD.buyAction(200, HUD.SPECIAL);
					shielding = true;
					man.graphic.play("shield");
				}
			}
			
			if (man.type == Player.ROGUE)
			{
				if (hasCaltrop)
				{
					hasCaltrop = false;
					man.shoot(Caltrop);
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
			
			if (man.type == Player.FIGHTER)
			{
				if (shielding)
				{
					man.graphic.play("stand");
					shielding = false;
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
		
		private function checkLadder():Ladder
		{
			var oneLadder:Boolean = false;
			var l:int;
			
			if (World.Ladders.length > 0)
			{
				for (l = World.Ladders.length; l --> 0; )
				{
					if (Point.distance(new Point(man.x, man.y), new Point(World.Ladders[l].x, man.y)) < 14 &&
						man.y > World.Ladders[l].getRect(Game.stage).top - man.height / 2					&&
						man.y < World.Ladders[l].getRect(Game.stage).bottom)
					{
						man.gravUp = false;
						oneLadder = true;
						if (!Input.isKeyDown(Input.LEFT) && !Input.isKeyDown(Input.RIGHT))
						{
							man.x = World.Ladders[l].x;
						}
						break;
					}
				}
				
				if (!oneLadder)	man.gravUp = true;
			}
			
			return oneLadder ? World.Ladders[l] : null;
		}
		
	}

}