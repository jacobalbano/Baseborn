package
{
	import com.jacobalbano.Animation;
	import com.jacobalbano.Input;
	import com.thaumaturgistgames.flakit.Engine;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import ifrit.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.geom.Point;
	//import flash.display.StageScaleMode;
	
	
	
	[SWF(width = "1000", height = "400", backgroundColor = "0xFFFFFF")]
	public class Game extends Engine 
	{
		public static var text:TextField = new TextField();
		
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
		
		//////////////////////
		private var boltAttack:LightningBolt;
		private var bolting:Boolean; // Lightning bolt animation is playing
		public var boltTime:Timer = new Timer(30, 0);
		
		//////////////////////
		
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
			
			addDecal(Library.IMG("castle.decals.shield.png"), 145, 69);
			addDecal(Library.IMG("castle.decals.shield.png"), 265, 69);
			addDecal(Library.IMG("castle.decals.torch.png"), 200, 60, [0, 1, 2, 3, 4, 5], 40, 40);
			
			addDecal(Library.IMG("castle.decals.shield.png"), 630, 69);
			addDecal(Library.IMG("castle.decals.shield.png"), 750  , 69);
			addDecal(Library.IMG("castle.decals.torch.png"), 685, 60, [0, 1, 2, 3, 4, 5], 40, 40);
			
			addDecal(Library.IMG("castle.decals.door.png"), 8, 326);
			addDecal(Library.IMG("castle.decals.door.png"), 818, 326);
			
			//this.decal = new Sprite;
			//this.decal.addChild(Library.IMG("castle.decals.door.png"));
			//stage.addChild(this.decal);
			
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
			addWall(1024, 315, false);
			
			boltAttack = null;
			bolting = false;
			
			//addChild(text);
		}
		
		private function enterFrame(e:Event):void
		{
			if (Input.isMouseDown)
			{				
				trace(mouseX, mouseY);
				
				//decal.x = mouseX;
				//decal.y = mouseY;
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
			
			//TODO: Create close-range/melee attacks with 'D' button
			/*
			 * "iceBlast.png" will be the Mage's close-range attack
			 */
			
			//////////////////Magic Targeting System///////////////////
			
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
					for (var ll:int = Mobs.length - 1; ll >= 0; ll--)
					{
						if (Mobs[l].collideWithMob(Mobs[ll]))
						{
						}
					}
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
									Projectiles[k].destroy();
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
			if (!boltAttack) return;
			
			boltTime.stop();
			bolting = false;
			boltTime.reset();
			stage.removeChild(boltAttack);
			boltAttack = null;
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