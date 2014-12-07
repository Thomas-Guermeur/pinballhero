package gameobjs 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author 
	 */
	
	//override for unique enter, wait period and regen after time behavior
	public class Landmark extends GameObject {
		
		public var _visiting_player:PlayerBall = null;
		public var _visiting_duration:Number = 0;
		
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
						_visiting_player = itr_playerball;
						itr_playerball._visiting_landmark = this;
						FlxG.shake(0.005, 0.1);
						this.scale.x = 1.75;
						_visiting_duration = visit_duration();
					}
				}
			}
					
			if (_visiting_player != null) {				
				_visiting_player.set_centered_position(
					Util.drp(_visiting_player.get_center().x, this.get_center().x, 5),
					Util.drp(_visiting_player.get_center().y, this.get_center().y, 5)
				);
				_visiting_duration--;
				if (_visiting_duration % 15 == 0) {
					if (_toggle % 2 == 0) {
						this.scale.y = 1.75;
					} else {
						this.scale.x = 1.75;
					}
					_toggle++;
				}
			}
			this.scale.x = Util.drp(this.scale.x, 1, 6);
			this.scale.y = Util.drp(this.scale.y, 1, 6);
		}
		var _toggle:int = 0;
		
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