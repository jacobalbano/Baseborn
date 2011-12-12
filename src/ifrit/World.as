package ifrit 
{
	
	import com.jacobalbano.Input;
	import com.jacobalbano.Map;
	import com.thaumaturgistgames.flakit.Library;
	import flash.geom.Point;
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
		public static var Variables:Map;
		public static var nextLevel:String;
		public static var currentLevel:String;
		public static var hasKey:Boolean;
		public static var Songs:Audio;
		public static var Sounds:Audio;
		
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
			//	It works the same way as a C++ (STL) map, storing objects with keys
			Worlds = new Map(String, Function);
			
			Worlds.add("beach_01", 		loadBeach_01);
			Worlds.add("beach_02", 		loadBeach_02);
			Worlds.add("beach_03", 		loadBeach_03);
			Worlds.add("forest_01", 	loadForest_01);
			Worlds.add("forest_02", 	loadForest_02);
			Worlds.add("forest_03", 	loadForest_03);
			Worlds.add("tower_01", 		loadTower_01);
			Worlds.add("tower_02", 		loadTower_02);
			Worlds.add("dungeon_01", 	loadDungeon_01);
			Worlds.add("hellther_01", 	loadHellther_01);
			Worlds.add("balcony_01", 	loadBalcony_01);
			
			Variables = new Map(String, Variable);
			
			Songs = new Audio;
			Sounds = new Audio;
			
			Songs.addMusic("beach", Library.SND("audio.music.beach.mp3"));
			Songs.addMusic("forest", Library.SND("audio.music.forest.mp3"));
			Songs.addMusic("tower", Library.SND("audio.music.tower.mp3"));
			Songs.addMusic("dungeon", Library.SND("audio.music.dungeon.mp3"));
			Songs.addMusic("hellther", Library.SND("audio.music.hellther.mp3"));
			
			Sounds.addSFX("smallDoor", Library.SND("audio.sfx.smallDoorOpen.mp3"));
		}
		
		//	Worlds begin
		//{
		
		/**
		 * Debugging:
		 * 		Trace statement declared in Game class line ~403.
		 * 		Collide man w/ platform to debug.
		 * 		NOTE: First non-bounds platform is #12
		 *//////////////////////////////////////////////////////
		
		private static function loadBeach_01():void
		{
			Songs.playMusic("beach", 3);
			
			WorldUtils.makeBounds();
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addDecal(Library.IMG("beach.bg.png"), 500, 250);
			
			WorldUtils.addMan(500, 490, Player.NONE);
			Game.man.graphic.play("getUp");
			
			WorldUtils.addTrigger(1023, 375, WorldUtils.advance);
			
			WorldUtils.addDecal(Library.IMG("beach.towerLightning.png"), 835, 10, null, null, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 , 0 , 0, 0, 0, 0, 0, 0, 0, 0 ,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17], 340, 72,  30, true);
			WorldUtils.addDecal(Library.IMG("beach.shipAnimation.png"), 400, 175, null, null, [0, 1, 2, 3], 270, 193, 5);
			WorldUtils.addDecal(Library.IMG("beach.waterDebris2.png"), 500, 250);
	
			
			nextLevel = "beach_02";
		}
		
		private static function loadBeach_02():void
		{
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("beach.bg2.png"), 500, 250);
			WorldUtils.addDecal(Library.IMG("beach.shipAnimation.png"), 100, 175, null, null, [0, 1, 2, 3], 270, 193, 5);
			WorldUtils.addDecal(Library.IMG("beach.waterDebris.png"), 500, 250);
			
			WorldUtils.addDecal(Library.IMG("beach.crate.png"), 236, 370);
			
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 165, 350, chooseClass_Mage, function (d:Decal):* { d.alpha = 0;} );
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 240, 350, chooseClass_Fighter, function (d:Decal):* { d.alpha = 0; } );
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 285, 350, chooseClass_Rogue, function (d:Decal):* { d.alpha = 0; } );
			
			WorldUtils.addEnemy(975, 385, Debris);
			
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
			WorldUtils.addDecal(Library.IMG("beach.waterDebris.png"), 500, 250);
			
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 165, 350, chooseClass_Mage, function (d:Decal):* { d.alpha = 0;} );
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 240, 350, chooseClass_Fighter, function (d:Decal):* { d.alpha = 0; } );
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 285, 350, chooseClass_Rogue, function (d:Decal):* { d.alpha = 0; } );
			WorldUtils.addDecal(Library.IMG("misc.keyD.png"), 930, 350, destroyDebris, function (d:Decal):* { d.alpha = 0; } );
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addEnemy(975, 385, Debris);
			
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
			
			nextLevel = "forest_01";
		}
		
		private static function loadForest_01():void
		{
			Songs.stopMusic("beach");
			Songs.playMusic("forest", 3);
			
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("forest.forestBG.png"), 500, 200 );
			WorldUtils.addDecal(Library.IMG("forest.decals.stump.png"), 450, 375);
			WorldUtils.addDecal(Library.IMG("forest.house.png"), 150, 253);
			WorldUtils.addDecal(Library.IMG("forest.house2.png"), 400, 253, null, function (d:Decal):*	{	d.rotationY = 180;	} );
			WorldUtils.addDecal(Library.IMG("forest.house.png"), 566, 307, null, function (d:Decal):*	{	d.rotationY = 180;	});
			WorldUtils.addDecal(Library.IMG("forest.house.png"), 1024, 240, null, function (d:Decal):*	{	d.rotationY = 180;	});
			
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 55, 355, trainClimb, function (d:Decal):* { d.alpha = 0;} );
			WorldUtils.addDecal(Library.IMG("misc.keySpace.png"), 165, 285, trainJump, function (d:Decal):* { d.alpha = 0;} );
			
			WorldUtils.addWall(158, 285, false, Library.IMG("forest.platform.png"), 125);
			WorldUtils.addWall(390, 285, false, Library.IMG("forest.platform.png"), 125);
			WorldUtils.addWall(585, 340, false, Library.IMG("forest.platform.png"), 125);
			WorldUtils.addWall(700, 265, false, Library.IMG("forest.platform.png"), 100);
			WorldUtils.addWall(975, 265, false, Library.IMG("forest.platform.png"), 50);
			
			WorldUtils.addLadder(80, 275, 115, "misc.ropeLadder.png");
			WorldUtils.addLadder(635, 260, 75, "misc.ropeLadder.png");
			
			WorldUtils.addEnemy(340, 450, Bear);
			WorldUtils.addEnemy(340, 700, Wolf);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(50, 375, Game.playerClass);
			
			Game.stage.addChild(new RopeBridge(845, 255, 200));
			WorldUtils.addWall(845, 265, false, Library.IMG("misc.clipPlatform.png"), 200);
			
			WorldUtils.addTrigger(1023, 240, WorldUtils.advance);
			
			nextLevel = "forest_02";
		}
		
		private static function loadForest_02():void
		{
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("forest.forestBG.png"), 500, 200, null, function (d:Decal):* {	d.rotationY = 180;	} );
			
			WorldUtils.addDecal(Library.IMG("forest.house.png"), -24, 240, null, function (d:Decal):*	{	d.rotationY = 180;	});
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addWall(0, 265, false, Library.IMG("forest.platform.png"), 200);
			
			WorldUtils.addMan(0, 240, Game.playerClass);
			
			if (Game.man.type == Player.ROGUE)
			{
				WorldUtils.addEnemy(300, 310, Giant);
				WorldUtils.addDecal(Library.IMG("misc.doubleRight.png"), 225, 395, trainBlink, function (d:Decal):* { d.alpha = 0;} );
			}
			
			WorldUtils.addTrigger(1023, 375, WorldUtils.advance);
			
			nextLevel = "forest_03";
		}
		
		private static function loadForest_03():void
		{
			WorldUtils.makeBounds();
			
			World.hasKey = true;
			
			Variables.add("door tick left", new Variable(0));
			Variables.add("door tick right", new Variable(0));
			Variables.add("opening", new Variable);
			
			WorldUtils.addDecal(Library.IMG("forest.towerDoor.png"), 500, 200);
			WorldUtils.addDecal(Library.IMG("forest.archway.png"), 501, 210);
			WorldUtils.addDecal(Library.IMG("forest.leftDoor.png"), 401, 218, function (d:Decal):*	{ 	if (d.rotationY <= 45 && Variables.retrive("opening").bool)	trace(Variables.retrive("door tick left").number = d.rotationY += 1);	} );
			WorldUtils.addDecal(Library.IMG("forest.rightDoor.png"), 601, 218, function (d:Decal):*	{	if (Math.abs(d.rotationY) <= 22 && Variables.retrive("opening").bool)  trace(Variables.retrive("door tick right").number = d.rotationY -= 0.50)} );
			WorldUtils.addDecal(Library.IMG("forest.lavaAnimation.png"), 94, 235, null, null, [0, 1, 2, 3], 110, 220, 5);

			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(50, 375, Game.playerClass);
			
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 500, 375, towerDoorAdvance, function (d:Decal):* { d.alpha = 0;} );
			
			nextLevel = "tower_01";
		}
		
		private static function towerDoorAdvance(d:Decal):void 
		{
			if (Math.abs(Variables.retrive("door tick right").number) >= 22 && Variables.retrive("door tick left").number >= 45)	WorldUtils.chooseAdvance(d);
		}
		
		private static function loadTower_01():void
		{
			Songs.stopMusic("forest");
			Songs.playMusic("tower", 3);
			
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("tower.bg.png"), 500, 200);
			
			WorldUtils.addDecal(Library.IMG("tower.decals.stainedGlass.png"), 546, 210);
			WorldUtils.addDecal(Library.IMG("tower.decals.chandelier.png"), 850, 50.5, null, null , [0, 1, 2, 3], 46, 101);
			WorldUtils.addDecal(Library.IMG("tower.layouts.layout1.png"), 500, 200);
			
			WorldUtils.addEnemy(700, 350, Guard);
			WorldUtils.addEnemy(400, 350, ElfMage);
			WorldUtils.addEnemy(700, 350, Archer);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addLadder(50, 42, 245);
			WorldUtils.addLadder(790, 93, 178);
			WorldUtils.addLadder(976, 336, 64);
			
			WorldUtils.addMan(50, 375, Game.playerClass);
			
			WorldUtils.addWall(243, 294, false, Library.IMG("misc.clipPlatform.png"), 488);
			WorldUtils.addWall(483, 317, true, Library.IMG("misc.clipPlatform.png"), 37);
			WorldUtils.addWall(519, 330, false, Library.IMG("misc.clipPlatform.png"), 65);
			WorldUtils.addWall(684, 365, false, Library.IMG("misc.clipPlatform.png"), 128);
			WorldUtils.addWall(597, 254, false, Library.IMG("misc.clipPlatform.png"), 101);
			WorldUtils.addWall(642, 237, true, Library.IMG("misc.clipPlatform.png"), 25);
			WorldUtils.addWall(702, 220, false, Library.IMG("misc.clipPlatform.png"), 108);
			WorldUtils.addWall(542, 178, false, Library.IMG("misc.clipPlatform.png"), 136);
			WorldUtils.addWall(752, 227, true, Library.IMG("misc.clipPlatform.png"), 349);
			WorldUtils.addWall(396, 249, true, Library.IMG("misc.clipPlatform.png"), 83);
			WorldUtils.addWall(360, 203, false, Library.IMG("misc.clipPlatform.png"), 83);
			WorldUtils.addWall(324, 230, true, Library.IMG("misc.clipPlatform.png"), 44);
			WorldUtils.addWall(345, 246, false, Library.IMG("misc.clipPlatform.png"), 33);
			WorldUtils.addWall(367, 270, true, Library.IMG("misc.clipPlatform.png"), 39);
			WorldUtils.addWall(267, 145, true, Library.IMG("misc.clipPlatform.png"), 196);
			WorldUtils.addWall(184, 237, false, Library.IMG("misc.clipPlatform.png"), 159);
			WorldUtils.addWall(108, 142, true, Library.IMG("misc.clipPlatform.png"), 181);
			WorldUtils.addWall(187, 47, false, Library.IMG("misc.clipPlatform.png"), 168);
			WorldUtils.addWall(405, 47, false, Library.IMG("misc.clipPlatform.png"), 127);
			WorldUtils.addWall(616, 47, false, Library.IMG("misc.clipPlatform.png"), 135);
			WorldUtils.addWall(839, 47, false, Library.IMG("misc.clipPlatform.png"), 184);
			WorldUtils.addWall(911, 98, false, Library.IMG("misc.clipPlatform.png"), 177);
			WorldUtils.addWall(828, 161, true, Library.IMG("misc.clipPlatform.png"), 117);
			WorldUtils.addWall(916, 215, false, Library.IMG("misc.clipPlatform.png"), 167);
			WorldUtils.addWall(821, 276, false, Library.IMG("misc.clipPlatform.png"), 130);
			WorldUtils.addWall(883, 291, true, Library.IMG("misc.clipPlatform.png"), 21);
			WorldUtils.addWall(902, 307, false, Library.IMG("misc.clipPlatform.png"), 32);
			WorldUtils.addWall(914, 323, true, Library.IMG("misc.clipPlatform.png"), 23);
			WorldUtils.addWall(933, 340, false, Library.IMG("misc.clipPlatform.png"), 36);
			WorldUtils.addWall(947, 373, true, Library.IMG("misc.clipPlatform.png"), 57);
			
			if (Game.playerClass == Player.MAGE)
			{
				Variables.add("lever", new Variable(0, false, ""));
				WorldUtils.addDecal(Library.IMG("misc.keyS.png"), 240, 350, openGate, function (d:Decal):* { d.alpha = 0; } );
				WorldUtils.addDecal(Library.IMG("misc.leverL.png"), 690, 382, hitLever);
				
				WorldUtils.addDecal(Library.IMG("tower.decals.gateWall.png"), 275, 350);
				WorldUtils.addWall(265, 350, true, Library.IMG("misc.clipPlatform.png"), 105);
				WorldUtils.addWall(295, 350, true, Library.IMG("misc.clipPlatform.png"), 105);
			}
			
			WorldUtils.addTrigger(980, 425, WorldUtils.advance);
			
			nextLevel = "tower_02";
		}
		
		private static function openGate(d:Decal):void
		{
			if (d.hitTestObject(Game.man.collisionHull))
			{
				if (!Input.isKeyDown(Input.S))
				{
					if (d.alpha <= 1) d.alpha += 0.05;
				}
				else
				{
					if (d.alpha >= 0) d.alpha -= 0.05;
				}
			}
			else
			{
				if (d.alpha >= 0) d.alpha -= 0.05;
			}
		}
		
		private static function hitLever(d:Decal):void
		{
			if (Variables.retrive("lever").string == "open") return;
			
			if (Game.man.lightningAttack && Game.man.boltPlaying && !Variables.retrive("lever").bool)
			{
				if (Game.man.lightningAttack.hitTestObject(d))
				{
					if (d.rotationY == 0) 			d.rotationY = 180;
					else if (d.rotationY == 180)	d.rotationY = 0;
					
					Variables.retrive("lever").bool = true;
				}
			}
			
			if (!Game.man.boltPlaying)	Variables.retrive("lever").bool = false;
			
			if (d.rotationY == 180 && Variables.retrive("lever").string != "open")
			{
				WorldUtils.addDecal(Library.IMG("tower.decals.gate.png"), 330, 350, null, null, [0, 1, 2, 3, 4], 135, 95, 5, false);
				Variables.retrive("lever").string = "open"
				Platforms.splice(41, 2);
			}
		}
		
		private static function loadTower_02():void
		{
			WorldUtils.makeBounds();
			
			hasKey = true;
			
			Game.stage.addChild(Library.IMG("tower.bg.png"));
			
			WorldUtils.addDecal(Library.IMG("tower.decals.stainedGlass.png"), 546, 218);
			
			WorldUtils.addDecal(Library.IMG("tower.decals.chandelier.png"), 923, 165.5, null, null , [0, 1, 2, 3], 46, 101);
			WorldUtils.addDecal(Library.IMG("tower.decals.chandelier.png"), 73, 165.5, null, null, [0, 1, 2, 3], 46, 101);
			
			WorldUtils.addDecal(Library.IMG("tower.decals.shield.png"), 180, 80);
			WorldUtils.addDecal(Library.IMG("tower.decals.shield.png"), 280, 80);
			WorldUtils.addDecal(Library.IMG("tower.decals.torch.png"), 230, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			
			WorldUtils.addDecal(Library.IMG("tower.decals.shield.png"), 650, 80);
			WorldUtils.addDecal(Library.IMG("tower.decals.shield.png"), 750, 80);
			WorldUtils.addDecal(Library.IMG("tower.decals.torch.png"), 700, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			
			WorldUtils.addLadder(30, 0, 110);
			WorldUtils.addLadder(112, 100, 260);
			WorldUtils.addLadder(855, 200, 115);
			WorldUtils.addLadder(940, 300, 200);
			
			WorldUtils.addEnemy(724, 75, ElfMage);
			WorldUtils.addEnemy(924, 75, ElfMage);
			WorldUtils.addEnemy(600, 336, ElfMage);
			WorldUtils.addEnemy(495, 130, ElfMage);
			WorldUtils.addEnemy(170, 180, ElfMage);
			
			WorldUtils.addWall( 0, 110, false, Library.IMG("tower.platform.png"));
			WorldUtils.addWall(150, 250, true, Library.IMG("tower.platform.png"));
			WorldUtils.addWall(255, 186, false, Library.IMG("tower.platform.png"));
			WorldUtils.addWall(495, 229, false, Library.IMG("tower.platform.png"));
			WorldUtils.addWall(495, 144, false, Library.IMG("tower.platform.png"));
			WorldUtils.addWall(800, 110, false, Library.IMG("tower.platform.png"), 400);
			WorldUtils.addWall(772, 414, true, Library.IMG("tower.platform.png"));
			WorldUtils.addWall(600, 346, false, Library.IMG("tower.platform.png"));
			WorldUtils.addWall(375, 371, false, Library.IMG("tower.platform.png"));
			WorldUtils.addWall(829, 315, false, Library.IMG("tower.platform.png"));
			WorldUtils.addWall(700, 272, false, Library.IMG("tower.platform.png"));
			WorldUtils.addWall(227, 109, false, Library.IMG("tower.platform.png"));
			WorldUtils.addWall(745, 210, false, Library.IMG("tower.platform.png"));
			
			WorldUtils.addDecal(Library.IMG("tower.decals.door.png"), 855, 363.5);
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 855, 363.5, WorldUtils.chooseAdvance, function (d:Decal):* { d.alpha = 0;	} );
			WorldUtils.addDecal(Library.IMG("misc.padlock.png"), 855, 363.5, WorldUtils.doorLocked, function (d:Decal):* { d.alpha = 0;	} );
			
			WorldUtils.addLadder(940, 300, 200);
			
			WorldUtils.addEnemy(724, 75, ElfMage);
			WorldUtils.addEnemy(924, 75, ElfMage);
			WorldUtils.addEnemy(600, 336, ElfMage);
			WorldUtils.addEnemy(495, 130, ElfMage);
			WorldUtils.addEnemy(170, 180, ElfMage);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(20, 15, Game.playerClass);
			
			nextLevel = "dungeon_01";
		}
		
		private static function loadDungeon_01():void 
		{
			Songs.stopMusic("tower");
			Songs.playMusic("dungeon", 3);
			
			WorldUtils.makeBounds();
			
			Game.stage.addChild(Library.IMG("dungeon.bg.png"));
			
			WorldUtils.addDecal(Library.IMG("dungeon.decals.torch.png"), 230, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			WorldUtils.addDecal(Library.IMG("dungeon.decals.torch.png"), 700, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			WorldUtils.addDecal(Library.IMG("dungeon.decals.cellDoor.png"), 200, 369.5);
			WorldUtils.addDecal(Library.IMG("dungeon.decals.crevice.png"), 920, 80, null, null, [0, 1, 2, 3], 149, 44, 2);
			
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 920, 80, WorldUtils.chooseAdvance, function (d:Decal):* { d.alpha = 0;} );
			
			WorldUtils.addLadder(112, 100, 260);
			WorldUtils.addLadder(855, 200, 115);
			
			WorldUtils.addEnemy(724, 75, Skeleton);
			WorldUtils.addEnemy(924, 75, Skeleton);
			WorldUtils.addEnemy(600, 336, SkeletonMage);
			WorldUtils.addEnemy(495, 130, Zombie);
			WorldUtils.addEnemy(170, 180, Spider);
			WorldUtils.addEnemy(200, 360, Zombie);
			WorldUtils.addEnemy(600, 360, Spider);
			
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
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(50, 375, Game.playerClass);
			
			nextLevel = "hellther_01";
		}
		
		private static function loadHellther_01():void
		{
			Songs.stopMusic("dungeon");
			Songs.playMusic("hellther", 3);
			
			WorldUtils.makeBounds();
			
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
			WorldUtils.addWall(339, 79, false, Library.IMG("forest.platform.png"), 355);
			
			// Hole (#26-27)
			WorldUtils.addWall(406, 132, false, Library.IMG("forest.platform.png"), 270);
			WorldUtils.addWall(747, 131, false, Library.IMG("forest.platform.png"), 270);
			
			// Pit (#28-29)
			WorldUtils.addWall(611, 313, true, Library.IMG("forest.platform.png"), 173);
			WorldUtils.addWall(530, 318, true, Library.IMG("forest.platform.png"), 183);
			
			// Entrance ladder (#30-31)
			WorldUtils.addWall(418, 384, true, Library.IMG("forest.platform.png"), 52);
			WorldUtils.addWall(477, 350, true, Library.IMG("forest.platform.png"), 93);
			
			// Top left smalls (column L to R) (#32-33)
			WorldUtils.addWall(20, 125, false, Library.IMG("forest.platform.png"), 31);
			WorldUtils.addWall(16, 179, false, Library.IMG("forest.platform.png"), 22);
			/**/// (#34-36)
			WorldUtils.addWall(126, 111, false, Library.IMG("forest.platform.png"), 45);
			WorldUtils.addWall(105, 151, false, Library.IMG("forest.platform.png"), 86);
			WorldUtils.addWall(142, 163, false, Library.IMG("forest.platform.png"), 158);
			/**/// (#37-39)
			WorldUtils.addWall(155, 112, true, Library.IMG("forest.platform.png"), 55);
			WorldUtils.addWall(187, 126, false, Library.IMG("forest.platform.png"), 46);
			WorldUtils.addWall(217, 143, true, Library.IMG("forest.platform.png"), 39);
			
			// Bottom right smalls (L to R) (#40-44)
			WorldUtils.addWall(20, 347, false, Library.IMG("forest.platform.png"), 38);
			WorldUtils.addWall(50, 357, false, Library.IMG("forest.platform.png"), 25);
			WorldUtils.addWall(75, 367, false, Library.IMG("forest.platform.png"), 25);
			WorldUtils.addWall(149, 320, false, Library.IMG("forest.platform.png"), 105);
			WorldUtils.addWall(162, 309, false, Library.IMG("forest.platform.png"), 62);
			
			// Middle smalls (bottom to top) (#45-48)
			WorldUtils.addWall(471, 280, false, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(487, 263, false, Library.IMG("forest.platform.png"), 14);
			WorldUtils.addWall(499, 252, true, Library.IMG("forest.platform.png"), 50);
			WorldUtils.addWall(515, 223, false, Library.IMG("forest.platform.png"), 15);
			
			// Right smalls (L to R) (#49-51)
			WorldUtils.addWall(887, 155, true, Library.IMG("forest.platform.png"), 51);
			WorldUtils.addWall(905, 152, false, Library.IMG("forest.platform.png"), 25);
			WorldUtils.addWall(974, 186, false, Library.IMG("forest.platform.png"), 40);
			
			// Other horizontals (top to bottom) (#52-59)
			WorldUtils.addWall(140, 216, false, Library.IMG("forest.platform.png"), 276);
			WorldUtils.addWall(801, 223, false, Library.IMG("forest.platform.png"), 390);
			WorldUtils.addWall(372, 233, false, Library.IMG("forest.platform.png"), 161);
			WorldUtils.addWall(220, 255, false, Library.IMG("forest.platform.png"), 427);
			WorldUtils.addWall(336, 296, false, Library.IMG("forest.platform.png"), 270);
			WorldUtils.addWall(365, 354, false, Library.IMG("forest.platform.png"), 95);
			WorldUtils.addWall(205, 377, false, Library.IMG("forest.platform.png"), 233);
			
			// Other verticals (L to R) (#60-61)
			WorldUtils.addWall(276, 174, true, Library.IMG("forest.platform.png"), 75);
			WorldUtils.addWall(288, 185, true, Library.IMG("forest.platform.png"), 86);
			
			WorldUtils.addWall(495, 68, true, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(651, 68, true, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(315, 370, true, Library.IMG("forest.platform.png"), 25);
			
			WorldUtils.addDecal(Library.IMG("hellther.bg.png"), 500, 200);
			WorldUtils.addDecal(Library.IMG("hellther.layout1.png"), 500, 200);
			
			const portal:Point = new Point(950, 45);
			
			WorldUtils.addDecal(Library.IMG("hellther.portalFrame.png"), portal.x, portal.y);
			WorldUtils.addDecal(Library.IMG("hellther.portalSparks.png"), portal.x, portal.y, null, null, [0, 1, 0, 2], 40, 40, 3, true );
			WorldUtils.addDecal(Library.IMG("hellther.portal.png"), portal.x, portal.y, function (d:Decal):*	{	d.rotation += 5; d.alpha = Math.abs(d.rotation) / 180;	} );
			
			WorldUtils.addEnemy(300, 185, Serpent);
			WorldUtils.addEnemy(730, 200, Demon);
			WorldUtils.addEnemy(730, 200, Demon);
			WorldUtils.addEnemy(730, 200, Demon);
			WorldUtils.addEnemy(730, 200, Demon);
			WorldUtils.addEnemy(730, 200, Demon);
			
			WorldUtils.addLadder(447, 345, 55, "hellther.ladder.png");
			WorldUtils.addLadder(576, 0, 49, "hellther.ladder.png");
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(435, 300, Game.playerClass);
			
			WorldUtils.addDecal(Library.IMG("hellther.lavaTrap.png"), 571, 391);
			
			WorldUtils.addTrigger( 550, -15, WorldUtils.advance);
			WorldUtils.addTrigger( 570, 385, WorldUtils.hurt);
			
			nextLevel = "balcony_01";
		}

		private static function loadBalcony_01():void
		{
			Songs.stopMusic("hellther");
			//Songs.playMusic("boss", 5);
			
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("balcony.bg.png"), 500, 200);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addEnemy(720, 260, Doppleganger);
			
			WorldUtils.addMan(570, 45, Game.playerClass);
			
			// Visible
			WorldUtils.addWall(960, 259, false, Library.IMG("balcony.platform.png"), 79);
			WorldUtils.addWall(846, 231, false, Library.IMG("balcony.platform.png"), 48);
			WorldUtils.addWall(724, 205, false, Library.IMG("balcony.platform.png"), 88);
			WorldUtils.addWall(852, 182, false, Library.IMG("balcony.platform.png"), 62);
			WorldUtils.addWall(960, 159, false, Library.IMG("balcony.platform.png"), 80);
			WorldUtils.addWall(835, 125, false, Library.IMG("balcony.platform.png"), 80);
			
			// Floor
			WorldUtils.addWall(626, 295, false, Library.IMG("misc.clipPlatform.png"), 748);
			WorldUtils.addWall(630, 305, false, Library.IMG("misc.clipPlatform.png"), 748);
			WorldUtils.addWall(635, 315, false, Library.IMG("misc.clipPlatform.png"), 748);
			
			WorldUtils.addTrigger(500, 375, WorldUtils.hurt, 1000, 50)
			
			nextLevel = "main_menu";
		}
		//}
		//	Worlds end
		
		
		static private function chooseClass_Mage(d:Decal):void 
		{
			if (d.hitTestObject(Game.man.collisionHull))
			{
				if (d.alpha <= 1) d.alpha += 0.05;
				
				if (Input.isKeyDown(Input.UP)  && !Input.isKeyDown(Input.RIGHT) && !Input.isKeyDown(Input.LEFT))
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
				
				if (Input.isKeyDown(Input.UP) && !Input.isKeyDown(Input.RIGHT) && !Input.isKeyDown(Input.LEFT))
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
				
				if (Input.isKeyDown(Input.UP) && !Input.isKeyDown(Input.RIGHT) && !Input.isKeyDown(Input.LEFT))
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
		
		private static function destroyDebris(d:Decal):void
		{
			if (d.hitTestObject(Game.man.collisionHull))
			{
				if (!Input.isKeyDown(Input.D))
				{
					if (d.alpha <= 1) d.alpha += 0.05;
				}
				else
				{
					if (d.alpha >= 0) d.alpha -= 0.05;
				}
			}
			else
			{
				if (d.alpha >= 0) d.alpha -= 0.05;
			}
		}
		
		private static function trainClimb(d:Decal):void
		{
			if (Game.man.collisionHull.hitTestPoint(80, 390))
			{
				if (!Input.isKeyDown(Input.UP))
				{
					if (d.alpha <= 1) d.alpha += 0.05;
				}
				else
				{
					if (d.alpha >= 0) d.alpha -= 0.05;
				}
			}
			else
			{
				if (d.alpha >= 0) d.alpha -= 0.05;
			}
		}
		
		private static function trainJump(d:Decal):void
		{
			if (d.hitTestObject(Game.man.collisionHull))
			{
				if (!Input.isKeyDown(Input.SPACE))
				{
					if (d.alpha <= 1) d.alpha += 0.05;
				}
				else
				{
					if (d.alpha >= 0) d.alpha -= 0.05;
				}
			}
			else
			{
				if (d.alpha >= 0) d.alpha -= 0.05;
			}
		}
		
		private static function trainBlink(d:Decal):void
		{
			if (Game.man.collisionHull.hitTestPoint(270, 390))
			{
				if (d.alpha <= 1) d.alpha += 0.05;
			}
			else
			{
				if (d.alpha >= 0) d.alpha -= 0.05;
			}
		}
		
	}

}