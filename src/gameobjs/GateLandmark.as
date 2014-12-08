
package gameobjs 
{
	import particles.*;
	import org.flixel.*;
	/**
	 * ...
	 * @author spotco
	 */
	public class GateLandmark extends TreeLandmark
	{
		
		public function GateLandmark() 
		{
			this.loadGraphic(Resource.GATE);
		}
		
		var _active:Boolean = true;
		public override function init():TreeLandmark {
			_active = true;
			return super.init();
		}
			
		public override function game_update(g:GameEngineState):void {
			this.visible = _active;
			if (_active) {
				super.game_update(g);
			}
		}
		
		private static var STAR_COLORS:Array = [0x80D5D5, 0xBFEAEA, 0xFFFFFF, 0x71DD55, 0xA6EA95, 0x9FDFDF, 0xF1F163];
		public override function hit_player(g:GameEngineState, itr_playerball:PlayerBall):void {
			if (g._keys > 0) {
				g._keys--;
				_active = false;
				for (var j:Number = 0; j < 40; j++) {
					(GameEngineState.particle_cons(RotateFadeParticle, g._particles) as RotateFadeParticle)
						.init(get_center().x + Util.float_random(-80,80), get_center().y + Util.float_random(-80,80), Resource.SPARKLE)
						.p_set_scale(Util.float_random(0.5, 0.8))
						.p_set_delay(Util.float_random(0, 10))
						.p_set_alpha(0.8, 0)
						.p_set_vr(Util.float_random(-20,20))
						.p_set_ctspeed(0.025)
						.p_set_color(STAR_COLORS[Math.floor(Math.random()*STAR_COLORS.length)]);
				}
				FlxG.shake(0.005, 0.1);
				
			} else {
				super.hit_player(g,itr_playerball);
			}
		}
	}

}