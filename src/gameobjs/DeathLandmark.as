package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	
	/**
	 * ...
	 * @author spotco
	 */
	public class DeathLandmark extends Landmark {
		
		public var radians:Number;
		
		public function DeathLandmark() {
			this.loadGraphic(Resource.DEATH);
		}
		
		public function init():DeathLandmark {
			this.reset(0,0);
			return this;
		}
		
		public override function handleVisitor(visitor:PlayerBall, g:GameEngineState):void {
			visitor.hurt(visitor._max_hitpoints);
		}
	}

}