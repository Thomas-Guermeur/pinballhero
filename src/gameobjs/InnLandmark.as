package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	
	/**
	 * ...
	 * @author spotco
	 */
	public class InnLandmark extends Landmark {
		
		public function InnLandmark() {
			this.loadGraphic(Resource.TOWN);
		}
		
		public override function handleVisitor(visitor:PlayerBall, g:GameEngineState):void {
			visitor._hitpoints = Math.min(visitor._hitpoints + 1, visitor._max_hitpoints);
		}
	}

}