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
		
		private var mountains:ThickPath;
		
		public function init(Mountains:ThickPath):MountainRange {
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