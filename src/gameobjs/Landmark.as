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
		public var _respawn_duration:Number = 0;
		
		public function landmark_init():Landmark {
			this.reset(0,0);
			_visiting_player = null;
			return this;
		}
		
		public override function game_update(g:GameEngineState):void {
			this.scale.x = Util.drp(this.scale.x, 1, 6);
			this.scale.y = Util.drp(this.scale.y, 1, 6);
			
			if (_respawn_duration > 0) {
				this.alpha = 0.3;
				this.set_scale(1-_respawn_duration / regen_duration());
				_respawn_duration--;
				return;
				
			} else if (_visiting_player == null) {
				for (var i:int = 0; i < g._player_balls.length; i++) {
					var itr_playerball:PlayerBall = g._player_balls.members[i];
					if (!itr_playerball || !itr_playerball.alive || itr_playerball._battling_enemies.length > 0 || itr_playerball._visiting_landmark != null) {
						continue;
					}
					
					if (this.is_hit_game_object(itr_playerball)) {
						visit_begin(g,itr_playerball);
						break;
					}
				}
			}
			this.alpha = 1;
					
			if (_visiting_player != null) {				
				_visiting_player.set_centered_position(
					Util.drp(_visiting_player.get_center().x, this.get_center().x, 5),
					Util.drp(_visiting_player.get_center().y, this.get_center().y, 5)
				);
				_visiting_duration--;
				if (_visiting_duration % 15 == 0) {
					if (_toggle % 2 == 0) {
						this.scale.y = 1.75;
						FlxG.play(Resource.SFX_HIT);
					} else {
						this.scale.x = 1.75;
						FlxG.play(Resource.SFX_HIT);
					}
					_toggle++;
				}
				if (_visiting_duration < 0) {
					this.visit_finished(g);
				}
			}
		}
		var _toggle:int = 0;
		
		public function visit_begin(g:GameEngineState, itr_playerball:PlayerBall):void {
			FlxG.play(Resource.SFX_SPIN);
			_visiting_player = itr_playerball;
			itr_playerball._visiting_landmark = this;
			if (g._player_balls.countLiving() == 1) FlxG.shake(0.001, 0.1);
			this.scale.x = 1.75;
			_visiting_duration = visit_duration();
		}
		
		public function visit_finished(g:GameEngineState):void {
			FlxG.play(Resource.SFX_POWERUP);
			_visiting_player._visiting_landmark = null;
			_visiting_player = null;
			_respawn_duration = regen_duration();
			if (g._player_balls.countLiving() == 1) FlxG.shake(0.001, 0.1);	
		}
		public function visit_duration():Number {
			return 80;
		}
		public function regen_duration():Number {
			return 150;
		}
	}

}