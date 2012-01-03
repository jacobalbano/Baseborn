package ifrit 
{
	
	import com.jacobalbano.Input;
	import com.jacobalbano.Map;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		public static var audio:Audio;
		
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
			
			Worlds.add("title", 		loadTitle);
			
			Worlds.add("beach_01", 		loadBeach_01);
			Worlds.add("beach_02", 		loadBeach_02);
			Worlds.add("beach_03", 		loadBeach_03);
			
			Worlds.add("forest_01", 	loadForest_01);
			Worlds.add("forest_02", 	loadForest_02);
			Worlds.add("forest_03", 	loadForest_03);
			
			Worlds.add("tower_01", 		loadTower_01);
			Worlds.add("tower_02", 		loadTower_02);
			Worlds.add("tower_03", 		loadTower_03);
			
			Worlds.add("dungeon_01", 	loadDungeon_01);
			Worlds.add("dungeon_02",    loadDungeon_02);
			Worlds.add("dungeon_03",    loadDungeon_03);
			
			Worlds.add("hellther_01", 	loadHellther_01);
			Worlds.add("hellther_02", 	loadHellther_02);
			Worlds.add("hellther_03", 	loadHellther_03);
			
			Worlds.add("balcony_01", 	loadBalcony_01);
			
			Worlds.add("ending", 	loadEnd);
			
			Variables = new Map(String, Variable);
			
			audio = new Audio;
			
			audio.addMusic("beach", Library.SND("audio.music.beach.mp3"));
			audio.addMusic("forest", Library.SND("audio.music.forest.mp3"));
			audio.addMusic("tower", Library.SND("audio.music.tower.mp3"));
			audio.addMusic("dungeon", Library.SND("audio.music.dungeon.mp3"));
			audio.addMusic("hellther", Library.SND("audio.music.hellther.mp3"));
			audio.addMusic("boss", Library.SND("audio.music.boss.mp3"));
			
			audio.addSFX("titleAmb", Library.SND("audio.sfx.titleScreenAmbiance.mp3"));
			audio.addSFX("beachAmb", Library.SND("audio.sfx.startToBeach.mp3"));
			audio.addSFX("keys", Library.SND("audio.sfx.keys.mp3"));
			audio.addSFX("unlock", Library.SND("audio.sfx.unlock.mp3"));
		}
		
		//	Worlds begin
		//{
		
		/**
		 * Debugging:
		 * 		Trace statement declared in Game class line ~403.
		 * 		Collide man w/ platform to debug.
		 * 		NOTE: First non-bounds platform is #12
		 *//////////////////////////////////////////////////////
		
		private static function loadTitle():void
		{
			audio.playSFX("titleAmb", 3);
			audio.stopAll(["titleAmb"]);
			
			WorldUtils.makeBounds();
			
			Variables.add("intro", new Variable(0, true, ""));
			WorldUtils.addDecal(Library.IMG("titleScreen.png"), 500, 250, beginGame);
			
			nextLevel = "beach_01";
		}
		
		private static function beginGame(d:Decal):void
		{
			if (Input.isKeyDown(Input.ENTER) && Variables.retrive("intro").bool)
			{
				WorldUtils.addDecal(new Bitmap(new BitmapData(1000, 500, true, 0xff000000)), 500, 250, WorldUtils.fadeOutHold);
				Variables.retrive("intro").bool = false;
			}
		}
		 
		private static function loadBeach_01():void
		{
			audio.stopSFX("titleAmb");
			audio.playMusic("beach", 3);
			audio.playSFX("beachAmb", 3);
			
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
			audio.playMusic("beach", 3);
			audio.playSFX("beachAmb", 3);
			
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
			audio.playMusic("beach", 3);
			audio.playSFX("beachAmb", 3);
			
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
			audio.playMusic("forest", 3);
			audio.stopAll(["forest"]);
			
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
			
			WorldUtils.addEnemy(750, 450, Bear);
			WorldUtils.addEnemy(500, 450, Wolf);
			WorldUtils.addEnemy(510, 450, Wolf);
			WorldUtils.addEnemy(520, 450, Wolf);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(50, 375, Game.playerClass);
			
			Game.stage.addChild(new RopeBridge(845, 255, 200));
			WorldUtils.addWall(845, 265, false, Library.IMG("misc.clipPlatform.png"), 200);
			
			WorldUtils.addTrigger(1023, 240, WorldUtils.advance);
			
			nextLevel = "forest_02";
		}
		
		private static function loadForest_02():void
		{
			audio.playMusic("forest", 3);
			
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("forest.forestBG.png"), 500, 200, null, function (d:Decal):* {	d.rotationY = 180;	} );
			
			WorldUtils.addDecal(Library.IMG("forest.house.png"), -24, 240, null, function (d:Decal):*	{	d.rotationY = 180;	});
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addWall(0, 265, false, Library.IMG("forest.platform.png"), 200);
			
			WorldUtils.addEnemy(700, 450, Bear);
			WorldUtils.addEnemy(500, 450, Wolf);
			WorldUtils.addEnemy(510, 450, Wolf);
			WorldUtils.addEnemy(495, 450, Wolf);
			
			WorldUtils.addMan(0, 240, Game.playerClass);
			
			WorldUtils.addTrigger(1023, 375, WorldUtils.advance);
			
			nextLevel = "forest_03";
		}
		
		private static function loadForest_03():void
		{
			audio.playMusic("forest", 3);
			
			WorldUtils.makeBounds();
			
			World.hasKey = true;
			
			Variables.add("door tick left", new Variable(0));
			Variables.add("door tick right", new Variable(0));
			Variables.add("opening", new Variable);
			Variables.add("keyHelp", new Variable(0));
			
			WorldUtils.addDecal(Library.IMG("forest.towerDoor.png"), 500, 200);
			WorldUtils.addDecal(Library.IMG("forest.archway.png"), 501, 210);
			WorldUtils.addDecal(Library.IMG("forest.leftDoor.png"), 401, 218, function (d:Decal):*	{ 	if (d.rotationY <= 45 && Variables.retrive("opening").bool)	Variables.retrive("door tick left").number = d.rotationY += 1;	} );
			WorldUtils.addDecal(Library.IMG("forest.rightDoor.png"), 601, 218, function (d:Decal):*	{	if (Math.abs(d.rotationY) <= 22 && Variables.retrive("opening").bool)  Variables.retrive("door tick right").number = d.rotationY -= 0.50} );
			WorldUtils.addDecal(Library.IMG("forest.lavaAnimation.png"), 94, 235, null, null, [0, 1, 2, 3], 110, 220, 5);
			
			WorldUtils.addLadder(712, 200, 94);
			WorldUtils.addLadder(847, 56, 352);
			
			WorldUtils.addWall(350, 100, false, Library.IMG("tower.platform.png"), 100);
			WorldUtils.addWall(350, 200, false, Library.IMG("tower.platform.png"), 100);
			WorldUtils.addWall(350, 300, false, Library.IMG("tower.platform.png"), 100);
			WorldUtils.addWall(300, 180, true, Library.IMG("tower.platform.png"), 250);
			
			WorldUtils.addWall(651, 200, false, Library.IMG("tower.platform.png"), 100);
			WorldUtils.addWall(664, 300, false, Library.IMG("tower.platform.png"), 124);
			WorldUtils.addWall(770, 300, false, Library.IMG("tower.platform.png"), 75);
			WorldUtils.addWall(770, 200, false, Library.IMG("tower.platform.png"), 75);
			WorldUtils.addWall(729, 183, true, Library.IMG("tower.platform.png"), 244);
			WorldUtils.addWall(779, 60, false, Library.IMG("tower.platform.png"), 110);
			WorldUtils.addWall(935, 60, false, Library.IMG("tower.platform.png"), 150);
			
			WorldUtils.addEnemy(400, 370, Guard);
			WorldUtils.addEnemy(600, 370, Guard);
			
			WorldUtils.addEnemy(800, 180, ElfMage);
			WorldUtils.addEnemy(800, 280, ElfMage);
			
			WorldUtils.addEnemy(900, 20, Archer);
			
			WorldUtils.addEnemy(350, 80, Guard);
			WorldUtils.addEnemy(350, 180, ElfMage);
			WorldUtils.addEnemy(355, 280, Archer);
			
			WorldUtils.addEnemy(650, 180, Guard);
			WorldUtils.addEnemy(650, 280, Guard);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addDecal(Library.IMG("misc.keyA.png"), 790, 30, trainRanged, function (d:Decal):* 	{ d.alpha = 0;	} );
			WorldUtils.addDecal(Library.IMG("misc.padlock.png"), 500, 375, WorldUtils.doorLocked, function (d:Decal):* { d.alpha = 0;	} );
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 500, 375, towerDoorAdvance, function (d:Decal):* { d.alpha = 0; } );
			
			WorldUtils.addTrigger( 357, 180, WorldUtils.safe, 125, 250);
			
			WorldUtils.addMan(50, 375, Game.playerClass);
			
			nextLevel = "tower_01";
		}
		
		private static function towerDoorAdvance(d:Decal):void 
		{
			if (Game.man.collisionHull.hitTestObject(d)	&& Game.man.hasKey)
			{
				if (Input.isKeyDown(Input.UP) && !Input.isKeyDown(Input.LEFT) && !Input.isKeyDown(Input.RIGHT))	Variables.retrive("opening").bool = true;
				if (d.alpha < 1 && !Variables.retrive("opening").bool)	d.alpha += 0.1;
			}
			else 
			{
				if (d.alpha > 0)	d.alpha -= 0.1;
			}
			
			if (Math.abs(Variables.retrive("door tick right").number) >= 22 && Variables.retrive("door tick left").number >= 45)	WorldUtils.chooseAdvance(d);
			
		}
		
		private static function loadTower_01():void
		{
			audio.playMusic("tower", 3);
			audio.stopAll(["tower"]);
			
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("tower.bg.png"), 500, 200);
			
			WorldUtils.addDecal(Library.IMG("tower.decals.stainedGlass.png"), 546, 210);
			WorldUtils.addDecal(Library.IMG("tower.decals.chandelier.png"), 365, 103, null, null , [0, 1, 2, 3], 46, 101);
			WorldUtils.addDecal(Library.IMG("tower.decals.chandelier.png"), 636, 103, null, null , [0, 1, 2, 3], 46, 101);
			
			WorldUtils.addDecal(Library.IMG("tower.decals.torch.png"), 849, 72, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			WorldUtils.addDecal(Library.IMG("tower.decals.torch.png"), 849, 247, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			WorldUtils.addDecal(Library.IMG("tower.decals.torch.png"), 340, 271, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			WorldUtils.addDecal(Library.IMG("tower.decals.torch.png"), 687, 342, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			WorldUtils.addDecal(Library.IMG("tower.decals.torch.png"), 150, 20, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			
			WorldUtils.addLadder(50, 42, 245);
			WorldUtils.addLadder(790, 93, 178);
			WorldUtils.addLadder(976, 336, 64);
			
			WorldUtils.addEnemy(400, 350, ElfMage);
			WorldUtils.addEnemy(700, 350, Archer);
			WorldUtils.addEnemy(545, 150, Archer);
			WorldUtils.addEnemy(190, 20, Archer);
			WorldUtils.addEnemy(400, 20, ElfMage);
			WorldUtils.addEnemy(600, 20, Archer);
			WorldUtils.addEnemy(800, 20, ElfMage);
			WorldUtils.addEnemy(900, 70, Guard);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(50, 375, Game.playerClass);
			
			if (Game.man.type == Player.FIGHTER)
			{
				WorldUtils.addWall(263, 294, false, Library.IMG("misc.clipPlatform.png"), 448);
				WorldUtils.addDecal(Library.IMG("tower.layouts.layout2.png"), 500, 200);
			}
			else
			{
				WorldUtils.addWall(243, 294, false, Library.IMG("misc.clipPlatform.png"), 488);
				WorldUtils.addDecal(Library.IMG("tower.layouts.layout1.png"), 500, 200);
			}
			
			if (Game.man.type == Player.ROGUE)
			{
				WorldUtils.addEnemy(1, 270, Guard);
				WorldUtils.addEnemy(25, 270, Guard);
				WorldUtils.addEnemy(50, 270, Guard);
				WorldUtils.addEnemy(75, 270, Guard);
				WorldUtils.addEnemy(100, 270, ElfMage);
				WorldUtils.addEnemy(125, 270, ElfMage);
				WorldUtils.addEnemy(150, 270, ElfMage);
				WorldUtils.addEnemy(175, 270, ElfMage);
				WorldUtils.addEnemy(200, 270, Archer);
				WorldUtils.addEnemy(225, 270, Archer);
				WorldUtils.addEnemy(250, 270, Archer);
				WorldUtils.addEnemy(275, 270, Archer);
				
				WorldUtils.addDecal(Library.IMG("misc.keyS.png"), 327, 186, trainCaltrop, function (d:Decal):* { d.alpha = 0; } );
			}
			else if	(Game.man.type == Player.FIGHTER)
			{
				WorldUtils.addEnemy(50, 270, PansyArcher).heading = true;
				WorldUtils.addEnemy(80, 270, PansyArcher).heading = true;
				WorldUtils.addEnemy(110, 270, PansyArcher).heading = true;
				WorldUtils.addEnemy(140, 270, PansyArcher).heading = true;
				WorldUtils.addEnemy(170, 270, PansyArcher).heading = true;
				WorldUtils.addEnemy(200, 270, PansyArcher).heading = true;
				WorldUtils.addDecal(Library.IMG("misc.keyS.png"), 327, 186, trainShield, function (d:Decal):* { d.alpha = 0; } );
			}
			
			
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
		
		private static function trainCaltrop(d:Decal):void
		{
			if (d.hitTestObject(Game.man.collisionHull))
			{
				if (Game.man.knowsS)
				{
					if (Game.man.activeCaltrop)
					{
						d.x = Game.man.activeCaltrop.x;
						d.y = Game.man.activeCaltrop.y - 12;
						
						if (Game.man.hasCaltrop)	d.alpha -= 0.05;
					}
				}
				if (!Game.man.knowsS)	Game.man.knowsS = true;
				
				if (Game.man.hasCaltrop || Game.man.knowsS)
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
		
		private static function trainShield(d:Decal):void
		{
			if (d.hitTestObject(Game.man.collisionHull))
			{
				if (!Game.man.knowsS)	Game.man.knowsS = true;
				
				if (Game.man.knowsS)
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
		
		private static function openGate(d:Decal):void
		{
			if (d.hitTestObject(Game.man.collisionHull))
			{
				if (!Game.man.knowsS)	Game.man.knowsS = true;
				
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
			audio.playMusic("tower", 3);
			
			WorldUtils.makeBounds();
			
			hasKey = true;
			
			Game.stage.addChild(Library.IMG("tower.bg.png"));
			
			WorldUtils.addDecal(Library.IMG("tower.decals.chandelier.png"), 923, 165.5, null, null , [0, 1, 2, 3], 46, 101);
			WorldUtils.addDecal(Library.IMG("tower.decals.chandelier.png"), 73, 165.5, null, null, [0, 1, 2, 3], 46, 101);
			
			WorldUtils.addDecal(Library.IMG("tower.decals.shield.png"), 180, 80);
			WorldUtils.addDecal(Library.IMG("tower.decals.shield.png"), 280, 80);
			WorldUtils.addDecal(Library.IMG("tower.decals.torch.png"), 230, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			
			WorldUtils.addDecal(Library.IMG("tower.decals.shield.png"), 650, 80);
			WorldUtils.addDecal(Library.IMG("tower.decals.shield.png"), 750, 80);
			WorldUtils.addDecal(Library.IMG("tower.decals.torch.png"), 700, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			
			WorldUtils.addDecal(Library.IMG("tower.decals.door.png"), 855, 363.5);
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 855, 363.5, WorldUtils.chooseAdvance, function (d:Decal):* { d.alpha = 0;	} );
			WorldUtils.addDecal(Library.IMG("misc.padlock.png"), 855, 363.5, WorldUtils.doorLocked, function (d:Decal):* { d.alpha = 0;	} );
			
			WorldUtils.addLadder(30, 0, 110);
			WorldUtils.addLadder(112, 100, 260);
			WorldUtils.addLadder(855, 200, 115);
			WorldUtils.addLadder(940, 300, 200);
			
			WorldUtils.addEnemy(724, 75, ElfMage);
			WorldUtils.addEnemy(924, 75, ElfMage);
			WorldUtils.addEnemy(600, 336, ElfMage);
			WorldUtils.addEnemy(495, 130, ElfMage);
			WorldUtils.addEnemy(170, 180, ElfMage);
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
			
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(20, 15, Game.playerClass);
			
			nextLevel = "tower_03";
		}
		
		private static function loadTower_03():void
		{
			audio.playMusic("tower", 3);
			
			WorldUtils.makeBounds();
			
			Game.stage.addChild(Library.IMG("tower.bg.png"));
			WorldUtils.addDecal(Library.IMG("tower.decals.shield.png"), 280, 80);
			WorldUtils.addDecal(Library.IMG("tower.decals.torch.png"), 230, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			WorldUtils.addDecal(Library.IMG("dungeon.decals.cornerWeb.png"), 16, 376, null, function (d:Decal):*	{	d.rotationX = 180;	});
			
			WorldUtils.addDecal(Library.IMG("tower.decals.door.png"), 850, 55);
			
			WorldUtils.addWall(850, 98, false, Library.IMG("tower.platform.png"), 198);
			WorldUtils.addWall(628, 166, false, Library.IMG("tower.platform.png"), 373);
			WorldUtils.addWall(871, 216, false, Library.IMG("tower.platform.png"), 85);
			WorldUtils.addWall(871, 277, false, Library.IMG("tower.platform.png"), 85);
			WorldUtils.addWall(871, 338, false, Library.IMG("tower.platform.png"), 85);
			WorldUtils.addWall(630, 277, false, Library.IMG("tower.platform.png"), 196);
			WorldUtils.addWall(140, 359, false, Library.IMG("tower.platform.png"), 70);
			WorldUtils.addWall(239, 331, false, Library.IMG("tower.platform.png"), 61);
			WorldUtils.addWall(135, 310, false, Library.IMG("tower.platform.png"), 55);
			WorldUtils.addWall(123, 267, false, Library.IMG("tower.platform.png"), 39);
			WorldUtils.addWall(239, 248, false, Library.IMG("tower.platform.png"), 120);
			WorldUtils.addWall(375, 167, false, Library.IMG("tower.platform.png"), 85);
			WorldUtils.addWall(407, 118, false, Library.IMG("tower.platform.png"), 85);
			WorldUtils.addWall(268, 96, false, Library.IMG("tower.platform.png"), 85);
			WorldUtils.addWall(140, 72, false, Library.IMG("tower.platform.png"), 72);
			WorldUtils.addWall(507, 139, false, Library.IMG("tower.platform.png"), 39);
			
			WorldUtils.addWall(530, 163, true, Library.IMG("tower.platform.png"), 327);
			WorldUtils.addWall(104, 221, true, Library.IMG("tower.platform.png"), 331);
			
			WorldUtils.addWall(549, 390, false, Library.IMG("tower.platform.png"), 901);
			WorldUtils.addWall(549, 400, false, Library.IMG("tower.platform.png"), 901);
			WorldUtils.addWall(172, 373, true, Library.IMG("misc.clipPlatform.png"), 20);
			WorldUtils.addWall(490, 152, true, Library.IMG("misc.clipPlatform.png"), 20);
			
			WorldUtils.addLadder(962, 93, 292);
			WorldUtils.addLadder(430, 162, 100);
			
			WorldUtils.addEnemy(600, 100, Guard);
			WorldUtils.addEnemy(700, 100, Guard);
			WorldUtils.addEnemy(869, 195, Archer);
			WorldUtils.addEnemy(869, 255, Archer);
			WorldUtils.addEnemy(869, 309, Archer);
			WorldUtils.addEnemy(612, 261, ElfMage);
			WorldUtils.addEnemy(530, 366, Guard);
			WorldUtils.addEnemy(730, 366, Guard);
			WorldUtils.addEnemy(236, 223, Guard);
			WorldUtils.addEnemy(390, 145, Archer);
			WorldUtils.addEnemy(266, 72, Guard);
			WorldUtils.addEnemy(138, 45, Guard);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(850, 55, Game.playerClass);
			
			WorldUtils.addTrigger(48, 390, WorldUtils.advance, 98, 20);
			
			nextLevel = "dungeon_01";
		}
		
		private static function loadDungeon_01():void 
		{
			audio.playMusic("dungeon", 3);
			audio.stopAll(["dungeon"]);
			
			WorldUtils.makeBounds();
			
			Game.stage.addChild(Library.IMG("dungeon.bg.png"));
			
			WorldUtils.addLadder(970, 145, 260);
			WorldUtils.addLadder(150, 190, 260);
			
			WorldUtils.addEnemy(150, 130, Zombie);
			WorldUtils.addEnemy(150, 130, Zombie);
			WorldUtils.addEnemy(150, 130, Zombie);
			WorldUtils.addEnemy(150, 130, Spider);
			
			WorldUtils.addEnemy(320, 130, Zombie);
			WorldUtils.addEnemy(500, 130, Zombie);
			WorldUtils.addEnemy(680, 130, Zombie);
			WorldUtils.addEnemy(850, 130, Zombie);
			
			WorldUtils.addEnemy(700, 250, Spider);
			
			WorldUtils.addEnemy(300, 320, Spider);
			WorldUtils.addEnemy(400, 320, Spider);
			WorldUtils.addEnemy(500, 320, Spider);
			
			WorldUtils.addEnemy(200, 380, SkeletonMage);
			WorldUtils.addEnemy(300, 380, Skeleton);
			WorldUtils.addEnemy(400, 380, SkeletonMage);
			WorldUtils.addEnemy(500, 380, Zombie);
			WorldUtils.addEnemy(600, 380, Zombie);
			WorldUtils.addEnemy(800, 380, Spider);
			
			WorldUtils.addWall( 565.5, 325, false, Library.IMG("dungeon.platform.png"), 742);
			
			WorldUtils.addWall( 103, 50, true, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 195, 240, true, Library.IMG("dungeon.platform.png"), 180);
			WorldUtils.addWall( 100, 150, false, Library.IMG("dungeon.platform.png"), 200);
			
			WorldUtils.addWall( 350, 150, false, Library.IMG("dungeon.platform.png"), 60);
			WorldUtils.addWall( 525, 150, false, Library.IMG("dungeon.platform.png"), 60);
			WorldUtils.addWall( 700, 150, false, Library.IMG("dungeon.platform.png"), 60);
			
			WorldUtils.addWall( 615, 272, false, Library.IMG("dungeon.platform.png"), 630);
			WorldUtils.addWall( 850, 212, true, Library.IMG("dungeon.platform.png"), 130);
			WorldUtils.addWall( 932, 212, true, Library.IMG("dungeon.platform.png"), 130);
			WorldUtils.addWall( 891, 150, false, Library.IMG("dungeon.platform.png"), 92);
			
			WorldUtils.addWall( 103, 310, true, Library.IMG("dungeon.platform.png"), 200);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(50, -10, Game.playerClass);
			
			WorldUtils.addTrigger(44.5, 395, WorldUtils.advance, 99, 15);
			
			nextLevel = "dungeon_02";
		}
		
		private static function loadDungeon_02():void 
		{
			audio.playMusic("dungeon", 3);
			audio.stopAll(["dungeon"]);
			
			WorldUtils.makeBounds();
			
			Game.stage.addChild(Library.IMG("dungeon.bg.png"));
			
			WorldUtils.addDecal(Library.IMG("dungeon.decals.torch.png"), 230, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			WorldUtils.addDecal(Library.IMG("dungeon.decals.torch.png"), 700, 80, null, null, [0, 1, 2, 3, 4, 5], 40, 40);
			
			WorldUtils.addWall( 150, 190, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 125, 155, false, Library.IMG("dungeon.platform.png"), 50);
			WorldUtils.addWall( 113, 120, false, Library.IMG("dungeon.platform.png"), 25);
			
			WorldUtils.addWall( 203, 325, false, Library.IMG("dungeon.platform.png"), 200);
			WorldUtils.addWall( 103, 165, true, Library.IMG("dungeon.platform.png"), 330);
			
			WorldUtils.addWall( 190, 395, false, Library.IMG("dungeon.platform.png"), 500);
			WorldUtils.addWall( 810, 395, false, Library.IMG("dungeon.platform.png"), 500);
			
			WorldUtils.addWall( 390, 355, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 250, 100, false, Library.IMG("dungeon.platform.png"), 100);
			
			WorldUtils.addWall( 300, 285, false, Library.IMG("dungeon.platform.png"), 75);
			WorldUtils.addWall( 300, 220, false, Library.IMG("dungeon.platform.png"), 75);
			
			WorldUtils.addWall( 416, 250, false, Library.IMG("dungeon.platform.png"), 42);
			WorldUtils.addWall( 400, 75, false, Library.IMG("dungeon.platform.png"), 75);
			
			WorldUtils.addWall( 611, 95, false, Library.IMG("dungeon.platform.png"), 95);
			WorldUtils.addWall( 749, 95, false, Library.IMG("dungeon.platform.png"), 95);
			WorldUtils.addWall( 610, 145, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 750, 145, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 610, 185, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 750, 185, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 610, 225, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 750, 225, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 610, 265, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 750, 265, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 610, 305, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 750, 305, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 610, 345, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 750, 345, false, Library.IMG("dungeon.platform.png"), 100);
			
			WorldUtils.addWall( 440, 225, true, Library.IMG("dungeon.platform.png"), 350);
			WorldUtils.addWall( 560, 250, true, Library.IMG("dungeon.platform.png"), 300);
			
			WorldUtils.addWall( 850, 80, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 950, 150, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 850, 220, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 950, 290, false, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 850, 345, false, Library.IMG("dungeon.platform.png"), 100);
			
			WorldUtils.addWall( 800, 200, true, Library.IMG("dungeon.platform.png"), 300);
			WorldUtils.addWall( 620, 45, false, Library.IMG("dungeon.platform.png"), 350);
			
			WorldUtils.addLadder(680, 100, 290);
			
			WorldUtils.addEnemy(400, 320, Skeleton);
			WorldUtils.addEnemy(200, 270, Zombie);
			WorldUtils.addEnemy(300, 200, Zombie);
			WorldUtils.addEnemy(280, 50, Skeleton);
			WorldUtils.addEnemy(370, 30, SkeletonMage);
			WorldUtils.addEnemy(500, 10, Zombie);
			WorldUtils.addEnemy(550, 10, Zombie);
			WorldUtils.addEnemy(600, 10, Zombie);
			WorldUtils.addEnemy(850, 30, Skeleton);
			WorldUtils.addEnemy(950, 90, Skeleton);
			WorldUtils.addEnemy(850, 160, Skeleton);
			WorldUtils.addEnemy(950, 240, Skeleton);
			WorldUtils.addEnemy(850, 300, Skeleton);
			
			WorldUtils.addEnemy(600, 100, Spider);
			WorldUtils.addEnemy(750, 100, Spider);
			WorldUtils.addEnemy(600, 200, Spider);
			WorldUtils.addEnemy(750, 200, Spider);
			WorldUtils.addEnemy(600, 300, Spider);
			WorldUtils.addEnemy(750, 300, Spider);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(50, 0, Game.playerClass);
			
			WorldUtils.addTrigger( 500, 415, WorldUtils.advance, 100);
			
			nextLevel = "dungeon_03";
		}
		
		private static function loadDungeon_03():void 
		{
			audio.playMusic("dungeon", 3);
			audio.stopAll(["dungeon"]);
			
			WorldUtils.makeBounds();
			
			Game.stage.addChild(Library.IMG("dungeon.bg.png"));
			
			WorldUtils.addWall( 449, 75, true, Library.IMG("dungeon.platform.png"), 150);
			WorldUtils.addWall( 804, 155, true, Library.IMG("dungeon.platform.png"), 125);
			WorldUtils.addWall( 747, 95, false, Library.IMG("dungeon.platform.png"), 400);
			WorldUtils.addWall( 551, 50, true, Library.IMG("dungeon.platform.png"), 100);
			WorldUtils.addWall( 594, 145, false, Library.IMG("dungeon.platform.png"), 300);
			
			WorldUtils.addWall( 264, 265, true, Library.IMG("dungeon.platform.png"), 95);
			WorldUtils.addWall( 219, 346, false, Library.IMG("dungeon.platform.png"), 295);
			WorldUtils.addWall( 75, 284, true, Library.IMG("dungeon.platform.png"), 134);
			
			WorldUtils.addWall( 604, 215, false, Library.IMG("dungeon.platform.png"), 690);
			WorldUtils.addWall( 406, 145, true, Library.IMG("dungeon.platform.png"), 150);
			WorldUtils.addWall( 356, 78, true, Library.IMG("dungeon.platform.png"), 165);
			
			WorldUtils.addWall( 659, 306, false, Library.IMG("dungeon.platform.png"), 580);
			WorldUtils.addWall( 364, 331, true, Library.IMG("dungeon.platform.png"), 40);
			WorldUtils.addWall( 55, 215, false, Library.IMG("dungeon.platform.png"), 50);
			
			WorldUtils.addLadder(427, 65, 145);
			WorldUtils.addLadder(15, 200, 200);
			WorldUtils.addLadder(975, 75, 325);
			
			WorldUtils.addDecal(Library.IMG("dungeon.decals.crevice.png"), 650, 60, null, null, [0, 1, 2, 3], 149, 44, 2);
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 650, 60, WorldUtils.chooseAdvance, function (d:Decal):* { d.alpha = 0;} );
			
			WorldUtils.addEnemy(675, 100, Zombie);
			WorldUtils.addEnemy(680, 100, Zombie);
			
			WorldUtils.addEnemy(500, 150, SkeletonMage);
			WorldUtils.addEnemy(600, 150, SkeletonMage);
			WorldUtils.addEnemy(650, 150, SkeletonMage);
			WorldUtils.addEnemy(700, 150, SkeletonMage);
			
			WorldUtils.addEnemy(300, 150, Skeleton);
			WorldUtils.addEnemy(320, 150, Skeleton);
			
			WorldUtils.addEnemy(200, 300, Spider);
			WorldUtils.addEnemy(250, 300, Spider);
			
			WorldUtils.addEnemy(400, 280, Spider);
			WorldUtils.addEnemy(500, 280, Spider);
			WorldUtils.addEnemy(600, 280, SkeletonMage);
			WorldUtils.addEnemy(700, 280, SkeletonMage);
			WorldUtils.addEnemy(730, 280, SkeletonMage);
			WorldUtils.addEnemy(800, 280, SkeletonMage);
			
			WorldUtils.addEnemy(300, 360, Skeleton);
			WorldUtils.addEnemy(400, 360, Spider);
			WorldUtils.addEnemy(500, 360, SkeletonMage);
			WorldUtils.addEnemy(600, 360, Spider);
			WorldUtils.addEnemy(700, 360, Zombie);
			WorldUtils.addEnemy(800, 360, Spider);
			
			WorldUtils.addEnemy(830, 150, SkeletonMage);
			WorldUtils.addEnemy(850, 150, SkeletonMage);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(500, 0, Game.playerClass);
			
			nextLevel = "hellther_01";
		}
		
		private static function loadHellther_01():void
		{
			audio.playMusic("hellther", 3);
			audio.stopAll(["hellther"]);
			
			WorldUtils.makeBounds();
			
			var crevice:Point = new Point(80, 190);
			
			WorldUtils.addWall(419, 11, true, Library.IMG("forest.platform.png"), 22);
			WorldUtils.addWall(207, 27, false, Library.IMG("forest.platform.png"), 414);
			WorldUtils.addWall(613, 27, false, Library.IMG("forest.platform.png"), 301);
			WorldUtils.addWall(467, 39, true, Library.IMG("forest.platform.png"), 70);
			WorldUtils.addWall(758, 11, true, Library.IMG("forest.platform.png"), 22);
			
			WorldUtils.addWall(907, 27, false, Library.IMG("forest.platform.png"), 185);
			WorldUtils.addWall(995, 10, true, Library.IMG("forest.platform.png"), 22);
			WorldUtils.addWall(819, 11, true, Library.IMG("forest.platform.png"), 22);
			
			WorldUtils.addWall(260, 80, false, Library.IMG("forest.platform.png"), 400);
			WorldUtils.addWall(275, 120, false, Library.IMG("forest.platform.png"), 550);
			
			WorldUtils.addWall(110, 355, false, Library.IMG("forest.platform.png"), 30);
			WorldUtils.addWall(380, 350, false, Library.IMG("forest.platform.png"), 100);
			
			WorldUtils.addWall(600, 300, false, Library.IMG("forest.platform.png"), 50);
			WorldUtils.addWall(631, 288, true, Library.IMG("forest.platform.png"), 30);
			WorldUtils.addWall(685, 270, false, Library.IMG("forest.platform.png"), 100);
			
			WorldUtils.addWall(950, 300, false, Library.IMG("forest.platform.png"), 120);
			WorldUtils.addWall(915, 150, false, Library.IMG("forest.platform.png"), 120);
			WorldUtils.addWall(850, 135, true, Library.IMG("forest.platform.png"), 30);
			WorldUtils.addWall(700, 115, false, Library.IMG("forest.platform.png"), 290);
			WorldUtils.addWall(550, 135, true, Library.IMG("forest.platform.png"), 30);
			
			WorldUtils.addDecal(Library.IMG("hellther.bg.png"), 500, 200);
			WorldUtils.addDecal(Library.IMG("hellther.crevice.png"), crevice.x, crevice.y);
			WorldUtils.addDecal(Library.IMG("hellther.layout5.png"), 500, 200);
			
			WorldUtils.addLadder(443, -10, 85, "hellther.ladder.png");
			WorldUtils.addLadder(crevice.x, 350, 50, "hellther.ladder.png");
			WorldUtils.addLadder(250, 300, 50, "hellther.ladder.png");
			WorldUtils.addLadder(500, 255, 50, "hellther.ladder.png");
			WorldUtils.addLadder(988, 145, 150, "hellther.ladder.png");
			
			WorldUtils.addEnemy(660, 240, Demon);
			WorldUtils.addEnemy(670, 240, Demon);
			WorldUtils.addEnemy(680, 240, Demon);
			WorldUtils.addEnemy(690, 240, Demon);
			
			WorldUtils.addEnemy(870, 120, Demon);
			WorldUtils.addEnemy(880, 120, Demon);
			WorldUtils.addEnemy(890, 120, Demon);
			WorldUtils.addEnemy(900, 120, Demon);
			
			WorldUtils.addEnemy(400, 70, Doppleganger);
			WorldUtils.addEnemy(870, 120, Doppleganger);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(crevice.x, crevice.y, Game.playerClass);
			
			WorldUtils.addDecal(Library.IMG("hellther.lavaTrap2.png"), 500, 391);
			
			WorldUtils.addTrigger( 443, -15, WorldUtils.advance);
			WorldUtils.addTrigger( 500, 391, WorldUtils.hurt, 1000, 19);
			
			nextLevel = "hellther_02";
		}
		
		private static function loadHellther_02():void
		{
			audio.playMusic("hellther", 3);
			
			WorldUtils.makeBounds();
			
			// Top row 
			WorldUtils.addWall(228, 24, false, Library.IMG("forest.platform.png"), 446);
			WorldUtils.addWall(505, 10, false, Library.IMG("forest.platform.png"), 96);
			WorldUtils.addWall(745, 10, false, Library.IMG("forest.platform.png"), 294);
			
			// Far right edge
			WorldUtils.addWall(986, 48, true, Library.IMG("forest.platform.png"), 53);
			WorldUtils.addWall(999, 152, true, Library.IMG("forest.platform.png"), 126);
			
			// Far left edge
			WorldUtils.addWall(0, 120, true, Library.IMG("forest.platform.png"), 181);
			WorldUtils.addWall(-1, 302, true, Library.IMG("forest.platform.png"), 81);
			
			//Second row
			WorldUtils.addWall(810, 80, false, Library.IMG("forest.platform.png"), 340);
			WorldUtils.addWall(574, 54, false, Library.IMG("forest.platform.png"), 161);
			WorldUtils.addWall(339, 79, false, Library.IMG("forest.platform.png"), 355);
			
			// Hole
			WorldUtils.addWall(406, 132, false, Library.IMG("forest.platform.png"), 270);
			WorldUtils.addWall(747, 131, false, Library.IMG("forest.platform.png"), 270);
			
			// Pit
			WorldUtils.addWall(611, 313, true, Library.IMG("forest.platform.png"), 173);
			WorldUtils.addWall(530, 318, true, Library.IMG("forest.platform.png"), 183);
			
			// Entrance ladder
			WorldUtils.addWall(418, 384, true, Library.IMG("forest.platform.png"), 52);
			WorldUtils.addWall(477, 350, true, Library.IMG("forest.platform.png"), 93);
			
			// Top left smalls (column L to R)
			WorldUtils.addWall(20, 125, false, Library.IMG("forest.platform.png"), 31);
			WorldUtils.addWall(16, 179, false, Library.IMG("forest.platform.png"), 22);
			WorldUtils.addWall(126, 111, false, Library.IMG("forest.platform.png"), 45);
			WorldUtils.addWall(105, 151, false, Library.IMG("forest.platform.png"), 86);
			WorldUtils.addWall(142, 163, false, Library.IMG("forest.platform.png"), 158);
			WorldUtils.addWall(155, 112, true, Library.IMG("forest.platform.png"), 55);
			WorldUtils.addWall(187, 126, false, Library.IMG("forest.platform.png"), 46);
			WorldUtils.addWall(217, 143, true, Library.IMG("forest.platform.png"), 39);
			
			// Bottom right smalls (L to R)
			WorldUtils.addWall(20, 347, false, Library.IMG("forest.platform.png"), 38);
			WorldUtils.addWall(50, 357, false, Library.IMG("forest.platform.png"), 25);
			WorldUtils.addWall(75, 367, false, Library.IMG("forest.platform.png"), 25);
			WorldUtils.addWall(149, 320, false, Library.IMG("forest.platform.png"), 105);
			WorldUtils.addWall(162, 309, false, Library.IMG("forest.platform.png"), 62);
			
			// Middle smalls
			WorldUtils.addWall(471, 280, false, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(487, 263, false, Library.IMG("forest.platform.png"), 14);
			WorldUtils.addWall(499, 252, true, Library.IMG("forest.platform.png"), 50);
			WorldUtils.addWall(515, 223, false, Library.IMG("forest.platform.png"), 15);
			
			// Right smalls (L to R)
			WorldUtils.addWall(887, 155, true, Library.IMG("forest.platform.png"), 51);
			WorldUtils.addWall(905, 152, false, Library.IMG("forest.platform.png"), 25);
			WorldUtils.addWall(974, 186, false, Library.IMG("forest.platform.png"), 40);
			
			// Other horizontals (top to bottom)
			WorldUtils.addWall(140, 216, false, Library.IMG("forest.platform.png"), 276);
			WorldUtils.addWall(801, 223, false, Library.IMG("forest.platform.png"), 390);
			
			WorldUtils.addWall(372, 233, false, Library.IMG("forest.platform.png"), 161);
			WorldUtils.addWall(436, 245, true, Library.IMG("forest.platform.png"), 10);
			WorldUtils.addWall(220, 255, false, Library.IMG("forest.platform.png"), 427);
			
			WorldUtils.addWall(336, 296, false, Library.IMG("forest.platform.png"), 270);
			WorldUtils.addWall(365, 354, false, Library.IMG("forest.platform.png"), 95);
			WorldUtils.addWall(205, 377, false, Library.IMG("forest.platform.png"), 233);
			
			// Other verticals (L to R)
			WorldUtils.addWall(276, 174, true, Library.IMG("forest.platform.png"), 75);
			WorldUtils.addWall(288, 185, true, Library.IMG("forest.platform.png"), 86);
			
			WorldUtils.addWall(495, 68, true, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(515, 68, true, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(651, 68, true, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(641, 68, true, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(315, 370, true, Library.IMG("forest.platform.png"), 25);
			
			WorldUtils.addDecal(Library.IMG("hellther.bg.png"), 500, 200);
			
			WorldUtils.addEnemy(100, 150, Demon);
			WorldUtils.addEnemy(100, 150, Demon);
			WorldUtils.addEnemy(100, 150, Demon);
			WorldUtils.addEnemy(100, 150, Demon);
			WorldUtils.addEnemy(100, 180, Serpent);
			
			WorldUtils.addEnemy(300, 185, Serpent);
			WorldUtils.addEnemy(760, 200, Demon);
			WorldUtils.addEnemy(730, 200, Demon);
			WorldUtils.addEnemy(700, 200, Demon);
			WorldUtils.addEnemy(730, 200, Demon);
			WorldUtils.addEnemy(730, 200, Demon);
			
			WorldUtils.addEnemy(180, 100, Doppleganger);
			WorldUtils.addEnemy(950, 20, Doppleganger);
			
			WorldUtils.addLadder(447, 345, 55, "hellther.ladder.png");
			WorldUtils.addLadder(576, 0, 49, "hellther.ladder.png");
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(435, 300, Game.playerClass);
			
			WorldUtils.addDecal(Library.IMG("hellther.lavaTrap.png"), 571, 391);
			
			WorldUtils.addDecal(Library.IMG("hellther.layout1.png"), 500, 200);
			
			WorldUtils.addTrigger( 550, -15, WorldUtils.advance);
			WorldUtils.addTrigger( 570, 385, WorldUtils.hurt);
			
			nextLevel = "hellther_03";
		}
		
		private static function loadHellther_03():void
		{
			audio.playMusic("hellther", 3);
			audio.stopAll(["hellther"]);
			
			WorldUtils.makeBounds();
			
			
			// Left
			WorldUtils.addWall(471, 390, true, Library.IMG("forest.platform.png"), 22);
			WorldUtils.addWall(389, 375, false, Library.IMG("forest.platform.png"), 156);
			WorldUtils.addWall(274, 367, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(203, 358, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(132, 350, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(61, 341, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(12, 331, false, Library.IMG("forest.platform.png"), 26);
			WorldUtils.addWall(56, 290, false, Library.IMG("forest.platform.png"), 36);
			WorldUtils.addWall(120, 270, false, Library.IMG("forest.platform.png"), 36);
			WorldUtils.addWall(33, 230, false, Library.IMG("forest.platform.png"), 67);
			WorldUtils.addWall(13, 187, false, Library.IMG("forest.platform.png"), 28);
			WorldUtils.addWall(104, 158, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(35, 44, false, Library.IMG("forest.platform.png"), 71);
			WorldUtils.addWall(35, 63, false, Library.IMG("forest.platform.png"), 71);
			
			// Right
			WorldUtils.addWall(529, 390, true, Library.IMG("forest.platform.png"), 22);
			WorldUtils.addWall(611, 375, false, Library.IMG("forest.platform.png"), 156);
			WorldUtils.addWall(726, 367, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(797, 358, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(868, 350, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(939, 341, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(988, 331, false, Library.IMG("forest.platform.png"), 26);
			WorldUtils.addWall(934, 290, false, Library.IMG("forest.platform.png"), 36);
			WorldUtils.addWall(880, 270, false, Library.IMG("forest.platform.png"), 36);
			WorldUtils.addWall(967, 230, false, Library.IMG("forest.platform.png"), 67);
			WorldUtils.addWall(987, 187, false, Library.IMG("forest.platform.png"), 28);
			WorldUtils.addWall(906, 158, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(965, 44, false, Library.IMG("forest.platform.png"), 71);
			WorldUtils.addWall(965, 63, false, Library.IMG("forest.platform.png"), 71);
			
			// Mid Bottom Chunk
			WorldUtils.addWall(500, 258, false, Library.IMG("forest.platform.png"), 672);
			WorldUtils.addWall(197, 238, false, Library.IMG("forest.platform.png"), 67);
			WorldUtils.addWall(266, 234, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(336, 229, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(408, 223, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(499, 222, false, Library.IMG("forest.platform.png"), 112);
			WorldUtils.addWall(592, 223, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(663, 229, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(734, 234, false, Library.IMG("forest.platform.png"), 72);
			WorldUtils.addWall(802, 238, false, Library.IMG("forest.platform.png"), 67);
			WorldUtils.addWall(835, 248, false, Library.IMG("forest.platform.png"), 10);
			WorldUtils.addWall(164, 248, false, Library.IMG("forest.platform.png"), 10);
			
			// Mid Top Chunk
			WorldUtils.addWall(206, 193, false, Library.IMG("forest.platform.png"), 48);
			WorldUtils.addWall(794, 193, false, Library.IMG("forest.platform.png"), 48);
			WorldUtils.addWall(266, 188, false, Library.IMG("forest.platform.png"), 70);
			WorldUtils.addWall(734, 188, false, Library.IMG("forest.platform.png"), 70);
			WorldUtils.addWall(500, 175, false, Library.IMG("forest.platform.png"), 636);
			WorldUtils.addWall(500, 147, false, Library.IMG("forest.platform.png"), 528);
			WorldUtils.addWall(236, 162, true, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(764, 162, true, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(500, 119, false, Library.IMG("forest.platform.png"), 386);
			WorldUtils.addWall(307, 134, true, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(696, 134, true, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(500, 90, false, Library.IMG("forest.platform.png"), 122);
			WorldUtils.addWall(438, 105, true, Library.IMG("forest.platform.png"), 20);
			WorldUtils.addWall(560, 105, true, Library.IMG("forest.platform.png"), 20);
			
			WorldUtils.addDecal(Library.IMG("hellther.bg.png"), 500, 200);
			
			const portal:Point = new Point(500, 56);
			WorldUtils.addDecal(Library.IMG("hellther.portalFrame.png"), portal.x, portal.y);
			WorldUtils.addDecal(Library.IMG("hellther.portalSparks.png"), portal.x, portal.y, null, null, [0, 1, 0, 2], 40, 40, 3, true );
			WorldUtils.addDecal(Library.IMG("hellther.portal.png"), portal.x, portal.y, function (d:Decal):*	{	d.rotation += 5; d.alpha = Math.abs(d.rotation) / 180;	} );
			
			WorldUtils.addDecal(Library.IMG("misc.upArrow.png"), 500, 56, portalAdvance, function (d:Decal):* { d.alpha = 0;	} );
			
			WorldUtils.addDecal(Library.IMG("hellther.layout3.png"), 500, 200);
			
			WorldUtils.addLadder(500, 370, 30, "hellther.ladder.png");
			
			WorldUtils.addEnemy(28, 19, Doppleganger);
			WorldUtils.addEnemy(968, 19, Doppleganger);
			
			WorldUtils.addEnemy(400, 50, Doppleganger);
			WorldUtils.addEnemy(600, 50, Doppleganger);
			
			WorldUtils.addEnemy(990, 330, Doppleganger);
			WorldUtils.addEnemy(10, 330, Doppleganger);
			
			Game.stage.addChild(new HUD);
			
			WorldUtils.addMan(500, 350, Game.playerClass);
			
			WorldUtils.addTrigger( 443, -15, WorldUtils.advance);
			
			nextLevel = "balcony_01";
		}
		
		private static function portalAdvance(d:Decal):void
		{
			var adv:Point;
			
			switch(Game.man.type)
			{
				case Player.FIGHTER:
				case Player.MAGE:
					adv = (Game.man.x < 500) ? new Point(525, 65) : new Point(475, 65);
					break;
				case Player.ROGUE:
					adv = (Game.man.x < 500) ? new Point(510, 65) : new Point(490, 65);
					break;
			}
			
			if (Game.man.hitTestPoint(adv.x, adv.y))
			{
				if (d.alpha <= 1 && !Game.man.isDestroyed) d.alpha += 0.05;
					
				if (Input.isKeyDown(Input.UP) && !Input.isKeyDown(Input.RIGHT) && !Input.isKeyDown(Input.LEFT))
				{
					WorldUtils.addTrigger( Game.man.x, Game.man.y, WorldUtils.advance);
				}
			}
			else
			{
				if (d.alpha >= 0) d.alpha -= 0.05;
			}
		}
		
		private static function loadBalcony_01():void
		{
			audio.playMusic("boss", 5);
			audio.stopAll(["boss"]);
			
			WorldUtils.makeBounds();
			
			WorldUtils.addDecal(Library.IMG("balcony.bg.png"), 500, 200, function (d:Decal):*	{	if (Input.isKeyDown(Input.P) && Game.boss)	{	Game.boss.throwScythe();	}} );
			
			Game.stage.addChild(new HUD);
			
			Game.boss = WorldUtils.addEnemy(50, 50, Boss) as Boss;
			
			const portal:Point = new Point(970, 260);
			WorldUtils.addDecal(Library.IMG("hellther.portalFrame.png"), portal.x, portal.y);
			WorldUtils.addDecal(Library.IMG("hellther.portalSparks.png"), portal.x, portal.y, null, null, [0, 1, 0, 2], 40, 40, 3, true );
			WorldUtils.addDecal(Library.IMG("hellther.portal.png"), portal.x, portal.y, function (d:Decal):*	{	d.rotation += 5; d.alpha = Math.abs(d.rotation) / 180;	} );
			
			WorldUtils.addMan(950, 265, Game.playerClass);
			
			// Visible
			WorldUtils.addWall(760, 259, false, Library.IMG("balcony.platform.png"), 79);
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
			
			nextLevel = "ending";
		}
		
		private static function loadEnd():void
		{
			audio.stopAll();
			
			WorldUtils.addDecal(Library.IMG("endingScreen.png"), 500, 250);
			WorldUtils.addDecal(Library.IMG("creditRoll.png"), 500, 1850, creditRoll);
			
			WorldUtils.makeBounds();
			
			nextLevel = "title";
		}
		
		private static function creditRoll(d:Decal):void	{	if (d.y > -872.5) d.y -= 1.25;	}
		
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
				if (!Game.man.knowsD)	Game.man.knowsD = true;
				
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
		
		private static function trainRanged(d:Decal):void
		{
			if (d.hitTestObject(Game.man.collisionHull))
			{
				if (!Game.man.knowsA)	Game.man.knowsA = true;
				
				if (!Input.isKeyDown(Input.A))
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
	}

}