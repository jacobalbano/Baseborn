package
{
	import com.jacobalbano.Input;
	import com.thaumaturgistgames.flakit.Engine;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import ifrit.*;
	
	[SWF(width = "1000", height = "500", backgroundColor = "0x000000", frameRate = "30")]
	public class Game extends Engine 
	{
		public static const dimensions:Point = new Point(1000, 400);
		
		public static var stage:Stage;
		public static var man:Player;
		public static var boss:Boss;
		public static var playerClass:uint;
		
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
			
			WorldUtils.loadLevel( SaveState.level );
		}
		
		private function enterFrame(e:Event):void
		{
			/**
			* Debugging shortcuts
			*/
			
			///*
			// Next level
			if (Input.isKeyDown(Input.DIGIT_1))
				WorldUtils.next();
				
			// Change class to FIGHTER on next scene
			if (Input.isKeyDown(Input.DIGIT_2) && man.type != Player.FIGHTER)
				Game.playerClass = Player.FIGHTER
				
			// Change class to ROGUE on next scene
			if (Input.isKeyDown(Input.DIGIT_3) && man.type != Player.ROGUE)
				Game.playerClass = Player.ROGUE	
					
			// Change class to MAGE on next scene
			if (Input.isKeyDown(Input.DIGIT_4) && man.type != Player.MAGE)
				Game.playerClass = Player.MAGE
				
			// Force learn A skill
			if (Input.isKeyDown(Input.DIGIT_5))
				Game.man.knowsA = !Game.man.knowsA;	
					
			// Force learn S skill
			if (Input.isKeyDown(Input.DIGIT_6))
				Game.man.knowsS = !Game.man.knowsS;	
					
			// Force learn D skill
			if (Input.isKeyDown(Input.DIGIT_7))
				Game.man.knowsD = !Game.man.knowsD;
			
			//*/ 
			/**
			 * End debugging shortcuts
			 */
			if (Input.isKeyDown(Input.ENTER) || Input.isKeyDown(Input.NUMPAD_ENTER))
			{
				if (World.currentLevel != "title")	WorldUtils.loadLevel( World.currentLevel);
			}
			 
			if (Input.isKeyDown(Input.M))
			{
				if (!Audio.isMuted)	World.audio.mute();
				else				World.audio.unmute();
			}
			
			if (man && !man.isDestroyed)
			{	
				if (checkLadder())
				{
					if (Input.isKeyDown(Input.LEFT) )
					{
						man.x -= 7;
						
						man.rotationY = 180;
					}
					
					if (Input.isKeyDown(Input.RIGHT) )
					{
						man.x += 7;
						
						man.rotationY = 0;
					}
					
					if (Input.isKeyDown(Input.UP) && !man.isFrozen)
					{
						man.y -= 5;
						man.graphic.play("climbUp");
					}
					else if (Input.isKeyDown(Input.DOWN) && !man.isFrozen)
					{
						man.y += 5;
						man.graphic.play("climbDown");
					}
					else
					{
						if (man.isIdle) 	man.graphic.play("climbIdle", true);
					}
				}
				else
				{
					if (Input.isKeyDown(Input.LEFT) && !man.isFrozen)
					{
						stopBolt();
						
						for (var d:int = World.Mobs.length; d --> 0; )
						{
							if (World.Mobs[d] is Doppleganger && !World.Mobs[d].isDestroyed)
							{
								World.Mobs[d].x += 7;
								World.Mobs[d].rotationY = 0;
								World.Mobs[dd].graphic.play("walk");
							}
						}
						
						if (man.graphic.playing != "attack" && !man.shielding && !Input.isKeyDown(Input.A))
							man.graphic.play("walk");
							
						if (man.shielding)	man.x -= 2;
						else 				man.x -= 7;
						
						man.rotationY = 180;
					}
					else if (Input.isKeyDown(Input.RIGHT) && !man.isFrozen)
					{
						stopBolt();
						
						for (var dd:int = World.Mobs.length; dd --> 0; )
						{
							if (World.Mobs[dd] is Doppleganger && !World.Mobs[dd].isDestroyed)
							{
								World.Mobs[dd].x -= 7;
								World.Mobs[dd].rotationY = 180;
								World.Mobs[dd].graphic.play("walk");
							}
						}
						
						if (man.graphic.playing != "attack"	&& !man.shielding && !Input.isKeyDown(Input.A))
								man.graphic.play("walk");
							
						if (man.shielding)	man.x += 2;
						else			man.x += 7;
						
						man.rotationY = 0;
					}
					else
					{
						
						if (man.isIdle)
						{
							for (var dddd:int = World.Mobs.length; dddd --> 0; )
							{
								if (World.Mobs[dddd] is Doppleganger && !World.Mobs[dddd].isDestroyed)
								{
									World.Mobs[dddd].graphic.play("stand");
								}
							}
							
							man.graphic.play("stand", true);
						}
					}
				}
				
				if (man.canJump && !man.isFrozen)
				{
					if (Input.isKeyDown(Input.SPACE))
					{
						for (var p:int = World.Mobs.length; p --> 0; )
						{
							if (World.Mobs[p] is Doppleganger && !World.Mobs[p].isDestroyed) World.Mobs[p].jumping = true;
						}
						
						man.jumping = true;
						man.canJump = false;
					}
				}
				else
				{
						man.jumping = false;
						for (var f:int = World.Mobs.length; f --> 0; )
						{
							if (World.Mobs[f] is Doppleganger)	World.Mobs[f].jumping = false;
						}
				}

				
				if (Input.isKeyDown(Input.A) && Game.man.knowsA)
				{
					if (!Input.isKeyDown(Input.S) && !Input.isKeyDown(Input.D))
						beginRangedAttack();
				}
				else
				{
					if (man.canShoot)
						finalizeRangedAttack();
				}
				
				if (Input.isKeyDown(Input.D) && Game.man.knowsD)
				{
					if (!Input.isKeyDown(Input.S) 	&&	!Input.isKeyDown(Input.A) &&
						!Input.isKeyDown(Input.UP)	&&	!Input.isKeyDown(Input.DOWN))
					{
						if (man.type != Player.NONE)
						{
							if (man.type != Player.MAGE)	man.graphic.play("attack");
								beginMeleeAttack();
						}
					}
				}
				else
				{
					if (man.canMelee)
						finalizeMeleeAttack();
				}
				
				if (Input.isKeyDown(Input.S) && Game.man.knowsS)
				{
					if (!Input.isKeyDown(Input.A) && !Input.isKeyDown(Input.D))
						beginSpecialAttack();
				}
				else
				{
					finalizeSpecialAttack();
				}
				
				if (man.boltTime.currentCount >= 12)
				{
					stopBolt();
				}
				
				if (man.frostAttack && man.frostAttack.finished)
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
						World.Projectiles[t].sound.stopSFX("fly");
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
								if (World.Projectiles[k].isStatic || !World.Projectiles[k].stopped)
								{
									if (World.Projectiles[k].friendly != World.Mobs[l].friendly && !World.Mobs[l].isDestroyed)
									{
										if (!World.Projectiles[k].friendly)
										{
											if (man.shielding && (World.Projectiles[k].rotationY != World.Mobs[l].rotationY)) HUD.damagePlayer(0);
											else	HUD.damagePlayer(World.Projectiles[k].damage, true);
											
											if (World.Projectiles[k] is Web && World.Mobs[l].friendly && !World.Mobs[l].isFrozen)
											{
												if (playerClass == Player.FIGHTER)
													WorldUtils.addDecal(Library.IMG("webTrapFighter.png"), man.x, man.y, man.webbed);
												else
													WorldUtils.addDecal(Library.IMG("webTrap.png"), man.x, man.y, man.webbed);
													
												World.Mobs[l].freeze();
											}
										}
										
										World.Mobs[l].hitpoints -= World.Projectiles[k].damage;
										if (!World.Projectiles[k].isStatic)
										{
											stage.removeChild(World.Projectiles[k]);
											World.Projectiles[k].destroy();
											World.Projectiles.splice(k, 1);
											
											removed = true;
											
											break;
										}
									}
								}
								else
								{
									if (World.Mobs[l].friendly && !World.Projectiles[k].isStatic)
									{
										
										if (World.Projectiles[k] is World.Mobs[l].rangedType)	HUD.restoreAmmo(1);
										
										stage.removeChild(World.Projectiles[k]);
										World.Projectiles[k].destroy();
										World.Projectiles.splice(k, 1);
										
										break;
									}
								}
							}
						}
					}
					
					if (man.lightningAttack && man.boltTime.running)
					{
						man.boltPlaying = true;
						
						if (man.boltTime.currentCount >= 4)
						{
							if (man.boltPlaying && !World.Mobs[l].isDestroyed && World.Mobs[l].collisionHull.hitTestObject(man.lightningAttack.bolt))
							{
								if (!World.Mobs[l].friendly)
								{
									if (!man.lightningAttack.isEnemyStruck(l))
									{
										World.Mobs[l].hitpoints -= 12;
										World.Mobs[l].graphic.play("shocked");
										man.lightningAttack.strikeEnemy(l);
									}
								}
							}
						}
					}
					
					if (man.frostAttack)
					{
						if (World.Mobs[l].collisionHull.hitTestObject(man.frostAttack))
						{
							if (World.Mobs[l].friendly != man.friendly)
							{
								World.Mobs[l].freeze();
								if (!World.Mobs[l].struck)
								{
									World.Mobs[l].hitpoints -= 5;
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
							
							/**
							 * Platform debugging information
							 */
							//if (World.Mobs[jj].friendly)
							//{
								//if (World.Platforms[ii].collide(World.Mobs[jj] ))
								//{
									//trace(ii);
								//}
							//}
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
				if (HUD.testCost(Fireball.energyCost, Fireball.manaCost))
				{
					man.graphic.play("attack");
					man.shoot();
				}
			}
			else if (man.type == Player.FIGHTER)
			{
				if (HUD.testCost(0, 0, 10))
				{
					if (!man.attackTimer.running)	man.graphic.play("pull");
					
					man.canShoot = true;
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
					if (!man.attackTimer.running)	man.graphic.play("release");
					
					man.shoot();
				}
			}
			man.canShoot = false;
		}
		
		private function beginMeleeAttack():void 
		{
			man.canMelee = true;
			
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
				if (!man.frostAttack && HUD.testCost(FrostBolt.energyCost))
				{
					stopFrost();
					man.graphic.play("attack");
					stage.addChild(man.frostAttack = new FrostBolt(man.rotationY == 180, man.x, man.y));
				}
			}
			man.canMelee = false;
		}
		
		private function beginSpecialAttack():void 
		{
			if (man.type == Player.MAGE)
			{
				if ( !(Input.isKeyDown(Input.LEFT) || Input.isKeyDown(Input.RIGHT) ) )
				{					
					if (HUD.testCost(LightningBolt.energyCost, LightningBolt.manaCost))
					{
						man.graphic.play("casting");
						
						if (!man.lightningAttack)
						{
							if (man.rotationY == 0)
							{
								man.lightningAttack = new LightningBolt(true, man.x, man.y);
								stage.addChild(man.lightningAttack);
							}
							else if (man.rotationY == 180)
							{
								man.lightningAttack = new LightningBolt(false, man.x, man.y);
								stage.addChild(man.lightningAttack);
							}
						}
					}
				}
			}
			
			if (man.type == Player.FIGHTER)
			{
				if (!man.shielding && HUD.testCost(0, 0, 0, 200))
				{
					HUD.buyAction(200, HUD.SPECIAL);
					man.shielding = true;
					man.graphic.play("shield");
				}
			}
			
			if (man.type == Player.ROGUE)
			{
				man.canDropCaltrop = true;
			}
			
		}
		
		private function finalizeSpecialAttack():void
		{
			if (man.type == Player.MAGE)
			{
				if (man.lightningAttack)
				{
					//Library.SND("audio.sfx.bolt.mp3").play(0);
					man.boltTime.start();
					man.lightningAttack.sendBolt();
				}
			}
			
			if (man.type == Player.FIGHTER)
			{
				if (man.shielding)
				{
					man.graphic.play("stand");
					man.shielding = false;
				}
			}
			
			//BUG: Pressing 'S' quickly and repeatedly makes the game think the caltrop is out when it is not
			if (man.type == Player.ROGUE)
			{
				if (man.canDropCaltrop)
				{
					if (man.hasCaltrop)
					{
						man.hasCaltrop = false;
						man.activeCaltrop =	(man.shoot(Caltrop) as Caltrop);
					}
					else
					{
						if (man.activeCaltrop)
						{
							if (man.collisionHull.hitTestObject(man.activeCaltrop))
							{
								man.hasCaltrop = true;
								Game.stage.removeChild(man.activeCaltrop);
								
								for (var p:int = World.Projectiles.length; p --> 0; )
								{
									if (World.Projectiles[p] == man.activeCaltrop)
									{
										World.Projectiles.splice(p, 1);
										break;
									}
								}
							}
						}
					}
					man.canDropCaltrop = false;
				}
			}
			
		}
		
		private function stopBolt():void
		{
			if (!man.lightningAttack) return;
			
			man.boltTime.stop();
			man.boltPlaying = false;
			man.boltTime.reset();
			stage.removeChild(man.lightningAttack);
			man.lightningAttack = null;
		}
		
		private function stopFrost():void
		{
			if (!man.frostAttack) return;
			stage.removeChild(man.frostAttack);
			man.frostAttack = null;
		}
		
		/**
		 * Checks to see if the player is colliding with a ladder and centers him on it if he isn't moving
		 * @return	The ladder the player is colliding with, if any; otherwise null
		 */
		private function checkLadder():Ladder
		{			
			if (World.Ladders.length > 0)
			{
				for (var l:uint = World.Ladders.length; l --> 0; )
				{
					if (Point.distance(new Point(man.x, man.y), new Point(World.Ladders[l].x, man.y)) < 14 	&&
						man.y > World.Ladders[l].getRect(Game.stage).top - man.height / 2					&&
						man.y < World.Ladders[l].getRect(Game.stage).bottom)
					{
						man.gravUp = false;
						if (!Input.isKeyDown(Input.LEFT) && !Input.isKeyDown(Input.RIGHT))
						{
							man.x = World.Ladders[l].x;
						}
						return World.Ladders[l]
					}
				}
			}
			
			man.gravUp = true;
			return null;
		}
		
	}

}