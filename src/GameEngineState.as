package  {
	import flash.display.Sprite;
	import flash.ui.*;
	import flash.geom.Vector3D;
	import gameobjs.TownLandmark;
	
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
		public var _current_town:TownLandmark;
		
		public var _aimretic:FlxSprite = new FlxSprite(0, 0, Resource.AIMRETIC);
		public var _walls:Array = new Array();
		
		public override function create():void {
			super.update();
			
			this.add(_background_elements);
			this.add(_aimretic);
			this.add(_game_objects);
			this.add(_player_balls_in_queue);
			this.add(_player_balls);
			this.add(_particles);
			this.add(_healthbars);
			
			
			var level:Object = Resource.LEVEL1_DATA_OBJECT;
			parseLevel(level);
			
			_background_elements.add(new FlxSprite(0, 0, Resource.TEST_BACKGROUND));
			_current_town = ((cons(TownLandmark, _game_objects) as TownLandmark).init().set_centered_position(650, 250) as TownLandmark);
			_game_objects.add(_current_town);
			
			_game_objects.add((cons(BaseEnemyGameObject, _game_objects) as BaseEnemyGameObject).init().set_centered_position(300, 250));
			
			for (var i:Number = 0; i < 5; i++) {
				(cons(PlayerBall, _player_balls_in_queue) as PlayerBall).init().set_centered_position(_current_town.get_center().x + 400, _current_town.get_center().y + Util.float_random( -250, 250));
			}
		}
		
		public function parseLevel(level:Object):void {
			for each (var p:Object in level.islands) {
				_walls.push(new ThickPath(new Array(
					new FlxPoint(p.x1, p.y1),
					new FlxPoint(p.x2, p.y2)
				), 50));
			}
			
			var mark:Landmark;
			for each (var obj:Object in level.objects) {
				switch (obj.type) {
				case "sign":
					mark = cons(SignLandmark, _game_objects) as Landmark;
					mark.setVector(obj.x, obj.y, obj.x2, obj.y2);
					break;
				case "inn":
					mark = cons(InnLandmark, _game_objects) as Landmark;
					mark.setVector(obj.x, obj.y);
					break;
				case "pub":
					mark = cons(PubLandmark, _game_objects) as Landmark;
					mark.setVector(obj.x, obj.y);
					break;
				}
				
				_game_objects.add(mark);
			}
		}
		
		public override function update():void {
			super.update();
			
			update_heroes_in_queue();
			
			for (var i_playerball:Number = _player_balls.length - 1; i_playerball >= 0; i_playerball--) {
				var itr_playerball:PlayerBall = _player_balls.members[i_playerball];
				if (itr_playerball.alive) {
					itr_playerball.game_update(this);
					for each (var wall:ThickPath in _walls) {
						wall.bounceCollision(itr_playerball);
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
			
			_aimretic.set_position(_current_town.get_center().x, _current_town.get_center().y-150);
			_aimretic.angle = Util.RAD_TO_DEG * Math.atan2(FlxG.mouse.y - _current_town.get_center().y, FlxG.mouse.x - _current_town.get_center().x) + 90;
			if (FlxG.mouse.justPressed() && _player_balls_in_queue.countLiving() > 0) {
				var neu_ball:PlayerBall = (cons(PlayerBall, _player_balls) as PlayerBall).init().set_centered_position(_current_town.get_center().x, _current_town.get_center().y) as PlayerBall;
				var dir:Vector3D = Util.normalized(FlxG.mouse.x - _current_town.get_center().x,FlxG.mouse.y - _current_town.get_center().y);
				dir.scaleBy(5);
				neu_ball.velocity.x = dir.x;
				neu_ball.velocity.y = dir.y;
				
				for (var i:Number = 0; i < _player_balls_in_queue.length; i++) {
					if (_player_balls_in_queue.members[i].alive) {
						_player_balls_in_queue.members[i].kill();
						break;
					}
				}
			}
			
			if (Util.is_key(Util.USE_SLOT1,true)) {
				(cons(PlayerBall, _player_balls_in_queue) as PlayerBall).init().set_centered_position(_current_town.get_center().x + 400, _current_town.get_center().y + Util.float_random( -250, 250));
			}
		}
		
		public function update_heroes_in_queue():void {
			for each(var itr:PlayerBall in _player_balls_in_queue.members) {
				var ct:Number = itr.is_nth_is_group(_player_balls_in_queue);
				if (ct == 0) {
					itr.angle = Util.RAD_TO_DEG * Math.atan2(FlxG.mouse.y - _current_town.get_center().y,FlxG.mouse.x - _current_town.get_center().x) + 90;
				}
				itr.set_centered_position(
					Util.drp(itr.get_center().x,_current_town.get_center().x + ct * 50,15),
					Util.drp(itr.get_center().y,_current_town.get_center().y, 15)
				);
			}
		}
		
		public function pickup_gold():void {
			trace("todo -- pick up gold");
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
			return rtv;
		}
		public static function particle_cons(gameClass:Class, g:FlxGroup):BaseParticle {
			var rtv:BaseParticle = g.getFirstAvailable(gameClass) as BaseParticle;
			if (rtv == null) {
				
				rtv = new gameClass();
				g.add(rtv);
			}
			return rtv;
		}
		
	}

}
