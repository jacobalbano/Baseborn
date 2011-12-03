package ifrit 
{
	
	import com.jacobalbano.Animation;
	import com.jacobalbano.Map;
	import com.jacobalbano.Input;
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
			
			Worlds.add("beach_01", loadBeach_01);
			Worlds.add("beach_02", loadBeach_02);
			Worlds.add("beach_03", loadBeach_03);
			Worlds.add("forest_01", loadForest_01);
			Worlds.add("forest_02", loadForest_02);
			Worlds.add("forest_03", loadForest_03);
			Worlds.add("tower_01", loadTower_01);
			Worlds.add("dungeon_01", loadDungeon_01);
			Worlds.add("hellther_01", loadHellther_01);
		}
		
		//	Worlds begin
		//{
		
		/**
		 * Debugging:
		 * 		Trace statement declared in Game class line ~403.
		 * 		Collide man w/ platform to debug.
		 * 		NOTE: First non-bounds platform is #16
		 *//////////////////////////////////////////////////////
		
		private static function loadBeach_01():void
		{
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("beach.bg.png"), 500, 250);
			
			WorldUtils.addMan(500, 490, Player.NONE);
			
			WorldUtils.addTrigger(1023, 375, WorldUtils.advance);
			
			WorldUtils.addDecal(Library.IMG("beach.towerLightning.png"), 835, 10, null, null, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0 , 0, 0, 0, 0, 0, 0, 0, 0 ,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 340, 72,  30, true);
			WorldUtils.addDecal(Library.IMG("beach.shipAnimation.png"), 400, 175, null, null, [0, 1, 2, 3], 270, 193, 5);
			
			nextLevel = "beach_02";
		}
		
		private static function loadBeach_02():void
		{
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("beach.bg2.png"), 500, 250);
			WorldUtils.addDecal(Library.IMG("beach.shipAnimation.png"), 100, 175, null, null, [0, 1, 2, 3], 270, 193, 5);
			
			WorldUtils.addDecal(Library.IMG("beach.crate.png"), 236, 370);
			
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 165, 350, chooseClass_Mage, function (d:Decal):* { d.alpha = 0;} );
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 240, 350, chooseClass_Fighter, function (d:Decal):* { d.alpha = 0; } );
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 285, 350, chooseClass_Rogue, function (d:Decal):* { d.alpha = 0; } );
			
			WorldUtils.addMan( 0, 500, Player.NONE);
			
			WorldUtils.addDecal(Library.IMG("beach.towerLightning.png"), 625, 10, null, null, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0 , 0, 0, 0, 0, 0, 0, 0, 0 , 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 340, 72,  30, true);
			
			nextLevel = "beach_03";
		}
		
		private static function loadBeach_03():void
		{
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("beach.bg2.png"), 500, 250);
			WorldUtils.addDecal(Library.IMG("beach.shipAnimation.png"), 100, 175, null, null, [0, 1, 2, 3], 270, 193, 5);
			WorldUtils.addDecal(Library.IMG("beach.crate.png"), 236, 370);
			
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 165, 350, chooseClass_Mage, function (d:Decal):* { d.alpha = 0;} );
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 240, 350, chooseClass_Fighter, function (d:Decal):* { d.alpha = 0; } );
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 285, 350, chooseClass_Rogue, function (d:Decal):* { d.alpha = 0; } );
			
			if (Game.playerClass == Player.MAGE)
			{
				WorldUtils.addMan( 165, 400, Game.playerClass);
			}
			else if (Game.playerClass == Player.FIGHTER)
			{
				WorldUtils.addMan( 240, 400, Game.playerClass);
			}
			else if (Game.playerClass == Player.ROGUE)
			{
				WorldUtils.addMan( 280, 400, Game.playerClass);
			}
			
			WorldUtils.addTrigger(1023, 375, WorldUtils.advance);
			
			WorldUtils.addDecal(Library.IMG("beach.towerLightning.png"), 625, 10, null, null, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0 , 0, 0, 0, 0, 0, 0, 0, 0 , 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 340, 72,  30, true);
			
			Game.stage.addChild(new HUD);
			
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
			
			WorldUtils.addEnemy(340, 450, Bear);
			WorldUtils.addEnemy(340, 450, ElfMage);
			
			
			WorldUtils.addMan(50, 375, Game.playerClass);
			
			Game.stage.addChild(new RopeBridge(280, 275, 125));
			WorldUtils.addWall(280, 285, false, Library.IMG("misc.clipPlatform.png"), 125);
			
			Game.stage.addChild(new RopeBridge(845, 265, 200));
			WorldUtils.addWall(845, 275, false, Library.IMG("misc.clipPlatform.png"), 200);
			
			WorldUtils.addTrigger(1023, 250, WorldUtils.advance);
			
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
			
			WorldUtils.addTrigger(1023, 375, WorldUtils.advance);
			
			Game.stage.addChild(new HUD);
			
			nextLevel = "forest_03";
		}
		
		private static function loadForest_03():void
		{
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("forest.towerEntranceBG.png"), 500, 200);

			WorldUtils.addMan(50, 375, Game.playerClass);
			
			WorldUtils.addTrigger(500, 375, WorldUtils.advance);
			
			Game.stage.addChild(new HUD);
			
			nextLevel = "tower_01";
		}
		
		private static function loadTower_01():void
		{
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("tower.bg.png"), 500, 200);
			
			WorldUtils.addDecal(Library.IMG("tower.decals.chandelier.png"), 150, 50.5, null, null , [0, 1, 2, 3], 46, 101);
			WorldUtils.addDecal(Library.IMG("tower.decals.chandelier.png"), 850, 50.5, null, null , [0, 1, 2, 3], 46, 101);

			WorldUtils.addMan(50, 375, Game.playerClass);
			
			WorldUtils.addTrigger(1023, 375, WorldUtils.advance);
			
			Game.stage.addChild(new HUD);
			
			nextLevel = "dungeon_01";
		}
		
		private static function loadDungeon_01():void 
		{
			WorldUtils.makeBounds();
			
			Game.stage.addChild(Library.IMG("dungeon.bg.png"));
			
			WorldUtils.addDecal(Library.IMG("dungeon.decals.stainedGlass.png"), 515.5, 218);
			
			WorldUtils.addDecal(Library.IMG("dungeon.decals.chandelier.png"), 923, 165.5, null, null , [0, 1, 2, 3], 46, 101);
			WorldUtils.addDecal(Library.IMG("dungeon.decals.chandelier.png"), 73, 165.5, null, null, [0, 1, 2, 3], 46, 101);
			
			WorldUtils.addDecal(Library.IMG("dungeon.decals.shield.png"), 180, 80);
			WorldUtils.addDecal(Library.IMG("dungeon.decals.shield.png"), 280, 80);
			WorldUtils.addDecal(Library.IMG("dungeon.decals.torch.png"), 230, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			
			WorldUtils.addDecal(Library.IMG("dungeon.decals.shield.png"), 650, 80);
			WorldUtils.addDecal(Library.IMG("dungeon.decals.shield.png"), 750, 80);
			WorldUtils.addDecal(Library.IMG("dungeon.decals.torch.png"), 700, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			
			WorldUtils.addLadder(112, 100, 260);
			WorldUtils.addLadder(855, 200, 115);
			
			WorldUtils.addEnemy(724, 75, ElfMage);
			WorldUtils.addEnemy(924, 75, ElfMage);
			WorldUtils.addEnemy(600, 336, ElfMage);
			WorldUtils.addEnemy(495, 130, ElfMage);
			WorldUtils.addEnemy(170, 180, ElfMage);
			
			WorldUtils.addWall( 0, 110, false, Library.IMG("dungeon.platform.png"));
			WorldUtils.addWall(150, 250, true, Library.IMG("dungeon.platform.png"));
			WorldUtils.addWall(255, 186, false, Library.IMG("dungeon.platform.png"));
			WorldUtils.addWall(495, 229, false, Library.IMG("dungeon.platform.png"));
			WorldUtils.addWall(495, 144, false, Library.IMG("dungeon.platform.png"));
			WorldUtils.addWall(800, 110, false, Library.IMG("dungeon.platform.png"), 400);
			WorldUtils.addWall(772, 414, true, Library.IMG("dungeon.platform.png"));
			WorldUtils.addWall(600, 346, false, Library.IMG("dungeon.platform.png"));
			WorldUtils.addWall(375, 371, false, Library.IMG("dungeon.platform.png"));
			WorldUtils.addWall(829, 315, false, Library.IMG("dungeon.platform.png"));
			WorldUtils.addWall(700, 272, false, Library.IMG("dungeon.platform.png"));
			WorldUtils.addWall(227, 109, false, Library.IMG("dungeon.platform.png"));
			WorldUtils.addWall(745, 210, false, Library.IMG("dungeon.platform.png"));
			//WorldUtils.addWall(1024, 315, false, Library.IMG("dungeon.platform.png"));
			
			WorldUtils.addMan(50, 375, Game.playerClass);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addDecal(Library.IMG("dungeon.decals.door.png"), 855, 363.5, WorldUtils.advance);
			
			nextLevel = "hellther_01";
		}
		
		private static function loadHellther_01():void
		{
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("hellther.bg.png"), 500, 200);
			
			// Top row (#16-18)
			WorldUtils.addWall(228, 24, false, Library.IMG("forest.platform.png"), 446);
			WorldUtils.addWall(505, 10, false, Library.IMG("forest.platform.png"), 96);
			WorldUtils.addWall(745, 10, false, Library.IMG("forest.platform.png"), 294);
			
			// Far right edge (#19-20)
			WorldUtils.addWall(986, 48, true, Library.IMG("forest.platform.png"), 53);
			WorldUtils.addWall(999, 152, true, Library.IMG("forest.platform.png"), 126);
			
			// Far left edge (#21-22)
			WorldUtils.addWall(0, 120, true, Library.IMG("forest.platform.png"), 181);
			WorldUtils.addWall(-1, 302, true, Library.IMG("forest.platform.png"), 81);
			
			//Second row (#23-25)
			WorldUtils.addWall(810, 80, false, Library.IMG("forest.platform.png"), 340);
			WorldUtils.addWall(574, 54, false, Library.IMG("forest.platform.png"), 161);
			WorldUtils.addWall(329, 79, false, Library.IMG("forest.platform.png"), 359);
			
			// Hole (#26-27)
			WorldUtils.addWall(406, 132, false, Library.IMG("forest.platform.png"), 270);
			WorldUtils.addWall(747, 131, false, Library.IMG("forest.platform.png"), 270);
			
			// Pit (#28-29)
			WorldUtils.addWall(611, 313, true, Library.IMG("forest.platform.png"), 173);
			WorldUtils.addWall(530, 309, true, Library.IMG("forest.platform.png"), 183);
			
			// Entrance ladder (#30-31)
			WorldUtils.addWall(418, 375, true, Library.IMG("forest.platform.png"), 52);
			WorldUtils.addWall(477, 350, true, Library.IMG("forest.platform.png"), 93);
			
			// Top left smalls (column L to R) (#32-33)
			WorldUtils.addWall(20, 125, false, Library.IMG("forest.platform.png"), 31);
			WorldUtils.addWall(16, 179, false, Library.IMG("forest.platform.png"), 22);
			/**/// (#34-36)
			WorldUtils.addWall(126, 111, false, Library.IMG("forest.platform.png"), 45);
			WorldUtils.addWall(105, 151, false, Library.IMG("forest.platform.png"), 86);
			WorldUtils.addWall(142, 163, false, Library.IMG("forest.platform.png"), 161);
			/**/// (#37-39)
			WorldUtils.addWall(155, 112, true, Library.IMG("forest.platform.png"), 55);
			WorldUtils.addWall(187, 126, false, Library.IMG("forest.platform.png"), 46);
			WorldUtils.addWall(217, 140, true, Library.IMG("forest.platform.png"), 39);
			
			// Bottom right smalls (L to R) (#40-44)
			WorldUtils.addWall(20, 347, false, Library.IMG("forest.platform.png"), 38);
			WorldUtils.addWall(50, 357, false, Library.IMG("forest.platform.png"), 25);
			WorldUtils.addWall(75, 367, false, Library.IMG("forest.platform.png"), 25);
			WorldUtils.addWall(149, 320, false, Library.IMG("forest.platform.png"), 105);
			WorldUtils.addWall(162, 309, false, Library.IMG("forest.platform.png"), 62);
			
			// Middle smalls (bottom to top) (#45-48)
			WorldUtils.addWall(471, 280, false, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(487, 263, false, Library.IMG("forest.platform.png"), 14);
			WorldUtils.addWall(499, 243, true, Library.IMG("forest.platform.png"), 30);
			WorldUtils.addWall(510, 223, false, Library.IMG("forest.platform.png"), 32);
			
			// Right smalls (L to R) (#49-51)
			WorldUtils.addWall(887, 155, true, Library.IMG("forest.platform.png"), 58);
			WorldUtils.addWall(905, 152, false, Library.IMG("forest.platform.png"), 25);
			WorldUtils.addWall(974, 186, false, Library.IMG("forest.platform.png"), 40);
			
			// Other horizontals (top to bottom) (#52-59)
			WorldUtils.addWall(140, 216, false, Library.IMG("forest.platform.png"), 276);
			WorldUtils.addWall(801, 223, false, Library.IMG("forest.platform.png"), 390);
			WorldUtils.addWall(372, 233, false, Library.IMG("forest.platform.png"), 161);
			WorldUtils.addWall(220, 255, false, Library.IMG("forest.platform.png"), 427);
			WorldUtils.addWall(327, 296, false, Library.IMG("forest.platform.png"), 270);
			WorldUtils.addWall(365, 354, false, Library.IMG("forest.platform.png"), 95);
			WorldUtils.addWall(205, 377, false, Library.IMG("forest.platform.png"), 233);
			
			// Other verticals (L to R) (#60-61)
			WorldUtils.addWall(276, 174, true, Library.IMG("forest.platform.png"), 75);
			WorldUtils.addWall(288, 185, true, Library.IMG("forest.platform.png"), 86);
			
			
			WorldUtils.addLadder(447, 345, 55, "hellther.ladder.png");
			WorldUtils.addLadder(576, 0, 49, "hellther.ladder.png");

			WorldUtils.addMan(435, 300, Game.playerClass);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addDecal(new Bitmap(new BitmapData(50, 50, true, 0)), 500, 375, WorldUtils.advance);
			
			nextLevel = "mainMenu";
		}
		
		//}
		//	Worlds end
		
		static private function chooseClass_Mage(d:Decal):void 
		{
			if (d.hitTestObject(Game.man.collisionHull))
			{
				if (d.alpha <= 1) d.alpha += 0.05;
				
				if (Input.isKeyDown(Input.UP))
				{
					SaveState.playerClass = Player.MAGE;
					Game.playerClass = Player.MAGE;
					WorldUtils.loadLevel("beach_03");
				}
			}
			else
			{
				if (d.alpha >= 0) d.alpha -= 0.05;
			}
		}
		
		private static function chooseClass_Fighter(d:Decal):void 
		{
			if (d.hitTestObject(Game.man.collisionHull))
			{
				if (d.alpha <= 1) d.alpha += 0.05;
				
				if (Input.isKeyDown(Input.UP))
				{
					SaveState.playerClass = Player.FIGHTER;
					Game.playerClass = Player.FIGHTER;
					WorldUtils.loadLevel("beach_03");
				}
			}
			else
			{
				if (d.alpha >= 0) d.alpha -= 0.05;
			}
		}
		
		private static function chooseClass_Rogue(d:Decal):void 
		{
			if (d.hitTestObject(Game.man.collisionHull))
			{
				if (d.alpha <= 1) d.alpha += 0.05;
				
				if (Input.isKeyDown(Input.UP))
				{
					SaveState.playerClass = Player.ROGUE;
					Game.playerClass = Player.ROGUE;
					WorldUtils.loadLevel("beach_03");
				}
			}
			else
			{
				if (d.alpha >= 0) d.alpha -= 0.05;
			}
		}
		
		
	}

}