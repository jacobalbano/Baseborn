package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Platform extends Sprite
	{		
		public var hWall:Bitmap = Library.IMG("horizontal.png");
		public var hWallC:Sprite = new Sprite();
		
		public function Platform(x:Number, y:Number, vertical:Boolean) 
		{
			addChild(hWallC);
			
			hWallC.x = hWall.x - (hWall.width / 2);
			hWallC.y = hWall.y - (hWall.height / 2);
			
			this.x = x;
			this.y = y;
			
			if (vertical) this.rotation = 90;
			else this.rotation = 0;
			
			hWallC.addChild(hWall);
		}
		
		public function collide(obj:DisplayObject):Boolean 
		{
			var objHalfW:Number = obj.width / 2;
			var objHalfH:Number = obj.height / 2;
			var thisHalfW:Number = this.width / 2;
			var thisHalfH:Number = this.height / 2;
			
			var dx:Number = this.x - obj.x; // Distance between objects (X)
			var dy:Number = obj.y - this.y; // Distance between objects (Y)
			
			var ox:Number = (thisHalfW + objHalfW) - Math.abs(dx); // Overlap on X axis
			var oy:Number = (thisHalfH + objHalfH) - Math.abs(dy); // Overlap on Y axis
			
			if (this.hitTestObject(obj))
			{
				if (this.rotation == 0)
				{
					if (obj.y <= this.y) // top
					{
						obj.y -= oy;
						
						if (obj is Mob)
						{
							(obj as Mob).gravUp = false;
							(obj as Mob).jumpTimer.reset();
						}
						
					}
					else if (obj.y >= this.y) // bottom
					{
						obj.y += oy;
						if (obj is Mob)	(obj as Mob).jumpReset();
					}
					else if (obj.x <= this.x) obj.x -= ox; // left
					else if (obj.x >= this.x) obj.x += ox; // right
				}
				else 
				{
					if (obj.x < this.x) obj.x -= ox; // left
					else if (obj.x > this.x) obj.x += ox; // right
					else if (obj.y < this.y) // top
					{
						obj.y -= oy;
						if (obj is Mob)
						{
							(obj as Mob).gravUp = false;
							(obj as Mob).jumpTimer.reset();
						}
					}
					else if (obj.y >= this.y) // bottom
					{
						obj.y += oy;
						if (obj is Mob)	(obj as Mob).jumpReset();
					}
				}
				
				
				
				return true;
			}
			
			return false;
		}
	}
}

//BUG: Strange results if player touching >1 platform at a time
/*
 * 
 */