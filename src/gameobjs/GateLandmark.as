
package gameobjs 
{
	import geom.ThickPath;
	import particles.*;
	import org.flixel.*;
	/**
	 * ...
	 * @author spotco
	 */
	public class GateLandmark extends GameObject
	{
		
		public function GateLandmark() 
		{
			this.loadGraphic(Resource.GATE);
		}
		
		var _active:Boolean = true;
		var _path:ThickPath = null;
		public function init(path:ThickPath):GateLandmark {
			this.reset(0, 0);
			_active = true;
			_path = path;
			_path._on_trigger = this;
			return this;
		}
		
		public function _on_trigger(g:GameEngineState):Boolean {
			if (g._keys > 0) {
				g._keys--;
				_path._active = false;
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
				if (g._player_balls.countLiving() == 1) FlxG.shake(0.01, 0.1);
				FlxG.play(Resource.SFX_POWERUP);
				return true;
			} else {
				this.set_scale(1.6);
				return false;
			}
		}
			
		public override function game_update(g:GameEngineState):void {
			this.visible = _active;
			this.set_scale(Util.drp(this.scale.x, 1, 7));
		}
		
		private static var STAR_COLORS:Array = [0x80D5D5, 0xBFEAEA, 0xFFFFFF, 0x71DD55, 0xA6EA95, 0x9FDFDF, 0xF1F163];
	}

}