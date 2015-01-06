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
		
		private static var NAMES = [
			"Townsend",
			"Bloomingdale",
			"Medina",
			"Cornelia",
			"Midgard",
			"Balamb",
			"Zanarkand",
			"Nibelheim",
			"Besaid",
			"Gaia",
			"Tokyo-3",
			"Nalbina",
			"Narche",
			"Rabanastre",
			"Lindblum",
			"Eruyt",
			"Lunatic Pandora",
			"Alexandria",
			"Baron",
			"Sacae",
			"Cyrodil",
			"Figaro"
		];
		
		private var name:String = "";
		public function init():TownLandmark {
			this.reset(0,0);
			landmark_init();
			name = NAMES[Math.floor(Util.float_random(0, NAMES.length - 1))];
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
						g.add_ball(itr_playerball.get_center().x,itr_playerball.get_center().y,itr_playerball._spawn_ct);
						g._chatmanager.push_message(itr_playerball.get_name() + " has returned back to the town of "+name+".");
					}
				}
			} else {
				for (var i:int = 0; i < g._player_balls.length; i++) {
					var itr_playerball:PlayerBall = g._player_balls.members[i];
					if (itr_playerball.alive && itr_playerball._launched_ct > 50 && this.is_hit_game_object(itr_playerball)) {
						g._current_town = this;
						g._chatmanager.push_message("Discovered the town of "+name+"!");
						FlxG.play(Resource.SFX_POWERUP);
					}
				}
			}
		}
		
		public override function get_center():FlxPoint {
			return new FlxPoint(this.x + 49, this.y + 58);
		}
		
		
	}

}