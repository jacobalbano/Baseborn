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
	public class RopeBridge extends IfritObject 
	{
		
		private var buffer:BitmapData;
		
		public function RopeBridge(x:Number, y:Number, width:int) 
		{
			var w:Number = width < 60 ? 60 : width;
				w -= w % 15;
				w += 24;
			var source:BitmapData = Library.IMG("forest.ropeBridge.png").bitmapData;
			
			this.buffer = new BitmapData(w, 14, true, 0);
			
			this.buffer.copyPixels(source, new Rectangle(0, 0, 12, 14), new Point);
			
			for (var i:uint = 12; i < w - 12; i += 15)
			{
				this.buffer.copyPixels(source, new Rectangle(15, 0, 17, 14), new Point(i , 0));
				
				this.buffer.copyPixels(source, new Rectangle(15, 0, 17, 14), new Point(i , 0));
			}
			
			this.buffer.copyPixels(source, new Rectangle(32, 0, 14, 14), new Point(w - 14, 0));
			
			var display:Bitmap = new Bitmap(buffer);
			this.addChild(display);
			
			display.x = -display.width / 2;
			display.y = -display.height / 2;
			
			this.x = x;
			this.y = y;
		}
		
	}

}