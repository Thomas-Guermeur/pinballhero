package gameobjs 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author 
	 */
	public class Landmark extends GameObject {
		
		public override function game_update(g:GameEngineState):void {
			
		}
		
		public function handleVisitor(visitor:PlayerBall, g:GameEngineState):void {
			// overriden in actual landmarks
		}
		
		public function getVisitorSpeed(visitor:PlayerBall):Number {
			return Util.point_dist(0, 0, visitor.velocity.x, visitor.velocity.y);
		}
		
		public override function get_center():FlxPoint {
			return new FlxPoint(this.x + this.width / 2, this.y + this.height / 2);
		}
		
		public function setVector(x1:Number, y1:Number, x2:Number=0, y2:Number=0):void {
			x = x1;
			y = y1;
		}
	}

}