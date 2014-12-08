package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;
	import particles.*;
	
	/**
	 * ...
	 * @author spotco
	 */
	public class InnLandmark extends Landmark {
		
		public function InnLandmark() {
			this.loadGraphic(Resource.INN);
		}
		
		public function init():InnLandmark {
			this.landmark_init();
			return this;
		}
		
		public override function visit_finished(g:GameEngineState):void {
			for (var j:Number = 0; j < 10; j++) {
				(GameEngineState.particle_cons(RotateFadeParticle, g._particles) as RotateFadeParticle)
					.init(_visiting_player.get_center().x + Util.float_random(-50,10), _visiting_player.get_center().y + Util.float_random(-10,10), Resource.HP_SPARK)
					.p_set_scale(Util.float_random(0.9, 1.2))
					.p_set_delay(Util.float_random(0, 10))
					.p_set_alpha(0.8, 0)
					.p_set_velocity(0, Util.float_random(-3, -1))
					.p_set_ctspeed(0.025);
			}
			_visiting_player._hitpoints = _visiting_player._max_hitpoints;
			super.visit_finished(g);
		}
		
		public override function regen_duration():Number {
			return 200;
		}
		
	}

}