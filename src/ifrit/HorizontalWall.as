package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	//TODO: block any and all objects
	/*
	 * Put all objects into an array and have each wall 
	 * block every element in that object array
	 */
	public class HorizontalWall extends Sprite
	{		
		public var hWall:Bitmap = Library.IMG("horizontal.png");
		public var hWallC:Sprite = new Sprite();
		
		private var obj:DisplayObject;
		
		public function HorizontalWall(object:DisplayObject, x:Number, y:Number, vertical:Boolean) 
		{
			addChild(hWallC);
			
			hWallC.x = hWall.x - (hWall.width / 2);
			hWallC.y = hWall.y - (hWall.height / 2);
			
			this.x = x;
			this.y = y;
			
			if (vertical) this.rotation = 90;
			else this.rotation = 0;
			
			hWallC.addChild(hWall);
			
			obj = object;
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void 
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
					if (obj.y < this.y) // top
					{
						obj.y -= oy;
						Man.gravUp = false;
						Man.jumpTimer.reset();
					}
					else if (obj.y > this.y) // bottom
					{
						Man.vy = 0;
						obj.y += oy;
					}
					else if (obj.x <= this.x) obj.x -= ox; // left
					else if (obj.x >= this.x) obj.x += ox; // right
				}
				else 
				{
					if (obj.x < this.x) obj.x -= ox; // left
					else if (obj.x > this.x) obj.x += ox; // right
					else if (obj.y <= this.y) // top
					{
						obj.y -= oy;
						Man.gravUp = false;
						Man.jumpTimer.reset();
					}
					else if (obj.y >= this.y) // bottom
					{
						obj.y += oy;
						Man.vy = 0;
					}
				}
			}
			
			//trace("obj x: " + obj.x);
			//trace("obj y: " + obj.y);
			//trace("ox: " + ox);
			//trace("oy: " + oy);
			//trace("dx: " + dx);
			//trace("dy: " + Math.abs(dy));
			//trace("objHalfW: " + objHalfW);
			//trace("objHalfH: " + objHalfH);
			//trace("thisHalfW: " + thisHalfW);
			//trace("thisHalfH: " + thisHalfH);
			//trace("this x: " + this.x);
			//trace("this y: " + this.y);
			//trace("----------------------");
		} // end enter frame
	}
}

//BUG: player forced down if touching >1 platform at a time
/*
 * 
 */