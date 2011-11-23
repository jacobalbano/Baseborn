package com.jacobalbano 
{
	/**
	 * @author Jake Albano <jacob.albano@gmail.com>
	 */
		
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class Pair
	{
		private var _value0:Array;
		private var _value1:Array;
		private var _type0:Class;
		private var _type1:Class;
		
		/**
		 * Constructor
		 * @param	T1			Class type for first element
		 * @param	T2			Class type for second element
		 */
		public function Pair(T1:Class, T2:Class = null)
		{
			_type0 = T1;
			
			if (T2)	_type1 = T2;
			else _type1 = _type0;
			
			_value0 = new Array();
			_value0.push(new _type0);
			
			_value1 = new Array();
			_value0.push(new _type1);
			
		}
		
		/**
		 * Returns a copy of an existing pair
		 * @param	p			The pair to copy
		 */
		public static function copy(p:Pair):Pair
		{
			function classof(o:Object):Class
			{
				return Class(getDefinitionByName(getQualifiedClassName(o)));
			}
			
			var r:Pair = new Pair(classof(p.first), classof(p.second) );
			
			r.first = p.first;
			r.second = p.second;
			
			return r;
		}
		
		/**
		 * Return the first element
		 */
		public function get first():*
		{
			return this._value0[0] as this._type0;
		}
		
		/**
		 * Return the second element
		 */
		public function get second():*
		{
			return this._value1[0] as this._type1;
		}
		
		/**
		 * Sets the first element
		 * @param	p				The value to store
		 */
		public function set first(p:*):void
		{	
			if (p is _type0) _value0[0] = p as _type0;
		}
		
		/**
		 * Sets the second element
		 * @param	p				The value to store
		 */
		public function set second(p:*):void
		{
			if (p is _type1) _value1[0] = p as _type1;
		}

		/**
		 * Stores two values as the first and second elements, respectively
		 * @param	p1				The first value to store
		 * @param	p2				The first value to store
		 */
		public function both(p1:*, p2:*):void
		{
			if (p1 is _type0)	first = p1 as _type0;
			if (p2 is _type1)	second = p2 as _type1;
		}
	}

}