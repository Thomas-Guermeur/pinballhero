package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	
	/**
	 * ...
	 * @author spotco
	 */
	public class RotatingSignLandmark extends Landmark {
		
		public var radians:Number;
		
		public function RotatingSignLandmark() {
			this.loadGraphic(Resource.SIGN);
		}
		
		public override function game_update(g:GameEngineState):void {
			super.game_update(g);
			
			radians += .001;
			if (radians > Math.PI) {
				radians -= 2 * Math.PI;
			}
			
			angle = Util.RAD_TO_DEG * radians;
		}
		
		public override function handleVisitor(visitor:PlayerBall, g:GameEngineState):void {
			var speed:Number = getVisitorSpeed(visitor);
			visitor.velocity.x = speed * Math.cos(radians);
			visitor.velocity.y = speed * Math.sin(radians);
		}
		
		public override function setVector(x1:Number, y1:Number, x2:Number=0, y2:Number=0):void {
			super.setVector(x1, y1, x2, y2);
			radians = Math.atan2(y2 - y1, x2 - x1);
		}
	}

}