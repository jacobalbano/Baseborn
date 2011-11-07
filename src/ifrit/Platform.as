package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Platform extends Sprite
	{		
		public var bitmap:Bitmap = Library.IMG("horizontal.png");
		public var container:Sprite = new Sprite();
		
		public function Platform(x:Number, y:Number, vertical:Boolean) 
		{
			addChild(container);
			
			container.x = bitmap.x - (bitmap.width / 2);
			container.y = bitmap.y - (bitmap.height / 2);
			
			this.x = x;
			this.y = y;
			
			if (vertical) this.rotation = 90;
			else this.rotation = 0;
			
			container.addChild(bitmap);
		}
		
		public function collide(obj:DisplayObject):Boolean 
		{			
			var resolve:Function = (obj is Mob) ? resolveAsMob : resolveAsObject;
			return resolve(obj);
		}
		
		private function resolveAsMob(obj:DisplayObject):Boolean
		{
			//FIXME: Unable to land on vertical platforms again
			
			//BUG: Being pushed out of collision prohibits attacks
			/*
			 * If you try to jump and land on top of a vertical wall and are pushed
			 * off, if you are facing away from the wall when you land, you cannot use
			 * any attacks.
			 */
			
			var dx:Number = this.x - obj.x; // Distance between objects (X)
			var dy:Number = obj.y - this.y; // Distance between objects (Y)
			
			var ox:Number = ( (this.width / 2) + ((obj as Mob).collisionHull.height / 2) ) - Math.abs(dx); // Overlap on X axis
			var oy:Number = ( (this.height / 2) + ((obj as Mob).collisionHull.height / 2) ) - Math.abs(dy); // Overlap on Y axis
			
			if (this.hitTestObject((obj as Mob).collisionHull))
			{
				if (this.rotation == 0)
				{
					if (obj.y <= this.y) // top
					{
						obj.y -= oy;
						(obj as Mob).gravUp = false;
						(obj as Mob).jumpTimer.reset();

						
					}
					else if (obj.y >= this.y) // bottom
					{
						obj.y += oy;
						(obj as Mob).jumpReset();
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
						(obj as Mob).gravUp = false;
						(obj as Mob).jumpTimer.reset();
					}
					else if (obj.y >= this.y) // bottom
					{
						obj.y += oy;
						(obj as Mob).jumpReset();
					}
				}
				
				return true;
			}
			
			return false;
		
		}
		
		private function resolveAsObject(obj:DisplayObject):Boolean
		{
			var dx:Number = this.x - obj.x; // Distance between objects (X)
			var dy:Number = obj.y - this.y; // Distance between objects (Y)
			
			var ox:Number = ( (this.width / 2) + (obj.height / 2) ) - Math.abs(dx); // Overlap on X axis
			var oy:Number = ( (this.height / 2) + (obj.height / 2) ) - Math.abs(dy); // Overlap on Y axis
			
			if (this.hitTestObject(obj))
			{
				if (this.rotation == 0)
				{
					if (obj.y <= this.y) // top
					{
						obj.y -= oy;						
					}
					else if (obj.y >= this.y) // bottom
					{
						obj.y += oy;
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
					}
					else if (obj.y >= this.y) // bottom
					{
						obj.y += oy;
					}
				}
				
				return true;
			}
			
			return false;
		}
	}
}

