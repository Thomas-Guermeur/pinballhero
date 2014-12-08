package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	
	/**
	 * ...
	 * @author spotco
	 */
	public class TownLandmark extends Landmark {
		
		public function TownLandmark() {
			this.loadGraphic(Resource.TOWN);
		}
		
		public function init():TownLandmark {
			this.reset(0,0);
			landmark_init();
			return this; 
		}
		
		public override function game_update(g:GameEngineState):void {
			if (this == g._current_town) {
				for (var i:int = 0; i < g._player_balls.length; i++) {
					var itr_playerball:PlayerBall = g._player_balls.members[i];
					if (itr_playerball.alive && itr_playerball._launched_ct > 50 && this.is_hit_game_object(itr_playerball)) {
						itr_playerball.kill();
						if (itr_playerball._healthbar != null) g._healthbars.remove(itr_playerball._healthbar);
						itr_playerball._healthbar = null;
						g.add_ball(itr_playerball.get_center().x,itr_playerball.get_center().y);
						g._chatmanager.push_message("Hero has returned back to town.");
					}
				}
			} else {
				for (var i:int = 0; i < g._player_balls.length; i++) {
					var itr_playerball:PlayerBall = g._player_balls.members[i];
					if (itr_playerball.alive && itr_playerball._launched_ct > 50 && this.is_hit_game_object(itr_playerball)) {
						g._current_town = this;
						g._chatmanager.push_message("Discovered a new town!");
					}
				}
			}
		}
		
		public override function get_center():FlxPoint {
			return new FlxPoint(this.x + 49, this.y + 58);
		}
		
		
	}

}