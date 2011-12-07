package ifrit 
{
	/**
	 * ...
	 * @author jake
	 */
	public class Variable 
	{
		
		public var number:Number;
		public var bool:Boolean;
		public var string:String;
		
		public function Variable(number:Number = 0, bool:Boolean = false, string:String = "") 
		{
			this.number = number;
			this.bool = bool;
			this.string = string;
		}
		
	}

}