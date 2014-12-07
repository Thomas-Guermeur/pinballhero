package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	
	/**
	 * ...
	 * @author spotco
	 */
	public class CastleLandmark extends Landmark {
		
		public function CastleLandmark() {
			this.loadGraphic(Resource.CASTLE);
		}
		
		public function init():CastleLandmark {
			landmark_init();
			return this;
		}
		
		public override function get_center():FlxPoint {
			return new FlxPoint(this.x + 65.5, this.y + 81.5);
		}
		
	}

}