package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	
	/**
	 * ...
	 * @author spotco
	 */
	public class TownLandmark extends Landmark {
		
		public function TownLandmark() {
			this.loadGraphic(Resource.TOWN);
		}
		
		public function init():TownLandmark {
			landmark_init();
			return this; 
		}
		
		public override function get_center():FlxPoint {
			return new FlxPoint(this.x + 49, this.y + 58);
		}
		
		
	}

}