package com.jacobalbano 
{
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Iterator 
	{
		
		protected var _value:*;
		protected var _type:Class;
		private var _index:uint = 0;
		
		public function Iterator(listItem:*) 
		{
			
		}
		
		public function next():void
		{
			++this._index;
			//	Override this
		}
		
		public function get value():*
		{
			//	Override this
		}
		
		public function get index():uint
		{
			return _index;
		}
		
		public function get node():*
		{
			//	Override this
		}
	}

}