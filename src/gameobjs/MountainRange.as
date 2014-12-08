package gameobjs 
{
	import geom.ThickPath;
	import org.flixel.FlxCamera;
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author 
	 */
	public class MountainRange extends FlxGroup {
		
		public var _level:Number = 0;
		
		private var mountains:ThickPath;
		
		public function init(Mountains:ThickPath):MountainRange {
			this.revive();
			mountains = Mountains;
			mountains.createSprites(this);
			return this;
		}
		
		/*public override function drawDebug(Camera:FlxCamera = null):void {
			super.drawDebug(Camera);
			mountains.drawDebug(Camera);
		}*/
	}

}