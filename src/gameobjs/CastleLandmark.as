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
		
		public function init():CastleLandmark { return this; }
		
	}

}