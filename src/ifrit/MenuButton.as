package ifrit 
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * @author Jake Albano
	 */
	public class MenuButton extends IfritObject 
	{
		private var i:Bitmap;
		public function MenuButton(x:Number, y:Number, image:Bitmap, callback:Function) 
		{
			addChild(i = image);
			i.x = -i.width / 2;
			i.y = -i.height / 2;
			
			this.x = x;
			this.y = y;
			
			if (callback != null)
			{
				this.addEventListener(MouseEvent.CLICK, click );
			}
			
			this.addEventListener(MouseEvent.MOUSE_OVER, function(e:Event):void { Mouse.cursor = MouseCursor.BUTTON; i.alpha = 0.9; } );
			this.addEventListener(MouseEvent.MOUSE_OUT, function(e:Event):void { Mouse.cursor = MouseCursor.ARROW; i.alpha = 1; } );
			//this.addEventListener(Event.REMOVED_FROM_STAGE, function(e:Event):void { this.removeEventListener(MouseEvent.CLICK, click); } );
			
			function click (e:Event):void
			{
				callback();
			}
			
		}
		
	}

}