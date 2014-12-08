package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;
	import particles.*;
	
	/**
	 * ...
	 * @author spotco
	 */
	public class PubLandmark extends Landmark {
		
		public function PubLandmark() {
			this.loadGraphic(Resource.PUB);
		}
		
		public function init():PubLandmark {
			this.landmark_init();
			return this;
		}
		
		private static var STAR_COLORS:Array = [0x80D5D5, 0xBFEAEA, 0xFFFFFF, 0x71DD55, 0xA6EA95, 0x9FDFDF, 0xF1F163];
		public override function visit_finished(g:GameEngineState):void {
			for (var j:Number = 0; j < 20; j++) {
				(GameEngineState.particle_cons(RotateFadeParticle, g._particles) as RotateFadeParticle)
					.init(_visiting_player.get_center().x + Util.float_random(-80,30), _visiting_player.get_center().y + Util.float_random(-50,30), Resource.SPARKLE)
					.p_set_scale(Util.float_random(0.5, 0.8))
					.p_set_delay(Util.float_random(0, 10))
					.p_set_alpha(0.8, 0)
					.p_set_vr(Util.float_random(-20,20))
					.p_set_ctspeed(0.025)
					.p_set_color(STAR_COLORS[Math.floor(Math.random()*STAR_COLORS.length)]);
			}
			
			var speed:Number = Util.pt_dist(_visiting_player.velocity.x,_visiting_player.velocity.y,0,0);
			var radians:Number = Math.atan2(_visiting_player.velocity.y, _visiting_player.velocity.x);
			
			var rad1:Number = Math.PI / 4 + radians;
			var rad2:Number = -Math.PI / 4 + radians;
			
			_visiting_player.velocity.y = speed * Math.sin(rad1);
			_visiting_player.velocity.x = speed * Math.cos(rad1);
			
			var buddy:PlayerBall = (GameEngineState.cons(PlayerBall, g._player_balls) as PlayerBall).init();
			buddy._launched_ct = _visiting_player._launched_ct;
			buddy.x = _visiting_player.x;
			buddy.y = _visiting_player.y;
			buddy.velocity.x = speed * Math.cos(rad2);
			buddy.velocity.y = speed * Math.sin(rad2);
			
			super.visit_finished(g);
		}
		
		public override function regen_duration():Number {
			return 1000;
		}
	}

}