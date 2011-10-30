package
{
	import com.jacobalbano.Input;
	
	import com.thaumaturgistgames.flakit.Engine;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Timer;
	import ifrit.*;
	
	
	
	
	[SWF(width = "1000", height = "400", backgroundColor = "0xFFFFFF")]
	public class Game extends Engine 
	{
		
		public const MAX_X:uint = stage.stageWidth;
		public const MIN_X:uint = 0;
		public const MAX_Y:uint = stage.stageHeight;
		public const MIN_Y:uint = 0;
		
		public var man:Sprite;
		public var aProjectiles:Array = new Array();
		public static var text:TextField = new TextField();
		public var projectile:DisplayObject;
		private var shootTimer:Timer = new Timer(0, 20);
		
		public function Game()	{}
		
		override public function init():void 
		{
			super.init();
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			Input.init(stage);
			
			man = new Man(420, 0);
			addChild(man);
			
			addChild(new HorizontalWall(man, 250, 375, false));
			addChild(new HorizontalWall(man, 450, 350, false));
			addChild(new HorizontalWall(man, 170, 320, false));
			addChild(new HorizontalWall(man, 30, 280, false));
			addChild(new HorizontalWall(man, 310, 250, false));
			addChild(new HorizontalWall(man, 660, 250, false));
			addChild(new HorizontalWall(man, 700, 320, true));
			
			addChild(text);
		}
		
		private function enterFrame(e:Event):void
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
			
			if (Input.isKeyDown(Input.SPACE))	Man.SB = true;
			else Man.SB = false;
			
			if (Input.isKeyDown(Input.D))
			{
				shootTiming();
			}
			
			if (aProjectiles.length > 0)
			{
				for (var i:int = (aProjectiles.length - 1); i >= 0; i--)
				{
					projectile = aProjectiles[i];
					
					if (projectile.x > stage.stageWidth + 20 || projectile.x < MIN_X - 20)
					{
						projectile.parent.removeChild(projectile);
						aProjectiles.splice(i, 1);
					}
				}
			}
		}
		
		private function shootTiming():void
		{
			if (shootTimer.currentCount == shootTimer.repeatCount) {  shootTimer.reset();  }
			
			if (!shootTimer.running)
			{
				if (man.rotationY == 180) {  stage.addChild(new Fireball(-10, man.x, man.y));  }
				else if (man.rotationY == 0) {  stage.addChild(new Fireball(10, man.x, man.y));  }
				
				aProjectiles.push(stage.getChildAt(stage.numChildren - 1));
				projectile = stage.getChildAt(stage.numChildren - 1);
			}
			shootTimer.start();
		}
		
	}

}