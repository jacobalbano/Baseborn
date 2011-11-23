package com.jacobalbano 
{
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Map 
	{
		private var Pairs:LinkedList = new LinkedList(Pair);
		private var type0:Class;
		private var type1:Class;
		
		private var _begin:Function = Pairs.begin;
		
		public var iterator:Class = MapIterator;
		
		private var _size:uint = 0;
		
		public function Map(T1:Class, T2:Class = null) 
		{
			this.type0 = T1 as Class;
			if (T2)
			{
				this.type1 = T2 as Class;
			}
			else
			{
				this.type1 = this.type1  as Class;
			}
		}
		
		public function add(p0:*, p1:*):void
		{
			if (p0 is this.type0 && p1 is this.type1)
			{
				for (var itr:Iterator = new MapIterator(this); itr.value; itr.next() )
				{
					if (p0 == itr.value.first) return;
				}
				
				var _in:Pair;
				this.Pairs.push(_in = new Pair(this.type0, this.type1) )
				_in.both(p0 as this.type0, p1 as this.type1);
				this._size++;
			}
		}
		
		public function remove(key:*):void
		{
			if (key is this.type0)
			{
				for (var itr:Iterator = new MapIterator(this); itr.value; itr.next() )
				{
					if (key == itr.value.first)
					this.Pairs.remove(itr.index);
				}
			}
		}
		
		public function retrive(key:*):*
		{
			if (key is this.type0)
			{
				for (var itr:Iterator = new MapIterator(this); itr.value ; itr.next() )
				{
					if (key == itr.value.first)	return itr.value.second as this.type1;
				}
			}
		}
		
		public function get size():uint
		{
			return this._size;
		}
				
		public function get begin():Function
		{
			return this._begin;
		}
		
	}

}