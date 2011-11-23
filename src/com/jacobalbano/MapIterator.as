package com.jacobalbano 
{
	/**
	 * ...
	 * @author Jake Albano
	 */
	
	
	
	
	public class MapIterator extends Iterator
	{
		private var _node:ListNode;
		
		public function MapIterator(m:Map) 
		{
			super(m);
			this._node = m.begin();
			this._type = Pair;
		}
		
		override public function next():void
		{
			super.next();
			this._node = this._node.next;
			if (this._node != null) this._value = this._node.data;
		}
		
		override public function get value():*
		{
			if (this._node != null) return this._node.data as _type;
			else return null;
		}
		
	}

}