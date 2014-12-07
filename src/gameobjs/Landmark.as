package gameobjs 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author 
	 */
	
	//override for unique enter, wait period and regen after time behavior
	public class Landmark extends GameObject {
		
		public var _visiting_player:PlayerBall = null;
		public function landmark_init():Landmark {
			_visiting_player = null;
			return this;
		}
		
		public override function game_update(g:GameEngineState):void {
			if (this == g._current_town) return;
			if (_visiting_player == null) {
				for (var i:int = 0; i < g._player_balls.members.length; i++) {
					var itr_playerball:PlayerBall = g._player_balls.members[i];
					if (!itr_playerball || !itr_playerball.alive || itr_playerball._battling_enemies.length > 0 || itr_playerball._visiting_landmark != null) {
						continue;
					}
					
					if (this.is_hit_game_object(itr_playerball)) {
						trace("landmark hit");
						_visiting_player = itr_playerball;
						itr_playerball._visiting_landmark = this;
					}
				}
			}
			if (_visiting_player != null) {
				
			}
		}
		
		public function player_visit_animation_update():void {
			
		}
		public function visit_duration():Number {
			return 80;
		}
		public function regen_duration():Number {
			return 150;
		}
	}

}