package  {
	import flash.display.Sprite;
	import flash.ui.*;
	import flash.geom.Vector3D;
	import flash.utils.getQualifiedClassName;
	import gameobjs.TownLandmark;
	import flash.geom.*;
	import mx.core.FlexApplicationBootstrap;
	import mx.core.FlexSprite;
	import org.flixel.*;
	import enemy.*;
	import com.adobe.serialization.json.*;
	import gameobjs.*;
	import geom.ThickPath;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author spotco
	 */
	public class GameEngineState extends FlxState {
		public var _background_elements:FlxGroup = new FlxGroup();
		
		public var _player_balls:FlxGroup = new FlxGroup();
		public var _player_balls_in_queue:FlxGroup = new FlxGroup();
		public var _game_objects:FlxGroup = new FlxGroup();
		public var _healthbars:FlxGroup = new FlxGroup();
		public var _particles:FlxGroup = new FlxGroup();
		public var _mountains:FlxGroup = new FlxGroup();
		public var _current_town:TownLandmark;
		public var _hud:GameEngineHUD;
		public var _next_hero_popup:NextHeroPopup;
		public var _chatmanager:ChatManager;
		public var _bgmgr:BackgroundManager;
		
		public var _aimretic_l:FlxSprite = new FlxSprite(0, 0, Resource.AIMRETIC);
		public var _aimretic_r:FlxSprite = new FlxSprite(0, 0, Resource.AIMRETIC);
		
		public var _walls:Array = new Array();
		
		public static var MODE_GAME:Number = 0;
		public static var MODE_CASTLE_FINISH_CUTSCENE:Number = 1;
		public static var MODE_AIRSHIP_TRANSITION_TO_NEXT:Number = 2;
		public static var MODE_GAME_OVER:Number = 3;
		public var _current_mode:Number = 0;
		
		public var _keys:Number = 0;
		
		static var LEVELS:Array = [Resource.LEVEL1_DATA, Resource.LEVEL2_DATA, Resource.LEVEL3_DATA, Resource.LEVEL4_DATA];
		//static var LEVELS:Array = [Resource.LEVELTEST_DATA, Resource.LEVEL2_DATA];
		
		public override function create():void {
			super.update();
			Util.play_bgm(Resource.BGM_WORLD);
			inst = this;
			_bgmgr = new BackgroundManager(this);
			_background_elements.add(_bgmgr);
			this.add(_background_elements);
			
			this.add(_mountains);
			this.add(_game_objects);
			this.add(_player_balls_in_queue);
			this.add(_player_balls);
			this.add(_particles);
			FlxG.visualDebug = false;
			
			set_zoom(1);
			_player_balls.cameras = _mountains.cameras = _aimretic_l.cameras = _aimretic_r.cameras = _game_objects.cameras = _player_balls_in_queue.cameras = _player_balls.cameras = _particles.cameras = _healthbars.cameras = [_gamecamera];
			
			parseLevel(LEVELS[_current_level], 0, 0);
			
			_hud = new GameEngineHUD(this);
			this.add(_hud);
			
			_hud.add(_aimretic_l);
			_hud.add(_aimretic_r);
			_hud.add(_healthbars);
			
			_chatmanager = new ChatManager(this);
			_chatmanager.push_message("And so our story begins...");
			_hud.add(_chatmanager);
		
			_next_hero_popup = new NextHeroPopup(this);
			_hud.add(_next_hero_popup);
			
			set_zoom(1);
			FlxG.camera.focusOn(new FlxPoint(_current_town.get_center().x, _current_town.get_center().y));
			_max_gold_until_next_ball = 5;
			_gold_until_next_ball = _max_gold_until_next_ball;
			
			_beach = new FlxSprite(_current_town.get_center().x - 1000 -727, _current_town.get_center().y - 350, Resource.BEACH_ENTRY);
			_beach.cameras = [_gamecamera];
			_beach.set_scale(2);
			this.add(_beach);
			
			_transition_airship = new TransitionAirship(this);
			_transition_airship.cameras = [_gamecamera];
			this.add(_transition_airship);
			
			if (false) {
				_transition_airship.set_position(_current_town.get_center().x - 2000, _current_town.get_center().y);
				_transition_airship._transition_initial_pos.x = _transition_airship._pos.x;
				_transition_airship._transition_initial_pos.y = _transition_airship._pos.y;
				_transition_airship._hei = _transition_airship._hei_max;
				_transition_airship._mode = 1;
				_current_mode = MODE_AIRSHIP_TRANSITION_TO_NEXT;
				_hud._gameui.visible = false;
				
				_hold_focus = 70;
				_current_focus.x = _current_town.get_center().x - 1200;
				_current_focus.y = _current_town.get_center().y;
				_current_zoom = 0.8;
				
				_initialcover = new FlxSprite();
				_initialcover.cameras = [_hudcamera];
				_initialcover.makeGraphic(1000, 500, 0xAA000000);
				this.add(_initialcover);
			} else {
				_current_mode = MODE_GAME;
				this.set_starting_balls(_current_level_starting_balls);
			}
		}
		
		var _fadeout_cover:FlxSprite;
		var _fadeout_cb:Function;
		public function make_fadeout_cover(cb:Function):void {
			_fadeout_cover = new FlxSprite();
			_fadeout_cover.cameras = [_hudcamera];
			_fadeout_cover.makeGraphic(1000, 500, 0xFF000000);
			_fadeout_cover.alpha = 0;
			_fadeout_cb = cb;
			this.add(_fadeout_cover);
		}
		
		public var _beach:FlxSprite;
		public var _initialcover:FlxSprite;
		public var _hold_focus:Number = 0;
		
		public function set_starting_balls(n:Number):void {
			for (var i:Number = 0; i < n; i++) {
				add_ball(_current_town.get_center().x + Util.float_random( -40, 40), _current_town.get_center().y + Util.float_random( -40, 40));
			}
		}
		
		public function pt_in_gamearea(x:Number, y:Number):Boolean {
			var minx:Number = Number.POSITIVE_INFINITY;
			var maxx:Number = Number.NEGATIVE_INFINITY;
			var miny:Number = Number.POSITIVE_INFINITY;
			var maxy:Number = Number.NEGATIVE_INFINITY;
			for (var i_gameobj:Number = _game_objects.length - 1; i_gameobj >= 0; i_gameobj--) {
				var itr_gameobj:GameObject = _game_objects.members[i_gameobj];
				minx = Math.min(itr_gameobj.get_center().x, minx);
				maxx = Math.max(itr_gameobj.get_center().x, maxx);
				miny = Math.min(itr_gameobj.get_center().y, miny);
				maxy = Math.max(itr_gameobj.get_center().y, maxy);
			}
			minx -= 1000;
			maxx += 1000;
			miny -= 1000;
			maxy += 1000;
			return (x > minx) && (x < maxx) && (y > miny) && (y < maxy);
		}
		
		var _last_keys_any =true;
				
		public override function update():void {
			super.update();
			/*
			if (Util.is_key(Util.USE_SLOT3, true)) {
				for each(var itr:PlayerBall in _player_balls_in_queue.members) {
					itr.kill();
				}
			}
			if (Util.is_key(Util.USE_SLOT4, true)) {
				_hud._castle_transition_start.x = _current_town.get_center().x;
				_hud._castle_transition_start.y = _current_town.get_center().y;
				transition_next_level();
			}
			*/
			
			
			if (_initialcover != null) {
				_initialcover.alpha -= 0.1;
				if (_initialcover.alpha <= 0) {
					this.remove(_initialcover);
					_initialcover = null;
				}
			}
			if (_fadeout_cover != null) {
				_fadeout_cover.alpha += 0.025;
				if (_fadeout_cover.alpha >= 1) {
					_fadeout_cb();
				}
			}
			
			if (_current_mode == MODE_GAME) {
				if (_beach != null) {
					this.remove(_beach);
					_beach = null;
				}
				_next_hero_popup.game_update(this);
				update_heroes_in_queue();
				update_camera();
				update_aimretic();
				_chatmanager.game_update(this);
				_bgmgr.game_update(this);
				update_tilt();			
				update_particles();
				if (!_cutscene_camera_event) {
					update_shoot_ball();
				}
				update_bonus_balls();
				_hud.game_update(this);
				if (_player_balls.countLiving() <= 0 && _player_balls_in_queue.countLiving() <= 0) {
					_current_mode = MODE_GAME_OVER;
					_hud.game_over();
				}
				update_gameobjs();
				
			} else if (_current_mode == MODE_GAME_OVER) {
				_hud.game_update(this);
				update_gameobjs();
				update_particles();
				if ((FlxG.keys.any() && !_last_keys_any) || FlxG.mouse.justReleased()) {
					FlxG.switchState(new GameEngineState());
					FlxG.play(Resource.SFX_POWERUP);
				}
				_last_keys_any = FlxG.keys.any();
				
			} else if (_current_mode == MODE_CASTLE_FINISH_CUTSCENE) {
				_hud.game_update(this);
				update_camera();
				update_gameobjs();
				update_particles();
				
			} else if (_current_mode == MODE_AIRSHIP_TRANSITION_TO_NEXT) {
				_hud.game_update(this);
				update_camera();
				_bgmgr.game_update(this);
				update_particles();
				
				if (_transition_airship._mode == 0) {
					_transition_airship._hei += 3;
					_transition_airship.set_position(_transition_airship._pos.x, _transition_airship._pos.y);
					if (_transition_airship._hei > _transition_airship._hei_max) {
						_transition_airship._mode = 1;
						_transition_airship._transition_t = 0;
						_transition_airship._transition_initial_pos.x = _transition_airship._pos.x;
						_transition_airship._transition_initial_pos.y = _transition_airship._pos.y;
					}
				} else if (_transition_airship._mode == 1) {
					_transition_airship._transition_t += 0.005;
					var neu_pos:FlxPoint =  Util.lerp_pos(_transition_airship._transition_initial_pos, _current_town.get_center(), _transition_airship._transition_t);
					_transition_airship.set_position(neu_pos.x, neu_pos.y);
					if (_transition_airship._transition_t >= 1) {
						_transition_airship._mode = 2;
					}
				} else if (_transition_airship._mode == 2) {
					_transition_airship._hei -= 3;
					_transition_airship.set_position(_transition_airship._pos.x, _transition_airship._pos.y);
					if (_transition_airship._hei <= 0) {
						_current_mode = MODE_GAME;
						this.remove(_transition_airship);
						
						for (var i_gameobj:Number = _game_objects.length - 1; i_gameobj >= 0; i_gameobj--) {
							var itr_gameobj:GameObject = _game_objects.members[i_gameobj];
							if (itr_gameobj._level == _current_level) continue;
							if (itr_gameobj.alive) itr_gameobj.kill();
						}
						for (var i_mtn:Number = _mountains.length - 1; i_mtn >= 0; i_mtn--) {
							if (_mountains.members[i_mtn] == null) continue;
							if (_mountains.members[i_mtn]._level == _current_level) continue;
							_mountains.remove(_mountains.members[i_mtn]);
						}
						if (_chatmanager._messages.length == 0) _chatmanager.push_message("And so the heroes arrived in a new region.");
						set_starting_balls(_current_level_starting_balls);
						_hud._gameui.visible = true;
						FlxG.play(Resource.SFX_POWERUP);
					}
				}
			}
		}
		
		private var _transition_airship:TransitionAirship;
		private var _level_offset:FlxPoint = new FlxPoint();
		
		public function transition_next_level():void {
			_current_level = (_current_level + 1) % LEVELS.length;
			if (_current_level == 0) {
				make_fadeout_cover(function() {
					FlxG.switchState(new GameEndState());
				});
				return;
			}
			FlxG.play(Resource.SFX_POWERUP);
			_level_offset.x += 1500;
			_level_offset.y += 1000 * (_current_level%2==0?-1:1);
			_chatmanager.clear_messages();
			
			for (var i_playerball:Number = _player_balls.length - 1; i_playerball >= 0; i_playerball--) {
				var itr_playerball:PlayerBall = _player_balls.members[i_playerball];
				if (itr_playerball._level == _current_level) continue;
				if (itr_playerball.alive) itr_playerball.kill();
			}
			for each(var itr:PlayerBall in _player_balls_in_queue.members) {
				itr.kill();
			}
			for (var i_hp:Number = _healthbars.length - 1; i_hp >= 0; i_hp--) {
				_healthbars.remove(_healthbars.members[i_hp]);
			}
			for (var i_particle:Number = _particles.length - 1; i_particle >= 0; i_particle--) {
				var itr_particle:BaseParticle = _particles.members[i_particle];
				if (itr_particle.alive) itr_particle.kill();
			}
			for (var i_wall:Number = _walls.length-1; i_wall >= 0; i_wall--) {
				if (_walls[i_wall]._level == _current_level) continue;
				_walls.splice(i_wall, 1);
			}
			for (var i_gameobj:Number = _game_objects.length - 1; i_gameobj >= 0; i_gameobj--) {
				var itr_gameobj:GameObject = _game_objects.members[i_gameobj];
				if (itr_gameobj._level == _current_level || itr_gameobj is Landmark) continue;
				if (itr_gameobj.alive) itr_gameobj.kill();
			}
			
			_hold_mouse_ct = 0;
			_camera_focus_events.length = 0;
			
			if (_transition_airship != null) this.remove(_transition_airship);
			_transition_airship = new TransitionAirship(this);
			this.add(_transition_airship);
			
			_transition_airship.set_position(_hud._castle_transition_start.x,_hud._castle_transition_start.y+30);
			parseLevel(LEVELS[_current_level], _level_offset.x, _level_offset.y);
			_current_mode = MODE_AIRSHIP_TRANSITION_TO_NEXT;
		}
		
		public static var ZOOM_CONST:Number = 0.3;
		public var _gamecamera:FlxCamera = null;
		public var _hudcamera:FlxCamera = null;
		public function set_zoom(zoom_scale:Number):void {
			var neu_camera:FlxCamera;
			if (_gamecamera == null) {
				neu_camera = new FlxCamera(0, 0, 1000 / ZOOM_CONST, 500 / ZOOM_CONST);
				neu_camera.antialiasing = true;
			} else {
				neu_camera = FlxG.camera;
			}
					
			neu_camera.zoom = zoom_scale;
			
			neu_camera.x = ((1000 * ZOOM_CONST) - 1000) / 2 / ZOOM_CONST;
			neu_camera.y = ((500 * ZOOM_CONST) - 500) / 2 / ZOOM_CONST;
			if (_gamecamera == null) {
				FlxG.resetCameras(neu_camera);
				_gamecamera = neu_camera;
				
				_hudcamera = new FlxCamera(0, 0, 1000, 500);
				_hudcamera.bgColor = 0x00000000;
				FlxG.addCamera(_hudcamera);
			}
		}
		
		private var _current_zoom:Number = 1;
		private var _current_focus:FlxPoint = new FlxPoint();
		private var _hold_mouse_ct:Number = 0;
		private var _hold_mouse_ct_max:Number = 75;
		public var _camera_focus_events:Vector.<CameraFocusEvent> = new Vector.<CameraFocusEvent>();
		private var _cutscene_camera_event:Boolean = false;
		private function update_camera():void {
			var tar_focus:FlxPoint = new FlxPoint(_current_focus.x, _current_focus.y);
			var tar_zoom:Number = _current_zoom;
			var drpf:Number = 10;
			var magn:Number = Util.point_dist(Util.smouse_x(), Util.smouse_y(), 1000 / 2, 500 / 2);
			var dir:Vector3D = Util.normalized(Util.smouse_x() - 1000 / 2, Util.smouse_y() - 500 / 2);
			
			var camera_focus_events_cutscene:Vector.<CameraFocusEvent> = new Vector.<CameraFocusEvent>();
			var camera_focus_events_regular:Vector.<CameraFocusEvent> = new Vector.<CameraFocusEvent>();
			for(var ci:int = _camera_focus_events.length - 1; ci >= 0; ci-- ) {
				var c:CameraFocusEvent = _camera_focus_events[ci];
				c._ct--;
				if (c._ct <= 0) {
					_camera_focus_events.splice(ci, 1);
				} else if (c._priority == CameraFocusEvent.PRIORITY_GAMECUTSCENE) {
					camera_focus_events_cutscene.push(c);
				} else if (c._priority == CameraFocusEvent.PRIORITY_REGULAR) {
					camera_focus_events_regular.push(c);
				}
			}
			_cutscene_camera_event = false;
			if (_hold_focus > 0) {
				_hold_focus--;
				tar_zoom = _current_zoom;
				
			} else if (_current_mode == MODE_AIRSHIP_TRANSITION_TO_NEXT) {
				tar_zoom = 1 - 0.3 * (_transition_airship._hei / _transition_airship._hei_max);
				tar_focus.x = _transition_airship._pos.x - 118/2;
				tar_focus.y = _transition_airship._pos.y - _transition_airship._hei - 92/2;
				
				
			} else if (camera_focus_events_cutscene.length > 0) {
				var c:CameraFocusEvent = camera_focus_events_cutscene.shift();
				tar_focus.x = c._position.x;
				tar_focus.y = c._position.y;
				tar_zoom = c._zoom_tar;
				drpf = 30;
				_cutscene_camera_event = true;
				
			} else if (FlxG.mouse.pressed() && _player_balls_in_queue.countLiving() > 0) {
				_hold_mouse_ct = Math.min(_hold_mouse_ct+1,_hold_mouse_ct_max);
				var scf:Number = _hold_mouse_ct / _hold_mouse_ct_max;
				magn = (magn / 600) * (300 + scf*500);
				dir.scaleBy(magn);
				tar_focus.x = _current_town.get_center().x + dir.x;
				tar_focus.y = _current_town.get_center().y + dir.y;
				tar_zoom = 1;
				
			} else if (camera_focus_events_regular.length > 0) {
				var c:CameraFocusEvent = camera_focus_events_regular.shift();
				tar_focus.x = c._position.x;
				tar_focus.y = c._position.y;
				tar_zoom = c._zoom_tar;
				drpf = 30;
				
			} else if (_player_balls.countLiving() == 1) {
				for (var i:Number = 0; i < _player_balls.length; i++) {
					var itr:PlayerBall = _player_balls.members[i];
					if (itr.alive) {
						tar_focus.x = itr.get_center().x;
						tar_focus.y = itr.get_center().y;
					}
				}
				tar_zoom = 1;
				
			} else if (_player_balls.countLiving() > 0) {
				var cx:Number = 0;
				var cy:Number = 0;
				var ct:Number = 0;
				var minx:Number = Number.POSITIVE_INFINITY; 
				var miny:Number = Number.POSITIVE_INFINITY;
				var maxx:Number = Number.NEGATIVE_INFINITY; 
				var maxy:Number = Number.NEGATIVE_INFINITY;
				
				for (var i:Number = 0; i < _player_balls.length; i++) {
					var itr:PlayerBall = _player_balls.members[i];
					if (itr.alive) {
						cx += itr.get_center().x;
						cy += itr.get_center().y;
						minx = Math.min(minx, itr.get_center().x);
						miny = Math.min(miny, itr.get_center().y);
						maxx = Math.max(maxx, itr.get_center().x);
						maxy = Math.max(maxy, itr.get_center().y);
						ct++;
					}
				}
				cx /= ct;
				cy /= ct;
				tar_focus.x = cx;
				tar_focus.y = cy;
				var max_dist:Number = Math.max(maxx - minx, (maxy-miny) * 2);
				max_dist = Math.max(max_dist - 200, 0);
				max_dist = Math.min(max_dist, 1500);
				tar_zoom = 1 - max_dist / 1500 * 0.6;
				
			} else {
				magn = (magn / 600) * 300;
				dir.scaleBy(magn);
				tar_focus.x = _current_town.get_center().x + dir.x;
				tar_focus.y = _current_town.get_center().y + dir.y;
				tar_zoom = 1;
			}
			_current_focus = Util.drp_pos(_current_focus, tar_focus, drpf);
			_current_zoom = Util.drp(_current_zoom, tar_zoom, 30);
			
			FlxG.camera.focusOn(_current_focus);
			set_zoom(_current_zoom);
		}
		
		public var _gold_until_next_ball:Number;
		public var _max_gold_until_next_ball:Number;
		public function add_ball(x:Number, y:Number):void {
			var pb:PlayerBall = (cons(PlayerBall, _player_balls_in_queue) as PlayerBall).init().set_centered_position(x, y) as PlayerBall;
			pb._level = _current_level;
		}
		
		private function update_bonus_balls():void {
			if (_gold_until_next_ball <= 0) {
				add_ball(_current_town.get_center().x + Util.float_random(-100,100), _current_town.get_center().y + Util.float_random( -100, 100));
				_max_gold_until_next_ball += 5;
				_gold_until_next_ball = _max_gold_until_next_ball;
				_chatmanager.push_message("A new hero has joined the battle!");
				FlxG.play(Resource.SFX_POWERUP);
			}
		}
		
		private function update_shoot_ball():void {
			if (FlxG.mouse.justReleased() && _player_balls_in_queue.countLiving() > 0) {
				var neu_ball:PlayerBall = (cons(PlayerBall, _player_balls) as PlayerBall).init().set_centered_position(_current_town.get_center().x, _current_town.get_center().y) as PlayerBall;
				neu_ball._launched_ct = 0;
				var dir:Vector3D = Util.normalized(Util.wmouse_x() - _current_town.get_center().x, Util.wmouse_y() - _current_town.get_center().y);
				var scf:Number = _hold_mouse_ct / _hold_mouse_ct_max;
				dir.scaleBy(2 + 9 * scf);
				_hold_mouse_ct = 0;
				neu_ball.velocity.x = dir.x;
				neu_ball.velocity.y = dir.y;
				
				for (var i:Number = 0; i < _player_balls_in_queue.length; i++) {
					if (_player_balls_in_queue.members[i].alive) {
						_player_balls_in_queue.members[i].kill();
						break;
					}
				}
				_chatmanager.push_message("A hero sets out on his quest!");
				FlxG.play(Resource.SFX_BULLET4);
			}
		}
		
		private function update_particles():void {
			for (var i_particle:Number = _particles.length - 1; i_particle >= 0; i_particle--) {
				var itr_particle:BaseParticle = _particles.members[i_particle];
				if (itr_particle.alive) {
					itr_particle.game_update(this)
					if (itr_particle.should_remove(this)) itr_particle.do_remove(this);
				}
			}
		}
		
		private function update_gameobjs():void {
			for (var i_gameobj:Number = _game_objects.length - 1; i_gameobj >= 0; i_gameobj--) {
				var itr_gameobj:GameObject = _game_objects.members[i_gameobj];
				if (itr_gameobj.alive) {
					itr_gameobj.game_update(this);
					if (itr_gameobj.should_remove(this)) itr_gameobj.do_remove(this);
				}
			}
			for (var i_playerball:Number = _player_balls.length - 1; i_playerball >= 0; i_playerball--) {
				var itr_playerball:PlayerBall = _player_balls.members[i_playerball];
				if (itr_playerball.alive) {
					if (itr_playerball._battling_enemies.length == 0 && itr_playerball._pause_time <= 0) {
						var bounce:Boolean = false;
						for each (var wall:ThickPath in _walls) {
							bounce = bounce || wall.bounceCollision(itr_playerball,this);
						}
						if (bounce) {
							bounce = false;
							for each (var wall:ThickPath in _walls) {
								bounce = bounce || wall.bounceCollision(itr_playerball,this);
							}
							if (bounce) {
								itr_playerball.velocity.x = 0;
								itr_playerball.velocity.y = 0;
							}
						}
					}
					itr_playerball.game_update(this);
					if (itr_playerball.should_remove(this)) itr_playerball.do_remove(this);
				}
			}
		}
		
		public var _tilt_count:Number = 100;
		public var _tilt_count_max:Number = 100;
		private function update_tilt():void {
			var tilt_up:Boolean = Util.is_key(Util.MOVE_UP, true);
			var tilt_down:Boolean = Util.is_key(Util.MOVE_DOWN, true);
			var tilt_left :Boolean = Util.is_key(Util.MOVE_LEFT, true);
			var tilt_right:Boolean = Util.is_key(Util.MOVE_RIGHT, true);
			if ((tilt_down || tilt_left || tilt_right || tilt_up) && _tilt_count >= _tilt_count_max) {
				
				FlxG.play(Resource.SFX_ROCKBREAK);
				
				for (var i_playerball:Number = _player_balls.length - 1; i_playerball >= 0; i_playerball--) {
					var itr_playerball:PlayerBall = _player_balls.members[i_playerball];
					if (!itr_playerball.alive) continue;
					itr_playerball._pause_time = 0;
					if (itr_playerball._battling_enemies.length == 0 && itr_playerball._visiting_landmark == null) {
						if (tilt_left) {
							if (itr_playerball.velocity.x > 0) itr_playerball.velocity.x *= 0.5;
							itr_playerball.velocity.x -= 7;
						} else if (tilt_right) {
							if (itr_playerball.velocity.x < 0) itr_playerball.velocity.x *= 0.5;
							itr_playerball.velocity.x += 7;
						} else if (tilt_up) {
							if (itr_playerball.velocity.y > 0) itr_playerball.velocity.y *= 0.5;
							itr_playerball.velocity.y -= 10;
						} else if (tilt_down) {
							if (itr_playerball.velocity.y < 0) itr_playerball.velocity.y *= 0.5;
							itr_playerball.velocity.y += 7;
						}
					}
				}
				FlxG.shake(0.01, 0.2);
				_tilt_count = 0;
			} else if (_tilt_count < _tilt_count_max) {
				_tilt_count++;
			}
		}
		
		private function update_heroes_in_queue():void {
			for each(var itr:PlayerBall in _player_balls_in_queue.members) {
				var ct:Number = itr.is_nth_is_group(_player_balls_in_queue);
				var theta:Number = Math.PI*0.2 * ct;
				var dist:Number = Math.sqrt(ct) * 15 + 12;
				if (Util.point_dist(
					itr.get_center().x, 
					itr.get_center().y, 
					_current_town.get_center().x + Math.sin(theta)*dist, 
					_current_town.get_center().y + Math.cos(theta)*dist) > 20) {
					itr.set_scale(1);
				} else {
					var tar_scale:Number = 0.2 + 0.8 * (1 / (ct + 1));
					itr.set_scale(Util.drp(itr.scale.x, tar_scale, 10));
				}
				
				
				if (ct == 0) {
					itr.set_centered_position(
						Util.drp(itr.get_center().x,_current_town.get_center().x, 15),
						Util.drp(itr.get_center().y,_current_town.get_center().y, 15)
					);
				} else {					
					itr.set_centered_position(
						Util.drp(itr.get_center().x,_current_town.get_center().x + Math.sin(theta)*dist, 15),
						Util.drp(itr.get_center().y,_current_town.get_center().y + Math.cos(theta)*dist, 15)
					);
				}
			}
		}
		
			public function update_aimretic():void {
			_aimretic_l.set_position(_current_town.get_center().x, _current_town.get_center().y - 150);
			_aimretic_r.set_position(_current_town.get_center().x, _current_town.get_center().y - 150);
						
			var next_hero_popup_tar_alpha:Number = 1;
			if (FlxG.mouse.pressed() && _player_balls_in_queue.countLiving() > 0) {
				var pct:Number = _hold_mouse_ct / _hold_mouse_ct_max;

				_aimretic_l.angle = Util.RAD_TO_DEG * Math.atan2(Util.wmouse_y() - _current_town.get_center().y, Util.wmouse_x() - _current_town.get_center().x) + 90 + 45 * (1-pct);
				_aimretic_r.angle = Util.RAD_TO_DEG * Math.atan2(Util.wmouse_y() - _current_town.get_center().y, Util.wmouse_x() - _current_town.get_center().x) + 90 - 45 * (1-pct);
				
				_aimretic_l.alpha = pct*pct;
				_aimretic_l.visible = true;
				_aimretic_r.alpha = pct*pct;
				_aimretic_r.visible = true;
				_aimretic_l.set_scale( 1 + 0.75 * (1 - pct));
				_aimretic_r.set_scale(1 + 0.75 * (1 - pct));
				next_hero_popup_tar_alpha = 0;
			} else {
				_aimretic_l.visible = false;
				_aimretic_r.visible = false;
				next_hero_popup_tar_alpha = Util.pt_dist(Util.smouse_x(),Util.smouse_y(),500,250)/300 + 0;
			}
			_next_hero_popup.set_alpha(Util.drp(_next_hero_popup.get_alpha(),next_hero_popup_tar_alpha,10));
			if (_aimretic_l.visible && !_last_aimretic_visible) FlxG.play(Resource.SFX_SPIN);
			_last_aimretic_visible = _aimretic_l.visible;
		}
		var _last_aimretic_visible = true;
		
		public function pickup_gold():void {
			_gold_until_next_ball--;
		}
		
		public static var _current_level:Number = 0;
		public var _current_level_starting_balls:Number = 3;
		public function parseLevel(level:Object, offsetx:Number, offsety:Number):void {
			level = JSON.decode((new level as ByteArray).toString());
			_max_gold_until_next_ball = level.start_x;
			_gold_until_next_ball = _max_gold_until_next_ball;
			_current_level_starting_balls = level.start_y;
			for each (var p:Object in level.islands) {
				var tp:ThickPath = new ThickPath(new Array(
					new FlxPoint(p.x1 + offsetx, -p.y1 + offsety),
					new FlxPoint(p.x2 + offsetx, -p.y2 + offsety)
				), 30);
				tp._level = _current_level;
				_walls.push(tp);
				
				var tmp:MountainRange = new MountainRange();
				tmp.cameras = _mountains.cameras;
				tmp.init(tp);
				tmp._level = _current_level;
				_mountains.add(tmp);
			}
			
			var mark:GameObject;
			
			
			for each (var obj:Object in level.objects) {
				var objx:Number = obj.x + offsetx;
				var objy:Number = -obj.y + offsety;
				
				switch (obj.type) {
					case "townstart":
						mark = _current_town = ((cons(TownLandmark, _game_objects) as TownLandmark).init().set_centered_position(objx,objy) as TownLandmark);
						break;
					case "castle":
						mark = (cons(CastleLandmark, _game_objects) as CastleLandmark).init(this).set_centered_position(objx,objy);
						break;
					case "inn":
						mark = (cons(InnLandmark, _game_objects) as InnLandmark).init().set_centered_position(objx,objy);
						break;
					case "pub":
						mark = (cons(PubLandmark, _game_objects) as PubLandmark).init().set_centered_position(objx,objy);
						break;
					case "tree":
						mark = (cons(TreeLandmark, _game_objects) as TreeLandmark).init().set_centered_position(objx,objy);
						break;
					case "gate":
						/*mark = (cons(GateLandmark, _game_objects) as GateLandmark).init().set_centered_position(objx, objy);
						mark.angle = Util.RAD_TO_DEG * Math.atan2( -obj.dir.y, obj.dir.x);*/
						
						var dirby:FlxPoint = new FlxPoint(obj.dir.x, -obj.dir.y);
						dirby.x *= 100;
						dirby.y *= 100;
						
						var pt1:FlxPoint = new FlxPoint(objx+dirby.x, objy+dirby.y);
						var pt2:FlxPoint = new FlxPoint(objx-dirby.x, objy-dirby.y);
						
						var tp:ThickPath = new ThickPath(new Array(
							pt1,
							pt2
						), 30);
						tp._level = _current_level;
						_walls.push(tp);
						
						mark = (cons(GateLandmark, _game_objects) as GateLandmark).init(tp).set_centered_position(objx, objy);
						mark.angle = Util.RAD_TO_DEG * Math.atan2( -obj.dir.y, obj.dir.x);
						
						break;
					case "key":
						mark = (cons(KeyGameObject, _game_objects) as KeyGameObject).init().set_centered_position(objx, objy);
						break;
					case "tutorial_launch":
						var cso:CutSceneObject = (GameEngineState.cons(CutSceneObject, _game_objects) as CutSceneObject).init();
						cso.loadGraphic(Resource.TUTORIAL_LAUNCH);
						cso.set_centered_position(objx, objy);
						mark = cso;
						break;
					case "tutorial_tilt":
						var cso:CutSceneObject = (GameEngineState.cons(CutSceneObject, _game_objects) as CutSceneObject).init();
						cso.loadGraphic(Resource.TUTORIAL_TILT);
						cso.set_centered_position(objx, objy);
						mark = cso;
						break;
					case "town":
						mark = ((cons(TownLandmark, _game_objects) as TownLandmark).init().set_centered_position(objx,objy) as TownLandmark);
						break;
						
					case "smallslime":
						mark = (cons(SmallSlimeEnemy, _game_objects) as BaseEnemyGameObject).init().set_centered_position(objx,objy);
						break;
					case "largeslime":
						mark = (cons(LargeSlimeEnemy, _game_objects) as BaseEnemyGameObject).init().set_centered_position(objx,objy);
						break;
					case "fox":
						mark = (cons(FoxEnemy, _game_objects) as BaseEnemyGameObject).init().set_centered_position(objx,objy);
						break;
					case "bear":
						mark = (cons(BearEnemy, _game_objects) as BaseEnemyGameObject).init().set_centered_position(objx,objy);
						break;
					case "dragon":
						mark = (cons(DragonEnemy, _game_objects) as BaseEnemyGameObject).init().set_centered_position(objx,objy);
						break;
				}
				if (mark != null) mark._level = _current_level;
			}
			
		}
		
		public static var inst:GameEngineState;
		public static function cons(gameClass:Class, g:FlxGroup):GameObject {
			var rtv:GameObject = g.getFirstAvailable(gameClass) as GameObject;
			if (rtv == null) {
				
				rtv = new gameClass();
				g.add(rtv);
			}
			rtv.cameras = g.cameras;
			rtv._level = _current_level;
			return rtv;
		}
		public static function particle_cons(gameClass:Class, g:FlxGroup):BaseParticle {
			var rtv:BaseParticle = g.getFirstAvailable(gameClass) as BaseParticle;
			if (rtv == null) {
				
				rtv = new gameClass();
				g.add(rtv);
			}
			rtv.cameras = g.cameras;
			return rtv;
		}
		
	}

}
