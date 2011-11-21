package ifrit 
{
	
	import flash.display.Bitmap;
	import com.jacobalbano.Animation;
	import flash.display.Sprite;
	
	/**
	 * @author Jake Albano
	 */
	public class Decal extends IfritObject 
	{
		
		private var callback:Function;
		
		public function Decal(bitmap:Bitmap, x:Number, y:Number, callback:Function = null, frames:Array = null, frameWidth:Number = 0, frameHeight:Number = 0 ) 
		{
			if (frames)
			{
				var a:Animation = new Animation(bitmap, frameWidth, frameHeight);
				a.add("loop", frames, 5, true);
				a.play("loop");
				a.x = x - a.width / 2;
				a.y = y - a.height / 2;
				Game.stage.addChild(a);
			}
			else
			{
				var s:Sprite = new Sprite;
				s.addChild(bitmap);
				s.x = x - s.width / 2;
				s.y = y - s.height / 2;
				addChild(s);
			}
			
			if (callback != null)
			{
				this.callback = callback;
			}
		}
		
		override protected function update():void 
		{
			super.update();
			
			if (this.callback != null)	this.callback(this);
		}
		
	}

}