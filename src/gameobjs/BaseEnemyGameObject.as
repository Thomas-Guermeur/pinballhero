package gameobjs 
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author spotco
	 */
	public class BaseEnemyGameObject extends GameObject {
		
		public function BaseEnemyGameObject() {
			this.loadGraphic(Resource.ENEMY);
		}
		
		public override function get_center():FlxPoint {
			return new FlxPoint(this.x + 22.5, this.y + 22.5);
		}
		
		public override function is_hit_game_object(other:GameObject):Boolean {
			return Util.point_dist(this.get_center().x, this.get_center().y, other.get_center().x, other.get_center().y) < 30;
		}
		
		public override function game_update(g:GameEngineState):void {
			for each (var itr_playerball:PlayerBall in g._player_balls.members) {
				if (itr_playerball.alive && this.is_hit_game_object(itr_playerball)) {
					if (!itr_playerball._engaged_in_battle) {
						itr_playerball._engaged_in_battle = true;
					}
				}
			}
		}
		
	}

}