package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	
	/**
	 * ...
	 * @author spotco
	 */
	public class RotatingSignLandmark extends SignLandmark {
		
		public function RotatingSignLandmark() {
			this.loadGraphic(Resource.SIGN);
		}
		
		public function init():RotatingSignLandmark {
			this.reset(0, 0);
			return this;
		}
		
		public override function game_update(g:GameEngineState):void {
			super.game_update(g);
			
			radians += .02;
			if (radians > Math.PI) {
				radians -= 2 * Math.PI;
			}
			
			angle = Util.RAD_TO_DEG * radians;
		}
		
		public override function setVector(x1:Number, y1:Number, x2:Number=0, y2:Number=0):void {
			super.setVector(x1, y1);
			radians = Math.random() * Math.PI * 2 - Math.PI;
		}
	}

}