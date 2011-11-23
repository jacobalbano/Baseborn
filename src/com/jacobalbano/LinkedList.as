package com.jacobalbano 
{
	/**
	 * @author Jake Albano <jacob.albano@gmail.com>
	 */
	import com.jacobalbano.ListNode;
	
	public class LinkedList
	{		
		public var iterator:Class = ListIterator;
		
		private var _size:uint = 0;
		
		private var _type:Class;
		
		private var firstNode:ListNode = null;
		private var lastNode:ListNode = null;
		
		private var _sortPredicate:Function = null;
		
		public function LinkedList(T:Class)
		{
			this._type = T as Class;
		}
		
		public function get size():uint
		{
			return this._size;
		}
		
		public function get front():uint
		{
			return 0;
		}
		
		public function get back():uint
		{
			return this._size - 1;
		}
		
		public function begin():ListNode
		{
			return this.firstNode;
		}
		
		public function push(v:*):void
		{
			if (v is this._type)
			{
				if (!firstNode)
				{
					var n:ListNode = new ListNode(_type);
					n.data = v as _type;
					this.firstNode = n;
					this.lastNode = this.firstNode;
					
					this._size++;
					
					return;
				}
				else
				{
					var nn:ListNode = new ListNode(_type);
					nn.data = v as _type;
					nn.next = null;
					this.lastNode.next = nn;
					this.lastNode = nn;
					
					this._size++;
					
					return;
				}
			}
		}
		
		public function insert(at:uint, v:*):void
		{
			if (v is this._type)
			{	
				if (at > this._size) at = this._size;
				
				var index:uint = 0
				for (var itr:Iterator = new ListIterator(this); itr.value; itr.next() )
				{
					if (index == at)
					{
						var nnn:ListNode = new ListNode(_type);
						nnn.data = v as _type;
						
						nnn.next = itr.node.next;
						itr.node.next = nnn;
						
						this._size++;
						
						break;
					}
					index++;
				}
			}
		}

		public function pop():void
		{			
			if (!this.firstNode)
			{
				_size--;
				return;
			}
			else if (!this.firstNode.next)
			{
				_size--;
				this.firstNode = null;
				return;
			}
			
			for (var itr:Iterator = new ListIterator(this); ; itr.next() )
			{
				if (!itr.node.next.next)
				{
					_size--;
					itr.node.next = null;
					break;
				}
			}
		}
		
		public function remove(at:uint, until:uint = NaN ):void
		{			
			if (at > this._size) at = this._size;
			if (until > this._size) until = this._size;
			
			var found:Boolean = false;
			var range:int = until - at;
			
			for (var itr:Iterator = new ListIterator(this); itr.value; itr.next() )
			{
				if (at == 0 && itr.index == at)
				{
					this._size--;
					this.firstNode = this.firstNode.next;
					found = true;
				}
				
				if (itr.index + 1 == at)
				{
					this._size--;
					itr.node.next = itr.node.next.next;
					found = true;
					if (isNaN(until) ) break;
				}
				
				if (found && until > at)
				{
					if (at == 0 && itr.index == at)
					{
						while (range --> 0)
						{
							this._size--;
							this.firstNode = this.firstNode.next;
						}
						
						break;
					}
					else
					{
						while (range --> 0)
						{
							itr.node.next = itr.node.next.next;
							this._size--;
						}
						
						break;
					}
				}
			}
			
		}
		
		private function numericPredicate(one:*, two:*):Boolean
		{
			return one as Number > two as Number;
		}
	}
	
}