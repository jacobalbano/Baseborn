package com.jacobalbano
{
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	
	public class ListNode
	{
		private var _type:Class;
		private var _data:Array = new Array;
		private var _next:ListNode = null;
		private var _prev:ListNode = null;
		
		public function ListNode(T:Class)
		{
			this._type = T as Class;
		}
				
		public function get data():*
		{
			return this._data[0] as this._type;
		}
		
		public function set data(d:*):void
		{
			if (d is this._type) this._data[0] = d as this._type;
		}
		
		public function get next():ListNode
		{
			return this._next;
		}
		
		public function set next(n:ListNode):void
		{
			this._next = n;
		}
		
		public function get previous():ListNode
		{
			return this.previous;
		}
		
		public function set previous(n:ListNode):void
		{
			this._next = n;
		}

	}
	
}