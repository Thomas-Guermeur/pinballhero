
package gameobjs 
{
	import particles.*;
	/**
	 * ...
	 * @author spotco
	 */
	public class KeyGameObject extends GameObject
	{
		
		public function KeyGameObject() 
		{
			this.loadGraphic(Resource.KEY);
		}
		
		var _available:Boolean = false;
		public function init():KeyGameObject {
			this.reset(0, 0);
			_available = true;
			return this;
		}
		
		public override function game_update(g:GameEngineState):void {
			this.visible = _available;
			for (var i:int = 0; i < g._player_balls.length; i++) {
				var itr_playerball:PlayerBall = g._player_balls.members[i];
				if (itr_playerball.alive && _available && this.is_hit_game_object(itr_playerball)) {
					_available = false;
					g._keys++;
					
					(GameEngineState.particle_cons(RotateFadeParticle, g._particles) as RotateFadeParticle)
						.init(get_center().x, get_center().y, Resource.KEY)
						.p_set_vr(Util.float_random( -30, 30))
						.p_set_alpha(0.8, 0)
						.p_set_velocity(0,-6)
						.p_set_ctspeed(0.025);
				}
			}
		}
		
	}

}