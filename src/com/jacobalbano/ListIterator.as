package com.jacobalbano 
{
	/**
	 * ...
	 * @author Jake Albano
	 */
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	 
	public class ListIterator extends Iterator
	{
		private var _node:ListNode;
		
		public function ListIterator(l:LinkedList) 
		{
			super(l);
			this._node = l.begin();
			if (this._node)
			{
				this._type = getDefinitionByName(getQualifiedClassName(this._node.data) ) as Class;
			}
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
		
		override public function get node():*
		{
			if (this._node != null) return this._node as ListNode;
			else return null;
		}
		
	}

}