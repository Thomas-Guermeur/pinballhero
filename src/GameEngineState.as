package  {
	import flash.display.Sprite;
	import flash.ui.*;
	import flash.geom.Vector3D;
	import gameobjs.TownLandmark;
	import flash.geom.*;
	import org.flixel.*;
	
	import gameobjs.*;
	import geom.ThickPath;

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
		
		public override function create():void {
			super.update();
			
			this.add(_background_elements);
			this.add(_mountains);
			this.add(_game_objects);
			this.add(_player_balls_in_queue);
			this.add(_player_balls);
			this.add(_particles);

			
			
			
			
			FlxG.visualDebug = false;
			
			set_zoom(1);
			_player_balls.cameras = _mountains.cameras = _aimretic_l.cameras = _aimretic_r.cameras = _game_objects.cameras = _player_balls_in_queue.cameras = _player_balls.cameras = _particles.cameras = _healthbars.cameras = [_gamecamera];
			
			var level:Object = Resource.LEVEL2_DATA_OBJECT;
			parseLevel(level);
			
			_bgmgr = new BackgroundManager(this);
			_background_elements.add(_bgmgr);
			
			for (var i:Number = 0; i < 3; i++) {
				(cons(PlayerBall, _player_balls_in_queue) as PlayerBall).init().set_centered_position(_current_town.get_center().x + 400, _current_town.get_center().y + Util.float_random( -250, 250));
			}
			
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
			_max_gold_until_next_ball = 15;
			_gold_until_next_ball = _max_gold_until_next_ball;
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
			
			if (camera_focus_events_cutscene.length > 0) {
				var c:CameraFocusEvent = camera_focus_events_cutscene.shift();
				_current_focus.x = c._position.x;
				_current_focus.y = c._position.y;
				tar_zoom = c._zoom_tar;
				drpf = 30;
				
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
				_current_focus.x = c._position.x;
				_current_focus.y = c._position.y;
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
				var max_dist:Number = Math.max(Math.abs(maxy - miny), Math.abs(maxx - minx));
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
		
		public override function update():void {
			super.update();
			
			_hud.game_update(this);
			_next_hero_popup.game_update(this);
			update_heroes_in_queue();
			update_camera();
			update_aimretic();
			_chatmanager.game_update(this);
			_bgmgr.game_update(this);
			
			for (var i_playerball:Number = _player_balls.length - 1; i_playerball >= 0; i_playerball--) {
				var itr_playerball:PlayerBall = _player_balls.members[i_playerball];
				if (itr_playerball.alive) {
					itr_playerball.game_update(this);
					if (itr_playerball._battling_enemies.length == 0 && itr_playerball._pause_time <= 0) {
						for each (var wall:ThickPath in _walls) {
							wall.bounceCollision(itr_playerball,this);
						}
					}
					if (itr_playerball.should_remove(this)) itr_playerball.do_remove(this);
				}
			}
			
			for (var i_gameobj:Number = _game_objects.length - 1; i_gameobj >= 0; i_gameobj--) {
				var itr_gameobj:GameObject = _game_objects.members[i_gameobj];
				if (itr_gameobj.alive) {
					itr_gameobj.game_update(this);
					if (itr_gameobj.should_remove(this)) itr_gameobj.do_remove(this);
				}
			}
			
			for (var i_particle:Number = _particles.length - 1; i_particle >= 0; i_particle--) {
				var itr_particle:BaseParticle = _particles.members[i_particle];
				if (itr_particle.alive) {
					itr_particle.game_update(this)
					if (itr_particle.should_remove(this)) itr_particle.do_remove(this);
				}
			}
			
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
			}
			
			if (_gold_until_next_ball <= 0) {
				add_ball(_current_town.get_center().x + 400, _current_town.get_center().y + Util.float_random( -250, 250));
				_max_gold_until_next_ball += 5;
				_gold_until_next_ball = _max_gold_until_next_ball;
				_chatmanager.push_message("A new hero has joined the battle!");
				
				_camera_focus_events.push(new CameraFocusEvent(_current_town.get_center().x, _current_town.get_center().y+40, 30, 1.1));
			}
			
			update_tilt();
		}
		public var _gold_until_next_ball:Number;
		public var _max_gold_until_next_ball:Number;
		
		public function add_ball(x:Number, y:Number):void {
			(cons(PlayerBall, _player_balls_in_queue) as PlayerBall).init().set_centered_position(x,y);
		}
		
		public var _tilt_count:Number = 100;
		public var _tilt_count_max:Number = 100;
		public function update_tilt():void {
			var tilt_up:Boolean = Util.is_key(Util.MOVE_UP, true);
			var tilt_down:Boolean = Util.is_key(Util.MOVE_DOWN, true);
			var tilt_left :Boolean = Util.is_key(Util.MOVE_LEFT, true);
			var tilt_right:Boolean = Util.is_key(Util.MOVE_RIGHT, true);
			if ((tilt_down || tilt_left || tilt_right || tilt_up) && _tilt_count >= _tilt_count_max) {
				for (var i_playerball:Number = _player_balls.length - 1; i_playerball >= 0; i_playerball--) {
					var itr_playerball:PlayerBall = _player_balls.members[i_playerball];
					if (itr_playerball.alive && itr_playerball._battling_enemies.length == 0 && itr_playerball._visiting_landmark == null) {
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
		
		public function update_heroes_in_queue():void {
			for each(var itr:PlayerBall in _player_balls_in_queue.members) {
				var ct:Number = itr.is_nth_is_group(_player_balls_in_queue);
				var theta:Number = Math.PI*0.2 * ct;
				var dist:Number = Math.sqrt(ct) * 15 + 12;
				if (Util.point_dist(
					itr.get_center().x, 
					itr.get_center().y, 
					_current_town.get_center().x + Math.sin(theta)*dist, 
					_current_town.get_center().y + Math.cos(theta)*dist) > 10) {
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
		
		public function pickup_gold():void {
			_gold_until_next_ball--;
		}
		
		public function parseLevel(level:Object):void {
			for each (var p:Object in level.islands) {
				var tp:ThickPath = new ThickPath(new Array(
					new FlxPoint(p.x1, -p.y1),
					new FlxPoint(p.x2, -p.y2)
				), 30);
				
				_walls.push(tp);
				// wrap mountains in FlxSprite
				var tmp:MountainRange = new MountainRange();
				tmp.cameras = _mountains.cameras;
				tmp.init(tp);
				_mountains.add(tmp);
			}
			
			var mark:GameObject;
			for each (var obj:Object in level.objects) {
				var objx:Number = obj.x;
				var objy:Number = -obj.y;
				
				switch (obj.type) {
				case "1upobject":
					mark = _current_town = ((cons(TownLandmark, _game_objects) as TownLandmark).init().set_centered_position(objx,objy) as TownLandmark);
					break;
				case "birdflock":
					mark = (cons(BaseEnemyGameObject, _game_objects) as BaseEnemyGameObject).init().set_centered_position(objx,objy);
					break;
				case "coin":
					mark = (cons(CastleLandmark, _game_objects) as CastleLandmark).init(this).set_centered_position(objx,objy);
					break;
					
				/*	
				case "sign": //make negative !!!!
					mark = cons(SignLandmark, _game_objects);
					(mark as Landmark).setVector(obj.x, obj.y, obj.x2, obj.y2);
					break;
				case "rotatingsign":
					mark = cons(RotatingSignLandmark, _game_objects);
					(mark as Landmark).setVector(obj.x, obj.y, obj.x2, obj.y2);
					break;
				case "inn":
					mark = cons(InnLandmark, _game_objects);
					(mark as Landmark).setVector(obj.x, obj.y);
					break;
				case "pub":
					mark = cons(PubLandmark, _game_objects);
					(mark as Landmark).setVector(obj.x, obj.y);
					break;
				case "tree":
					mark = cons(TreeLandmark, _game_objects);
					(mark as Landmark).setVector(obj.x, obj.y);
					break;
				case "bear":
					mark = (cons(BearEnemy, _game_objects) as BaseEnemyGameObject).init().set_centered_position(obj.x, obj.y);
					break;
				case "patrollingenemy":
					mark = (cons(PatrollingEnemy, _game_objects) as BaseEnemyGameObject).init().set_centered_position(obj.x, obj.y);
					break;
				case "aoeenemy":
					mark = cons(BaseEnemyGameObject, _game_objects);
					var bgo:BaseEnemyGameObject = mark as BaseEnemyGameObject;
					bgo.init().set_centered_position(obj.x, obj.y);
					bgo.setAOE(5);
					break;
				case "death":
					mark = cons(DeathLandmark, _game_objects);
					(mark as Landmark).setVector(obj.x, obj.y);
					break;
				*/
				}
				_game_objects.add(mark);
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
		}
		
		/**
		 * Pool together objects of the given class for reuse
		 */
		public static function cons(gameClass:Class, g:FlxGroup):GameObject {
			var rtv:GameObject = g.getFirstAvailable(gameClass) as GameObject;
			if (rtv == null) {
				
				rtv = new gameClass();
				g.add(rtv);
			}
			rtv.cameras = g.cameras;
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
