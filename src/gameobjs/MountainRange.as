package gameobjs 
{
	import geom.ThickPath;
	import org.flixel.FlxCamera;
	/**
	 * ...
	 * @author 
	 */
	public class MountainRange extends GameObject {
		
		private var mountains:ThickPath;
		
		public function MountainRange(Mountains:ThickPath) {
			mountains = Mountains;
			
		}
		
		public override function drawDebug(Camera:FlxCamera = null):void {
			super.drawDebug(Camera);
			mountains.drawDebug(Camera);
		}
		
	}

}