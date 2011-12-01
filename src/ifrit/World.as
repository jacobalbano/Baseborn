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
		
		public static var Worlds:Map;
		public static var nextLevel:String;
		
		
		
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
			Worlds.add("beach_02", loadBeach_02);
			Worlds.add("forest_01", loadForest_01);
			Worlds.add("forest_02", loadForest_02);
			Worlds.add("forest_03", loadForest_03);
			Worlds.add("castle_01", loadCastle_01);
			Worlds.add("castle_02", loadCastle_02);
		}
		
		//	Worlds begin
		//{
		
		private static function mainMenu():void
		{			
			WorldUtils.addButton(600, 200, Library.IMG("menu.rogue_button.png"), 	function ():void { Game.playerClass = Player.ROGUE; 	SaveState.playerClass = Game.playerClass;	WorldUtils.next();} );
			WorldUtils.addButton(600, 250, Library.IMG("menu.fighter_button.png"), function ():void { Game.playerClass = Player.FIGHTER; 	SaveState.playerClass = Game.playerClass;	WorldUtils.next();} );
			WorldUtils.addButton(600, 300, Library.IMG("menu.mage_button.png"), 	function ():void { Game.playerClass = Player.MAGE; 		SaveState.playerClass = Game.playerClass;	WorldUtils.next(); } );
			
			nextLevel = "beach_01";
		}
		
		private static function loadBeach_01():void
		{
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("beach.bg.png"), 500, 250);
			
			WorldUtils.addMan(500, 490, Player.NONE);
			
			WorldUtils.addDecal(new Bitmap(new BitmapData(50, 50, true, 0)), 1023, 375, WorldUtils.advance);
			
			WorldUtils.addDecal(Library.IMG("beach.lightningBolt.png"), 100, 170, null, null, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 10, 66, 45, false);
			WorldUtils.addDecal(Library.IMG("beach.towerLightning.png"), 835, 30, null, null, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0 , 0, 0, 0, 0, 0, 0, 0, 0 ,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 340, 72,  30, true);
			WorldUtils.addDecal(Library.IMG("beach.shipAnimation.png"), 400, 175, null, null, [0, 1, 2, 3], 270, 193, 5);
			
			nextLevel = "beach_02";
		}
		
		private static function loadBeach_02():void
		{
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("beach.bg.png"), 500, 250);
			
			WorldUtils.addMan( 0, 500, Player.NONE);
			
			WorldUtils.addDecal(new Bitmap(new BitmapData(50, 50, true, 0)), 1023, 375, WorldUtils.advance);
			
			WorldUtils.addDecal(Library.IMG("beach.lightningBolt.png"), 100, 170, null, null, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 10, 66, 45, false);
			WorldUtils.addDecal(Library.IMG("beach.towerLightning.png"), 835, 30, null, null, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0 , 0, 0, 0, 0, 0, 0, 0, 0 ,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 340, 72,  30, true);
			WorldUtils.addDecal(Library.IMG("beach.shipAnimation.png"), 400, 175, null, null, [0, 1, 2, 3], 270, 193, 5);
			
			nextLevel = "forest_01";
		}
		
		private static function loadForest_01():void
		{
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("forest.forestBG.png"), 500, 200 );
			WorldUtils.addDecal(Library.IMG("forest.decals.stump.png"), 450, 375);
			WorldUtils.addDecal(Library.IMG("forest.house.png"), 150, 253);
			WorldUtils.addDecal(Library.IMG("forest.house2.png"), 400, 253, null, function (d:Decal):*	{	d.rotationY = 180;	} );
			WorldUtils.addDecal(Library.IMG("forest.house.png"), 566, 317, null, function (d:Decal):*	{	d.rotationY = 180;	});
			WorldUtils.addDecal(Library.IMG("forest.house.png"), 1024, 250, null, function (d:Decal):*	{	d.rotationY = 180;	});
			
			WorldUtils.addWall(158, 285, false, Library.IMG("forest.platform.png"), 125);
			WorldUtils.addWall(390, 285, false, Library.IMG("forest.platform.png"), 125);
			WorldUtils.addWall(585, 350, false, Library.IMG("forest.platform.png"), 125);
			WorldUtils.addWall(700, 275, false, Library.IMG("forest.platform.png"), 100);
			WorldUtils.addWall(975, 275, false, Library.IMG("forest.platform.png"), 50);
			
			WorldUtils.addLadder(80, 275, 115, "misc.ropeLadder.png");
			WorldUtils.addLadder(635, 270, 75, "misc.ropeLadder.png");
			
			WorldUtils.addEnemy(100, 250, Skeleton);
			WorldUtils.addEnemy(400, 250, Skeleton);
			WorldUtils.addEnemy(400, 350, Skeleton);
			WorldUtils.addEnemy(200, 250, Skeleton);
			WorldUtils.addEnemy(400, 350, SkeletonMage);
			
			WorldUtils.addMan(50, 375, Game.playerClass);
			
			Game.stage.addChild(new RopeBridge(280, 275, 125));
			WorldUtils.addWall(280, 285, false, Library.IMG("misc.clipPlatform.png"), 125);
			
			Game.stage.addChild(new RopeBridge(845, 265, 200));
			WorldUtils.addWall(845, 275, false, Library.IMG("misc.clipPlatform.png"), 200);
			
			WorldUtils.addDecal(new Bitmap(new BitmapData(50, 50, true, 0)), 1023, 250, WorldUtils.advance);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addWall(1000, 1000, false, Library.IMG("misc.clipPlatform.png"));
			
			nextLevel = "forest_02";
		}
		
		private static function loadForest_02():void
		{
			WorldUtils.makeBounds();
			
			//	Manipulation function to flip the backround horizontally when we load it
			WorldUtils.addDecal(Library.IMG("forest.forestBG.png"), 500, 200, null, function (d:Decal):* {	d.rotationY = 180;	} );
			
			WorldUtils.addMan(50, 375, Game.playerClass);
			
			WorldUtils.addDecal(new Bitmap(new BitmapData(50, 50, true, 0)), 1023, 375, WorldUtils.advance);
			
			Game.stage.addChild(new HUD);
			
			nextLevel = "forest_03";
		}
		
		private static function loadForest_03():void
		{
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("forest.towerEntranceBG.png"), 500, 200);

			WorldUtils.addMan(50, 375, Game.playerClass);
			
			WorldUtils.addDecal(new Bitmap(new BitmapData(50, 50, true, 0)), 500, 375, WorldUtils.advance);
			
			Game.stage.addChild(new HUD);
			
			nextLevel = "castle_01";
		}
		
		private static function loadCastle_01():void 
		{
			WorldUtils.makeBounds();
			
			Game.stage.addChild(Library.IMG("castle.bg.png"));
			
			WorldUtils.addDecal(Library.IMG("castle.decals.stainedGlass.png"), 515.5, 218);
			
			WorldUtils.addDecal(Library.IMG("castle.decals.chandelier.png"), 923, 165.5, null, null , [0, 1, 2, 3], 46, 101);
			WorldUtils.addDecal(Library.IMG("castle.decals.chandelier.png"), 73, 165.5, null, null, [0, 1, 2, 3], 46, 101);
			
			WorldUtils.addDecal(Library.IMG("castle.decals.shield.png"), 180, 80);
			WorldUtils.addDecal(Library.IMG("castle.decals.shield.png"), 280, 80);
			WorldUtils.addDecal(Library.IMG("castle.decals.torch.png"), 230, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			
			WorldUtils.addDecal(Library.IMG("castle.decals.shield.png"), 650, 80);
			WorldUtils.addDecal(Library.IMG("castle.decals.shield.png"), 750, 80);
			WorldUtils.addDecal(Library.IMG("castle.decals.torch.png"), 700, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			
			WorldUtils.addDecal(Library.IMG("castle.decals.door.png"), 855, 363.5, WorldUtils.advance);
			
			WorldUtils.addLadder(112, 100, 260);
			WorldUtils.addLadder(855, 200, 115);
			
			WorldUtils.addEnemy(724, 75, ElfMage);
			WorldUtils.addEnemy(924, 75, ElfMage);
			WorldUtils.addEnemy(600, 336, ElfMage);
			WorldUtils.addEnemy(495, 130, ElfMage);
			WorldUtils.addEnemy(170, 180, ElfMage);
			
			WorldUtils.addWall( 0, 110, false, Library.IMG("castle.platform.png"));
			WorldUtils.addWall(150, 250, true, Library.IMG("castle.platform.png"));
			WorldUtils.addWall(255, 186, false, Library.IMG("castle.platform.png"));
			WorldUtils.addWall(495, 229, false, Library.IMG("castle.platform.png"));
			WorldUtils.addWall(495, 144, false, Library.IMG("castle.platform.png"));
			WorldUtils.addWall(800, 110, false, Library.IMG("castle.platform.png"), 400);
			WorldUtils.addWall(772, 414, true, Library.IMG("castle.platform.png"));
			WorldUtils.addWall(600, 346, false, Library.IMG("castle.platform.png"));
			WorldUtils.addWall(375, 371, false, Library.IMG("castle.platform.png"));
			WorldUtils.addWall(829, 315, false, Library.IMG("castle.platform.png"));
			WorldUtils.addWall(700, 272, false, Library.IMG("castle.platform.png"));
			WorldUtils.addWall(227, 109, false, Library.IMG("castle.platform.png"));
			WorldUtils.addWall(745, 210, false, Library.IMG("castle.platform.png"));
			WorldUtils.addWall(1024, 315, false, Library.IMG("castle.platform.png"));
			
			WorldUtils.addMan(50, 375, Game.playerClass);
			
			Game.stage.addChild(new HUD);
			
			nextLevel = "mainMenu";
		}
		
		private static function loadCastle_02():void
		{
			
		}
		
		//}
		//	Worlds end
		
		
		
		
	}

}