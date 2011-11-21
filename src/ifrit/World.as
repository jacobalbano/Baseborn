package ifrit 
{
	
	import com.jacobalbano.Animation;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import ifrit.*;
	
	
	
	/**
	 * @author Jake Albano
	 */
	public class World
	{
		
		public static var Projectiles:Vector.<Projectile>;
		public static var Mobs:Vector.<Mob>;
		public static var Platforms:Vector.<Platform>;
		
		public static var exit:Bitmap;
		
		private static var nextLevel:Function;
		
		public function World() { }
		public static function next():void
		{
			nextLevel();
		}
		
		public static function mainMenu():void
		{
			unloadLevel();
			
			addButton(600, 200, Library.IMG("menu.rogue_button.png"), function ():void { Game.playerClass = Player.ROGUE; next();} );
			addButton(600, 250, Library.IMG("menu.fighter_button.png"), function ():void { Game.playerClass = Player.FIGHTER; next();} );
			addButton(600, 300, Library.IMG("menu.mage_button.png"), function ():void { Game.playerClass = Player.MAGE; next(); } );
			
			nextLevel = loadCastle_01;
		}
		
		public static function loadCastle_01():void 
		{
			unloadLevel();
			
			makeBounds();
			
			Game.stage.addChild(Library.IMG("castle.bg2.png"));
			
			addDecal(Library.IMG("castle.decals.stainedGlass.png"), 315.5, 18);
			
			addDecal(Library.IMG("castle.decals.chandelier.png"), 900, 115, [0, 1, 2, 3], 46, 101);
			addDecal(Library.IMG("castle.decals.chandelier.png"), 50, 115, [0, 1, 2, 3], 46, 101);
			
			addDecal(Library.IMG("castle.decals.shield.png"), 145, 69);
			addDecal(Library.IMG("castle.decals.shield.png"), 265, 69);
			addDecal(Library.IMG("castle.decals.torch.png"), 200, 60, [0, 1, 2, 3, 4, 5], 40, 40);
			
			addDecal(Library.IMG("castle.decals.shield.png"), 630, 69);
			addDecal(Library.IMG("castle.decals.shield.png"), 750  , 69);
			addDecal(Library.IMG("castle.decals.torch.png"), 685, 60, [0, 1, 2, 3, 4, 5], 40, 40);
			
			addDecal(Library.IMG("castle.decals.door.png"), 8, 326);
			addDecal(Library.IMG("misc.ladder.png"), 800, 210);
			addDecal(exit = Library.IMG("castle.decals.door.png"), 818, 326);
			
			addEnemy(724, 75);
			addEnemy(924, 75);
			addEnemy(600, 336);
			addEnemy(495, 130);
			addEnemy(170, 180);
			
			Mobs.push(Game.stage.addChild(Game.man = new Player(50, 375, Game.playerClass)) as Mob);
			
			addWall( 0, 110, false);
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
			addWall(745, 210, false);
			addWall(1024, 315, false);
			
			Game.stage.addChild(new HUD);
			
			Game.lightningAttack = null;
			Game.bolting = false;
			
			nextLevel = mainMenu;
		}
		
		public static function loadCastle_02():void
		{
			unloadLevel();
		}
		
		
		/**
		 * Add a platform to the world
		 * @param	x			Position on x
		 * @param	y			Position on y
		 * @param	vertical	Whether the platform should be rotated vertically
		 */
		public static function addWall(x:Number, y:Number, vertical:Boolean):void
		{
			Platforms.push(Game.stage.addChild(new Platform(x, y, vertical) ) );
		}
		
		/**
		 * Add an enemy to the world
		 * @param	x			Position on x
		 * @param	y			Position on y
		 */
		public static function addEnemy(x:Number, y:Number):void
		{
			Mobs.push(Game.stage.addChild(new Enemy(x, y) ) as Mob);		
		}
		
		/**
		 * Add a decal to the world
		 * @param	bitmap		The bitmap to use as source	
		 * @param	x			Position on x
		 * @param	y			Position on y
		 * @param	frames		If the decal is animated, specify frames
		 * @param	frameWidth	Width of animation frames
		 * @param	frameHeight	Height of animation frames
		 */
		public static function addDecal(bitmap:Bitmap, x:Number, y:Number, frames:Array = null, frameWidth:Number = 0, frameHeight:Number = 0 ):void
		{
			if (frames)
			{
				var a:Animation = new Animation(bitmap, frameWidth, frameHeight);
				a.add("loop", frames, 5, true);
				a.play("loop");
				a.x = x;
				a.y = y;
				Game.stage.addChild(a);
			}
			else
			{
				var s:Sprite = new Sprite;
				s.addChild(bitmap);
				s.x = x;
				s.y = y;
				Game.stage.addChild(s);
			}
		}
		
		public static function addButton(x:Number, y:Number, image:Bitmap, callback:Function = null):void
		{
			Game.stage.addChild(new MenuButton(x, y, image, callback));
			
		}
		
		/**
		 * Add platforms around the edges of the stage
		 */
		public static function makeBounds():void
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
		
		/**
		 * Remove all objects from the world
		 */
		private static function unloadLevel():void 
		{
			for (var pr:int = World.Projectiles.length; pr --> 0; )
			{
				Game.stage.removeChild(World.Projectiles.pop());
			}
			
			for (var pl:int = World.Platforms.length; pl --> 0; )
			{
				Game.stage.removeChild(World.Platforms.pop());
			}
			
			for (var mb:int = World.Mobs.length; mb --> 0; )
			{
				Game.stage.removeChild(World.Mobs.pop());
			}
			
			while (Game.stage.numChildren > 1) Game.stage.removeChildAt(1);
			
		}
		
	}

}