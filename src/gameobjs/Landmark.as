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
			for (var i:int = 0; i < g._player_balls.members.length; i++) {
				var itr_playerball:PlayerBall = g._player_balls.members[i];
				if (!itr_playerball) {
					continue;
				}
				
				var curr:Number = Util.point_dist(
					this.get_center().x, this.get_center().y,
					itr_playerball.get_center().x, itr_playerball.get_center().y
				);
				var next:Number = Util.point_dist(
					this.get_center().x, this.get_center().y,
					itr_playerball.get_center().x + itr_playerball.velocity.x, itr_playerball.get_center().y + itr_playerball.velocity.y
				);
				var radius:Number = (this.width + itr_playerball.width) / 2;
				
				if (itr_playerball.alive && curr > radius && next < radius) {
					handleVisitor(itr_playerball, g);
				}
			}
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