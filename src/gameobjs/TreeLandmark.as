package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	
	/**
	 * ...
	 * @author spotco
	 */
	public class TreeLandmark extends Landmark {
		
		public function TreeLandmark() {
			this.loadGraphic(Resource.TREE);
		}
		
		public function init():TreeLandmark {
			this.reset(0, 0);
			return this;
		}
		
		public override function handleVisitor(visitor:PlayerBall, g:GameEngineState):void {
			var speed:Number = getVisitorSpeed(visitor);
			
			var velocityRad:Number = Math.atan2(visitor.velocity.y, visitor.velocity.x);
			var collideRad:Number = Math.atan2(visitor.get_center().y - get_center().y, visitor.get_center().x - get_center().x) + Math.PI / 2;
			
			var radians:Number = -velocityRad + 2 * collideRad;
			visitor.velocity.x = speed * Math.cos(radians);
			visitor.velocity.y = speed * Math.sin(radians);
		}
	}

}