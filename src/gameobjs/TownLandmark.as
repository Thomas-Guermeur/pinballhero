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
		
		public function init():TownLandmark { return this; }
		
	}

}