package ifrit 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author jake
	 */
	public class IfritObject extends Sprite 
	{
		protected var destroyed:Boolean;	
		public function IfritObject() 
		{
			addEventListener(Event.ENTER_FRAME, enterFrame);
			addEventListener(Event.REMOVED_FROM_STAGE, unload);
		}
		
		public function get isDestroyed():Boolean	{	return this.destroyed;	}
		
		/**
		 * Override this; called in enterFrame
		 */
		protected function update():void		{ }
		protected function stopUpdating():void
		{
			if (this.hasEventListener(Event.ENTER_FRAME))	this.removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		
		public function destroy():void
		{
			if (this.isDestroyed) return;
			this.destroyed = true;
		}
		
		private function enterFrame(e:Event):void
		{
			update();
		}
		
		private function unload(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, unload);
		}
		
	}

}