package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	
	/**
	 * ...
	 * @author spotco
	 */
	public class SignLandmark extends Landmark {
		
		public var radians:Number;
		
		public function SignLandmark() {
			this.loadGraphic(Resource.SIGN);
		}
		
		public override function handleVisitor(visitor:PlayerBall, g:GameEngineState):void {
			var speed:Number = getVisitorSpeed(visitor);
			visitor.velocity.x = speed * Math.cos(radians);
			visitor.velocity.y = speed * Math.sin(radians);
			visitor.hitSign(g);
		}
		
		public override function setVector(x1:Number, y1:Number, x2:Number=0, y2:Number=0):void {
			super.setVector(x1, y1, x2, y2);
			radians = Math.atan2(y2 - y1, x2 - x1);
		}
	}

}