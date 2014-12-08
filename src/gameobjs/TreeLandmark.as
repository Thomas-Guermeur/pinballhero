package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	
	/**
	 * ...
	 * @author spotco
	 */
	public class TreeLandmark extends Landmark {
		
		public function TreeLandmark() {
			this.loadGraphic([Resource.TREEBUMPER,Resource.TREEBUMPER2,Resource.TREEBUMPER3][Util.int_random(0,3)]);
		}
		
		public function init():TreeLandmark {
			this.reset(0, 0);
			_cooldown = { };
			return this;
		}
		
		var _cooldown = { };
		public override function game_update(g:GameEngineState):void {
			this.set_scale(Util.drp(this.scale.x, 1, 10));
			for (var key:String in _cooldown) {
				_cooldown[key] = _cooldown[key] - 1;
			}
			for (var i:int = 0; i < g._player_balls.length; i++) {
				var itr_playerball:PlayerBall = g._player_balls.members[i];
				if (!itr_playerball.alive) continue;
				if (!_cooldown[itr_playerball._timestamp + ""]) {
					_cooldown[itr_playerball._timestamp + ""] = 0;
				}
				if (this.is_hit_game_object(itr_playerball) && _cooldown[itr_playerball._timestamp+""] <= 0) {
					
					hit_player(g, itr_playerball);
					
					break;
				}
			}
		}
		
		public function hit_player(g:GameEngineState, itr_playerball:PlayerBall):void {
			_cooldown[itr_playerball._timestamp] = 10;
			this.set_scale(1.7);
			if (g._player_balls.countLiving() == 1) FlxG.shake(0.001, 0.1);
			
			var speed:Number = Util.pt_dist(itr_playerball.velocity.x,itr_playerball.velocity.y,0,0);
			
			var velocityRad:Number = Math.atan2(itr_playerball.velocity.y, itr_playerball.velocity.x);
			var collideRad:Number = Math.atan2(itr_playerball.get_center().y - get_center().y, itr_playerball.get_center().x - get_center().x) + Math.PI / 2;
			
			var radians:Number = -velocityRad + 2 * collideRad;
			itr_playerball.velocity.x = speed * Math.cos(radians);
			itr_playerball.velocity.y = speed * Math.sin(radians);
			itr_playerball._hitpoints--;
		}
	}

}