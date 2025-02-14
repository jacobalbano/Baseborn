package ifrit 
{
	import com.jacobalbano.Animation;
	import com.jacobalbano.Iterator;
	import com.jacobalbano.Map;
	import com.jacobalbano.Input;
	import com.jacobalbano.MapIterator;
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import ifrit.*;
	
	/**
	 * @author Jake Albano
	 */
	public class WorldUtils 
	{		
		/**
		 * Add the player to the world
		 * @param	x		Position on x
		 * @param	y		Position on y
		 * @param	type	Player class
		 */
		public static function addMan(x:int, y:int, type:uint):void 
		{
			if (Game.man)
			{
				Game.man = null;
				World.Mobs.push(Game.stage.addChild(Game.man = new Player(x, y, type)) as Mob);
			}
			else
			{
				Game.man = null;
				World.Mobs.push(Game.stage.addChild(Game.man = new Player(x, y, type)) as Mob);
			}
			
			//World.transitioning = false;
		}
		
		public static function addTrigger(x:int, y:int, callback:Function, width:int = 50, height:int = 50):void
		{
			addDecal(new Bitmap(new BitmapData(width, height, true, 0)), x, y, callback);
		}
		
		
		/**
		 * Loads a level and unloads the previous one
		 * @param	name			The level to load
		 */
		public static function loadLevel(name:String):void
		{
			unloadLevel();
			
			(World.Worlds.retrive(name) || World.Worlds.retrive("beach_01"))();
			
			World.currentLevel = name;
			SaveState.level = name;
			
			World.loading = true;
			addDecal(new Bitmap(new BitmapData(1000, 500, true, 0xff000000)), 500, 250, fade );
			
		}
		
		/**
		 * Load the level identified by the current as next
		 */
		public static function next():void
		{
			loadLevel(World.nextLevel);
		}
		
		
		/**
		 * Callback for the fade decal
		 * @param	i			Standard reference parameter
		 */
		public static function fade(d:Decal):void
		{
			World.loading = false;
			if (d.alpha > 0) 	d.alpha -= 0.025;
			if (d.alpha <= 0)
			{
				Game.stage.removeChild(d);
			}
		}
		
		public static function slowFade(d:Decal):void
		{
			if (d.alpha > 0) 	d.alpha -= 0.015;
			if (d.alpha <= 0)	Game.stage.removeChild(d);
		}
		
		/**
		 * Check if player has reached the exit and load the next level
		 * @param	d			Standard reference parameter
		 */
		public static function advance(d:Decal):void 
		{
			if (Game.man.collisionHull.hitTestObject(d) && !Game.man.isDestroyed)	next();
		}
		
		public static function chooseAdvance(d:Decal):void 
		{
			
			if (Game.man.hitTestObject(d))
			{
				if (World.hasKey && Game.man.hasKey)
				{
					if (d.alpha <= 1) d.alpha += 0.05;
					
					if (Input.isKeyDown(Input.UP) && !Input.isKeyDown(Input.RIGHT) && !Input.isKeyDown(Input.LEFT))
					{
						WorldUtils.addTrigger( Game.man.x, Game.man.y, WorldUtils.advance);
						World.audio.playSFX("unlock");
					}
				}
				else if(!World.hasKey)
				{
					if (d.alpha <= 1) d.alpha += 0.05;
					
					if (Input.isKeyDown(Input.UP) && !Input.isKeyDown(Input.RIGHT) && !Input.isKeyDown(Input.LEFT))
					{
						WorldUtils.addTrigger( Game.man.x, Game.man.y, WorldUtils.advance);
					}
				}
				
			}
			else
			{
				if (d.alpha >= 0) d.alpha -= 0.05;
			}
		}
		
		public static function doorLocked(d:Decal):void 
		{
			if (Game.man.hitTestObject(d))
			{
				if (World.hasKey && !Game.man.hasKey)
				{
					if (d.alpha <= 1) d.alpha += 0.05;
				}
				
			}
			else
			{
				if (d.alpha >= 0) d.alpha -= 0.05;
			}
		}
		
		
		/**
		 * Add a platform to the world
		 * @param	x			Position on x
		 * @param	y			Position on y
		 * @param	vertical	Whether the platform should be rotated vertically
		 */
		public static function addWall(x:Number, y:Number, vertical:Boolean, bitmap:Bitmap, size:int = 200):void
		{
			World.Platforms.push(Game.stage.addChild(new Platform(x, y, vertical, bitmap, size) ) );
		}
		
		/**
		 * Add an enemy to the world
		 * @param	x			Position on x
		 * @param	y			Position on y
		 * @param	type		The class of enemy to add	
		 */
		public static function addEnemy(x:Number, y:Number, type:Class):Enemy
		{
			var m:Mob = new type(x, y);
			World.Mobs.push(Game.stage.addChild(m) as Mob);
			return m as Enemy;
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
			World.Ladders.push(Game.stage.addChild(new Ladder(x, y, height, Library.getImage(imageName).bitmapData)) as Ladder);
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
			addWall(-5, 100, true, Library.getImage("misc.clipPlatform.png"));
			addWall(-15, 100, true, Library.getImage("misc.clipPlatform.png"));
			addWall(-5, 300, true, Library.getImage("misc.clipPlatform.png"));
			addWall(-15, 300, true, Library.getImage("misc.clipPlatform.png"));
			addWall( -5, 500, true, Library.getImage("misc.clipPlatform.png"));
			addWall( -15, 500, true, Library.getImage("misc.clipPlatform.png"));
			
			addWall(100, 405, false, Library.getImage("misc.clipPlatform.png"));
			addWall(100, 415, false, Library.getImage("misc.clipPlatform.png"));
			addWall(300, 405, false, Library.getImage("misc.clipPlatform.png"));
			addWall(300, 415, false, Library.getImage("misc.clipPlatform.png"));
			addWall(500, 405, false, Library.getImage("misc.clipPlatform.png"));
			addWall(500, 415, false, Library.getImage("misc.clipPlatform.png"));
			addWall(700, 405, false, Library.getImage("misc.clipPlatform.png"));
			addWall(700, 415, false, Library.getImage("misc.clipPlatform.png"));
			addWall(900, 405, false, Library.getImage("misc.clipPlatform.png"));
			addWall(900, 415, false, Library.getImage("misc.clipPlatform.png"));
			
			addWall(1005, 100, true, Library.getImage("misc.clipPlatform.png"), 300);
			addWall(1015, 100, true, Library.getImage("misc.clipPlatform.png"), 300);
			addWall(1005, 300, true, Library.getImage("misc.clipPlatform.png"));
			addWall(1015, 300, true, Library.getImage("misc.clipPlatform.png"));
			addWall( 1005, 500, true, Library.getImage("misc.clipPlatform.png"));
			addWall( 1015, 500, true, Library.getImage("misc.clipPlatform.png"));
		}
		
		static public function followMouse(d:Decal):void 
		{
			d.x = Game.stage.mouseX;
			d.y = Game.stage.mouseY;
			
			trace("x:", Game.stage.mouseX, "y:", Game.stage.mouseY);
		}
		
		public static function hurt(d:Decal):void 
		{
			if (d.hitTestObject(Game.man.collisionHull))
			{
				HUD.damagePlayer(100, true);
			}
			else
			{
				for (var i:int = World.Mobs.length; i --> 0; )
				{
					if (d.hitTestObject(World.Mobs[i].collisionHull))
					{
						World.Mobs[i].destroy();
					}
				}
			}
		}
		
		/**
		 * If an enemy begins fleeing, they will remain at their current health while within this trigger.
		 * @param	d	Standard reference parameter
		 */
		public static function safe(d:Decal):void 
		{
			for (var i:int = World.Mobs.length; i --> 0; )
			{
				if (!World.Mobs[i].friendly)
				{
					if (d.hitTestObject(World.Mobs[i].collisionHull))
					{
						if (World.Mobs[i].hitpoints <= World.Mobs[i].maxHealth / 2)
							World.Mobs[i].hitpoints = World.Mobs[i].maxHealth / 2;
					}
				}
			}
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
			
			for (var itr:Iterator = new MapIterator(World.Variables); itr.value ; itr.next())
			{
				World.Variables.remove(itr.value.first);
			}
			
			World.hasKey = false;
		}
		
		
		
	}

}