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
			this.loadGraphic(Resource.CASTLE, true, false, 198, 192);
			this.addAnimation("alive", [0]);
			this.addAnimation("dead", [1]);
		}
		
		private var _castle_finished:Boolean = false;		
		private var _princess_help:PrincessHelpPopup;
		public function init(g:GameEngineState):CastleLandmark {
			this.reset(0,0);
			landmark_init();
			_princess_help = (GameEngineState.cons(PrincessHelpPopup, g._game_objects) as PrincessHelpPopup).init();
			
			_castle_finished = false;
			this.play("alive");
			_has_loaded_camera_evt = false;			
			return this;
		}
		private var _has_loaded_camera_evt:Boolean = false;
		
		public override function game_update(g:GameEngineState):void {
			if (!_has_loaded_camera_evt) {
				g._camera_focus_events.push(new CameraFocusEvent(this.get_center().x, this.get_center().y - 80, 180, 0.9, CameraFocusEvent.PRIORITY_GAMECUTSCENE));
				_has_loaded_camera_evt = true;
			}
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
		
		public override function visit_begin(g:GameEngineState, itr_playerball:PlayerBall):void {
			g._camera_focus_events.push(new CameraFocusEvent(this.get_center().x, this.get_center().y + 40, Number.POSITIVE_INFINITY, 1, CameraFocusEvent.PRIORITY_GAMECUTSCENE));
			super.visit_begin(g, itr_playerball);
		}
		
		public override function visit_finished(g:GameEngineState):void {
			var i:int = 0;
			for (i = 0; i < 30; i++) {
				(GameEngineState.particle_cons(RotateFadeParticle,g._particles) as RotateFadeParticle)
					.init(this.get_center().x + Util.float_random( -60, 60), this.get_center().y +  Util.float_random( -60, 60))
					.p_set_scale(Util.float_random(1.2, 1.8)).p_set_delay(Util.float_random(0,20));
			}
			this.play("dead");
			_castle_finished = true;
			g._camera_focus_events.push(new CameraFocusEvent(this.get_center().x, this.get_center().y + 40, Number.POSITIVE_INFINITY, 2, CameraFocusEvent.PRIORITY_GAMECUTSCENE));
			var hero:CutSceneObject = (GameEngineState.cons(CutSceneObject, g._game_objects) as CutSceneObject).init().load_hero_anim().set_centered_position(this.get_center().x-27, this.get_center().y+15) as CutSceneObject;
			hero.set_scale(1);
			var princess:CutSceneObject;
			princess = (GameEngineState.cons(CutSceneObject, g._game_objects) as CutSceneObject).init().load_dog_anim().set_centered_position(this.get_center().x + 27, this.get_center().y + 10) as CutSceneObject;
			princess.set_talk();
			princess.set_scale(1);
			g._game_objects.sort("y", FlxGroup.ASCENDING);
			g._hud.show_castle_finish_message(g, ["Woof Woof!", "(Thanks for saving me, but the princess is in another castle!)"]);
			g._current_mode = GameEngineState.MODE_CASTLE_FINISH_CUTSCENE;
			g._hud._castle_transition_start = this.get_center();
		}
		
	}

}