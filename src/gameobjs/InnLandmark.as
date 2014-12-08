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
			this.loadGraphic(Resource.INN);
		}
		
		public function init():InnLandmark {
			this.reset(0, 0);
			return this;
		}
		
		public override function handleVisitor(visitor:PlayerBall, g:GameEngineState):void {
			visitor._hitpoints = visitor._max_hitpoints;
		}
	}

}