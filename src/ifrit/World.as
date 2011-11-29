package ifrit 
{
	
	import com.jacobalbano.Animation;
	import com.jacobalbano.Map;
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
		public static var Ladders:Vector.<Ladder>;
		
		private static var Worlds:Map;
		private static var nextLevel:String;
		
		
		
		public function World() { }
		
		/**
		 * Initialize the world manager
		 * Register world functions here
		 */
		public static function init():void 
		{
			World.Platforms 	= new Vector.<Platform>;
			World.Projectiles 	= new Vector.<Projectile>;
			World.Mobs 			= new Vector.<Mob>;
			World.Ladders 		= new Vector.<Ladder>;
			
			//	Using my custom map class to store levels
			//	It works the same way as a C++ map, storing objects with keys
			Worlds = new Map(String, Function);
			
			Worlds.add("mainMenu", 	mainMenu);
			Worlds.add("beach_01", loadBeach_01);
			Worlds.add("forest_01", loadForest_01);
			Worlds.add("forest_02", loadForest_02);
			Worlds.add("castle_01", loadCastle_01);
			Worlds.add("castle_02", loadCastle_02);
		}
		
		//	Worlds begin
		//{
		
		private static function mainMenu():void
		{			
			addButton(600, 200, Library.IMG("menu.rogue_button.png"), 	function ():void { Game.playerClass = Player.ROGUE; 	SaveState.playerClass = Game.playerClass;	next();} );
			addButton(600, 250, Library.IMG("menu.fighter_button.png"), function ():void { Game.playerClass = Player.FIGHTER; 	SaveState.playerClass = Game.playerClass;	next();} );
			addButton(600, 300, Library.IMG("menu.mage_button.png"), 	function ():void { Game.playerClass = Player.MAGE; 		SaveState.playerClass = Game.playerClass;	next(); } );
			
			nextLevel = "beach_01";
		}
		
		private static function loadBeach_01():void
		{
			makeBounds();
			
			addDecal(Library.IMG("beach.bg.png"), 500, 250);
			
			addDecal(new Bitmap(new BitmapData(50, 50, true, 0)), 1023, 375, advance);
			
			addDecal(Library.IMG("beach.lightningBolt.png"), 100, 170, null, null, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 10, 66, 45, false);
			addDecal(Library.IMG("beach.towerLightning.png"), 835, 30, null, null, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0 , 0, 0, 0, 0, 0, 0, 0, 0 ,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 340, 72,  30, true);
			addDecal(Library.IMG("beach.shipAnimation.png"), 400, 175, null, null, [0, 1, 2, 3], 270, 193, 5);
			
			addMan(500, 490, Player.NONE);
			
			nextLevel = "forest_01";
		}
		
		private static function loadForest_01():void
		{
			makeBounds();
			
			addDecal(Library.IMG("forest.forestBG.png"), 500, 200 );
			addDecal(Library.IMG("forest.decals.stump.png"), 600, 375);
			
			addWall(158, 285, false, Library.IMG("forest.platform.png"), 125);
			addWall(409, 285, false, Library.IMG("forest.platform.png"), 125);
			
			addLadder(85, 275, 115, "misc.ropeLadder.png");
			
			addMan(50, 375, Game.playerClass);
			
			Game.stage.addChild(new RopeBridge(280, 275, 125));
			addWall(280, 285, false, Library.IMG("misc.clipPlatform.png"), 125);
			
			addDecal(new Bitmap(new BitmapData(50, 50, true, 0)), 1023, 375, advance);
			
			Game.stage.addChild(new HUD);
			
			addWall(1000, 1000, false, Library.IMG("misc.clipPlatform.png"));
			
			nextLevel = "forest_02";
		}
		
		private static function loadForest_02():void
		{
			makeBounds();
			
			//	Manipulation function to flip the backround horizontally when we load it
			addDecal(Library.IMG("forest.forestBG.png"), 500, 200, null, function (d:Decal):* {	d.rotationY = 180;	} );
			
			addMan(50, 375, Game.playerClass);
			
			addDecal(new Bitmap(new BitmapData(50, 50, true, 0)), 1023, 375, advance);
			
			Game.stage.addChild(new HUD);
		}
		
		private static function loadCastle_01():void 
		{
			makeBounds();
			
			Game.stage.addChild(Library.IMG("castle.bg.png"));
			
			addDecal(Library.IMG("castle.decals.stainedGlass.png"), 515.5, 218);
			
			addDecal(Library.IMG("castle.decals.chandelier.png"), 923, 165.5, null, null , [0, 1, 2, 3], 46, 101);
			addDecal(Library.IMG("castle.decals.chandelier.png"), 73, 165.5, null, null, [0, 1, 2, 3], 46, 101);
			
			addDecal(Library.IMG("castle.decals.shield.png"), 180, 80);
			addDecal(Library.IMG("castle.decals.shield.png"), 280, 80);
			addDecal(Library.IMG("castle.decals.torch.png"), 230, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			
			addDecal(Library.IMG("castle.decals.shield.png"), 650, 80);
			addDecal(Library.IMG("castle.decals.shield.png"), 750, 80);
			addDecal(Library.IMG("castle.decals.torch.png"), 700, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			
			addDecal(Library.IMG("castle.decals.door.png"), 55, 363.5);
			addDecal(Library.IMG("castle.decals.door.png"), 855, 363.5, advance);
			
			addLadder(112, 100, 260);
			addLadder(855, 200, 115);
			
			addEnemy(724, 75, ElfMage);
			addEnemy(924, 75, ElfMage);
			addEnemy(600, 336, ElfMage);
			addEnemy(495, 130, ElfMage);
			addEnemy(170, 180, ElfMage);
			
			addWall( 0, 110, false, Library.IMG("castle.platform.png"));
			addWall(150, 250, true, Library.IMG("castle.platform.png"));
			addWall(255, 186, false, Library.IMG("castle.platform.png"));
			addWall(495, 229, false, Library.IMG("castle.platform.png"));
			addWall(495, 144, false, Library.IMG("castle.platform.png"));
			addWall(800, 110, false, Library.IMG("castle.platform.png"), 400);
			addWall(772, 414, true, Library.IMG("castle.platform.png"));
			addWall(600, 346, false, Library.IMG("castle.platform.png"));
			addWall(375, 371, false, Library.IMG("castle.platform.png"));
			addWall(829, 315, false, Library.IMG("castle.platform.png"));
			addWall(700, 272, false, Library.IMG("castle.platform.png"));
			addWall(227, 109, false, Library.IMG("castle.platform.png"));
			addWall(745, 210, false, Library.IMG("castle.platform.png"));
			addWall(1024, 315, false, Library.IMG("castle.platform.png"));
			
			addMan(50, 375, Game.playerClass);
			
			Game.stage.addChild(new HUD);
			
			nextLevel = "mainMenu";
		}
		
		private static function loadCastle_02():void
		{
			
		}
		
		//}
		//	Worlds end
		
		
		/**
		 * Add the player to the world
		 * @param	x		Position on x
		 * @param	y		Position on y
		 * @param	type	Player class
		 */
		private static function addMan(x:int, y:int, type:uint):void 
		{
			Mobs.push(Game.stage.addChild(Game.man = new Player(x, y, type)) as Mob);
		}
		
		
		/**
		 * Loads a level and unloads the previous one
		 * @param	name			The level to load
		 */
		public static function loadLevel(name:String):void
		{
			unloadLevel();
			(Worlds.retrive(name) || Worlds.retrive("mainMenu"))();
			
			SaveState.level = name;
			
			addDecal(new Bitmap(new BitmapData(1000, 500, true, 0xff000000)), 500, 250, fade );
		}
		
		/**
		 * Load the level identified by the current as next
		 */
		public static function next():void
		{
			loadLevel(nextLevel);
		}
		
		
		/**
		 * Callback for the fade decal
		 * @param	i			Standard reference parameter
		 */
		private static function fade(d:Decal):void
		{
			if (d.alpha > 0) 	d.alpha -= 0.075;
			if (d.alpha <= 0)	Game.stage.removeChild(d);
		}
		
		/**
		 * Check if player has reached the exit and load the next level
		 * @param	i			Standard reference parameter
		 */
		static public function advance(d:Decal):void 
		{
			if (Game.man.collisionHull.hitTestObject(d))	next();
		}
		
		
		/**
		 * Add a platform to the world
		 * @param	x			Position on x
		 * @param	y			Position on y
		 * @param	vertical	Whether the platform should be rotated vertically
		 */
		public static function addWall(x:Number, y:Number, vertical:Boolean, bitmap:Bitmap, size:int = 200):void
		{
			Platforms.push(Game.stage.addChild(new Platform(x, y, vertical, bitmap, size) ) );
		}
		
		/**
		 * Add an enemy to the world
		 * @param	x			Position on x
		 * @param	y			Position on y
		 * @param	type		The class of enemy to add	
		 */
		public static function addEnemy(x:Number, y:Number, type:Class):void
		{
			Mobs.push(Game.stage.addChild(new type(x, y) ) as Mob);		
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
		public static function addDecal(bitmap:Bitmap, x:Number, y:Number, callback:Function = null, manipulate:Function = null, frames:Array = null, frameWidth:Number = 0, frameHeight:Number = 0, frameRate:Number = 5, loop:Boolean = true):void
		{
			var decal:Decal = new Decal(bitmap, x, y, callback, frames, frameWidth, frameHeight, frameRate, loop)
			if (manipulate != null)	manipulate(decal);
			Game.stage.addChild(decal);
		}
		
		/**
		 * Adds a procedurally generated ladder to the world
		 * @param	x			Position on x
		 * @param	y			Position on y
		 * @param	height		How high the ladder should be
		 * @param	imageName	Name of image to use for procedural generation
		 */
		public static function addLadder(x:Number, y:Number, height:int, imageName:String = "misc.ladder.png"):void
		{
			Ladders.push(Game.stage.addChild(new Ladder(x, y, height, Library.IMG(imageName).bitmapData)) as Ladder);
		}
		
		/**
		 * Adds a bitmap image that acts as a button
		 * @param	x			Position on x
		 * @param	y			Position on y
		 * @param	image		The bitmap to use
		 * @param	callback	A function reference to call when the button is clicked
		 */
		public static function addButton(x:Number, y:Number, image:Bitmap, callback:Function = null):void
		{
			Game.stage.addChild(new MenuButton(x, y, image, callback));
		}
		
		/**
		 * Add platforms around the edges of the stage
		 */
		public static function makeBounds():void
		{
			addWall(-5, 100, true, Library.IMG("misc.clipPlatform.png"));
			addWall(-5, 300, true, Library.IMG("misc.clipPlatform.png"));
			addWall( -5, 500, true, Library.IMG("misc.clipPlatform.png"));
			
			addWall(100, 405, false, Library.IMG("misc.clipPlatform.png"));
			addWall(300, 405, false, Library.IMG("misc.clipPlatform.png"));
			addWall(500, 405, false, Library.IMG("misc.clipPlatform.png"));
			addWall(700, 405, false, Library.IMG("misc.clipPlatform.png"));
			addWall(900, 405, false, Library.IMG("misc.clipPlatform.png"));
			
			addWall(1005, 100, true, Library.IMG("misc.clipPlatform.png"));
			addWall(1005, 300, true, Library.IMG("misc.clipPlatform.png"));
			addWall( 1005, 500, true, Library.IMG("misc.clipPlatform.png"));
			
			addWall(100, -5, false, Library.IMG("misc.clipPlatform.png"));
			addWall(300, -5, false, Library.IMG("misc.clipPlatform.png"));
			addWall(500, -5, false, Library.IMG("misc.clipPlatform.png"));
			addWall(700, -5, false, Library.IMG("misc.clipPlatform.png"));
			addWall(900, -5, false, Library.IMG("misc.clipPlatform.png"));
		}
		
		/**
		 * Remove all objects from the world
		 */
		private static function unloadLevel():void 
		{
			for 	(var pr:int = World.Projectiles.length; 	pr 	--> 0; )	Game.stage.removeChild(World.Projectiles.pop());
			for 	(var pl:int = World.Platforms.length; 		pl	--> 0; )	Game.stage.removeChild(World.Platforms.pop());
			for 	(var l:int 	= World.Ladders.length; 		l 	--> 0; )	Game.stage.removeChild(World.Ladders.pop());
			for 	(var m:int 	= World.Mobs.length; 			m	--> 0; )	Game.stage.removeChild(World.Mobs.pop());
			while 	(Game.stage.numChildren > 1) 								Game.stage.removeChildAt(1);
			
		}
		
	}

}