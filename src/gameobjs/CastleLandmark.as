package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	import particles.*;
	
	/**
	 * ...
	 * @author spotco
	 */
	public class CastleLandmark extends Landmark {
		
		public function CastleLandmark() {
			this.loadGraphic(Resource.CASTLE, true, false, 131, 163);
			this.addAnimation("alive", [0]);
			this.addAnimation("dead", [1]);
		}
		
		private var _castle_finished:Boolean = false;		
		private var _princess_help:PrincessHelpPopup;
		public function init(g:GameEngineState):CastleLandmark {
			landmark_init();
			_princess_help = (GameEngineState.cons(PrincessHelpPopup, g._game_objects) as PrincessHelpPopup).init();
			_castle_finished = false;
			this.play("alive");
			return this;
		}
		
		public override function get_center():FlxPoint {
			return new FlxPoint(this.x + 65.5, this.y + 81.5);
		}
		
		public override function game_update(g:GameEngineState):void {
			_princess_help.set_castle_pos(this.get_center().x, this.get_center().y);
			if (_respawn_duration > 0 || _visiting_player != null || _castle_finished) {
				_princess_help._tar_alpha = 0;
			} else {
				_princess_help._tar_alpha = 1;
			}
			if (_castle_finished) {
				this.set_scale(1);
				this.alpha = 1;
				
				
			} else {
				super.game_update(g);
			}
		}
		
		public override function visit_finished(g:GameEngineState):void {
			var i:int = 0;
			for (i = 0; i < 20; i++) {
				(GameEngineState.particle_cons(RotateFadeParticle,g._particles) as RotateFadeParticle)
					.init(this.get_center().x + Util.float_random( -60, 60), this.get_center().y +  Util.float_random( -60, 60))
					.p_set_scale(Util.float_random(1.2, 1.8)).p_set_delay(Util.float_random(0,10));
			}
			this.play("dead");
			_castle_finished = true;
			
			var hero:CutSceneObject = (GameEngineState.cons(CutSceneObject, g._game_objects) as CutSceneObject).init().load_hero_anim().set_centered_position(this.get_center().x-27, this.get_center().y+25) as CutSceneObject;
			hero.set_scale(1);
			var princess:CutSceneObject = (GameEngineState.cons(CutSceneObject, g._game_objects) as CutSceneObject).init().load_dog_anim().set_centered_position(this.get_center().x+27, this.get_center().y+20) as CutSceneObject;
			princess.set_talk();
			princess.set_scale(1);
			g._camera_focus_events.push(new CameraFocusEvent(this.get_center().x, this.get_center().y + 40, Number.POSITIVE_INFINITY, 2, CameraFocusEvent.PRIORITY_GAMECUTSCENE));
			g._hud.show_castle_finish_message(g,["Woof Woof!","(Thanks for saving me, but the princess is in another castle!)"]);
		}
		
	}

}