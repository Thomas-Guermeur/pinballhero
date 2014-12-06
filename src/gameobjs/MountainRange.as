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
		
		public function MountainRange(Mountains:ThickPath) {
			mountains = Mountains;
			mountains.createSprites(this);
		}
		
		/*public override function drawDebug(Camera:FlxCamera = null):void {
			super.drawDebug(Camera);
			mountains.drawDebug(Camera);
		}*/
	}

}