package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	public class Platform extends IfritObject
	{		
		public var buffer:BitmapData;
		public var container:Sprite;
		public var vertical:Boolean;
		
		public function Platform(x:Number, y:Number, vertical:Boolean, bitmap:Bitmap, size:int = 200 ) 
		{
			var source:BitmapData = bitmap.bitmapData;
			var w:int = size < 3 ? 3 : size;
			
			this.buffer = new BitmapData(w, 10, true, 0);
			
			this.buffer.copyPixels(source, new Rectangle(0, 0, 1, 10), new Point);
			
			for (var i:int = 1; i < w; i++)
			{
				this.buffer.copyPixels(source, new Rectangle(1, 0, 1, 10), new Point(i));
			}
			
			this.buffer.copyPixels(source, new Rectangle(0, 0, 1, 10), new Point(w - 1));
			
			if (vertical)	this.rotation = 90;
			else 			this.rotation = 0;
			
			this.vertical = vertical;
			
			addChild(container = new Sprite);
				
			this.x = x;
			this.y = y;
			
			var bitmap:Bitmap = new Bitmap(buffer);
			container.addChild(bitmap);
			
			bitmap.x = -bitmap.width / 2;
			bitmap.y = -bitmap.height / 2;
		}
		
		public function collide(obj:DisplayObject):Boolean 
		{			
			var resolve:Function = (obj is Mob) ? resolveAsMob : resolveAsObject;
			return resolve(obj);
		}
		
		private function resolveAsMob(obj:DisplayObject):Boolean
		{			
			var dx:Number = obj.x - this.x; // Distance between objects (X)
			var dy:Number = obj.y - this.y; // Distance between objects (Y)
			
			var ox:Number = Math.abs( ( (this.width / 2) + ((obj as Mob).collisionHull.width / 2) ) - Math.abs(dx ) ); // Overlap on X axis
			var oy:Number = Math.abs( ( (this.height / 2) + ((obj as Mob).height / 2) ) - Math.abs(dy) ); // Overlap on Y axis
			
			if (this.hitTestObject((obj as Mob).collisionHull))
			{
				if (this.rotation == 0)
				{
					if (obj.y < this.y) // top
					{
						obj.y -= oy;
						(obj as Mob).gravUp = false;
						(obj as Mob).jumpTimer.reset();

						
					}
					else if (obj.y > this.y) // bottom
					{
						obj.y += oy;
						(obj as Mob).jumpReset();
					}
					else if (obj.x < this.x) obj.x -= ox; // left
					else if (obj.x > this.x) obj.x += ox; // right
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
					else if (obj.y > this.y) // bottom
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
			
			var ox:Number = Math.abs( ( (this.width / 2) + 	(obj.width / 2	) ) - Math.abs(dx ) );
			var oy:Number = Math.abs( ( (this.height / 2) + (obj.height / 2	) ) - Math.abs(dy) );
			
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
						if (obj is Projectile)
						{
							if (obj.y - (obj as Projectile).lastPosition.y >= this.height)
							{
								obj.y -= 20;
							}
						}
						obj.y += oy;
					}
					else if (obj.x <= this.x) obj.x -= ox; // left
					else if (obj.x >= this.x) obj.x += ox; // right
				}
				else 
				{
					if (obj.x <= this.x) obj.x -= ox; // left
					else if (obj.x >= this.x) obj.x += ox; // right
					else if (obj.y <= this.y) // top
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

