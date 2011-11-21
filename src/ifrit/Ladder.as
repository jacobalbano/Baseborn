package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * @author Jake Albano
	 */
	public class Ladder extends IfritObject 
	{
		private var buffer:BitmapData;
		
		public function Ladder(x:Number, y:Number, height:int) 
		{
			var h:Number = height < 9 ? 9 : height;
			var source:BitmapData = Library.IMG("misc.ladder.png").bitmapData;
			
			this.buffer = new BitmapData(24, h, true, 0);
			
			this.buffer.copyPixels(source, new Rectangle(0, 0, 24, 1), new Point);
			
			for (var i:uint = 0; i < h; i += 7)
			{
				this.buffer.copyPixels(source, new Rectangle(0, 1, 24, 7), new Point(0, i + 1));
			}
			
			var display:Bitmap = new Bitmap(buffer);
			this.addChild(display);
			display.x = -display.width / 2;
			
			this.x = x;
			this.y = y;
		}
		
	}

}