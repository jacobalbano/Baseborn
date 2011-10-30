package ifrit 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class VerticalWall extends Sprite
	{
		[Embed(source = "../../lib/vertical.png")] public const VERTICAL:Class;
		
		public var vWall:Bitmap = new VERTICAL;
		public var vWallC:Sprite = new Sprite();
		
		public function VerticalWall() 
		{
			addChild(vWallC);
			
			vWallC.x = vWall.x - (vWall.width / 2);
			vWallC.y = vWall.y - (vWall.height / 2);
			
			vWallC.addChild(vWall);
		}
		
	}

}