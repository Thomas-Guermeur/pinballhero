package  {
	import flash.display.Sprite;
	import flash.ui.*;
	import flash.geom.Vector3D;
	
	import org.flixel.*;
	
	import gameobjs.BaseEnemyGameObject;
	import gameobjs.TownGameObject;
	import geom.ThickPath;

	/**
	 * ...
	 * @author spotco
	 */
	public class GameEngineState extends FlxState {
		
		public var _background_elements:FlxGroup = new FlxGroup();
		
		public var _player_balls:FlxGroup = new FlxGroup();
		public var _game_objects:FlxGroup = new FlxGroup();
		public var _healthbars:FlxGroup = new FlxGroup();
		public var _particles:FlxGroup = new FlxGroup();
		public var _current_town:TownGameObject;
		
		public var _aimretic:FlxSprite = new FlxSprite(0, 0, Resource.AIMRETIC);
		public var _walls:Array = new Array();
		public var _mountain:ThickPath;
		
		public override function create():void {
			super.update();
			
			this.add(_background_elements);
			this.add(_game_objects);
			this.add(_player_balls);
			this.add(_particles);
			this.add(_healthbars);
			this.add(_aimretic);
			
			_mountain = new ThickPath(new Array(
				new FlxPoint(0, 0),
				new FlxPoint(100, 400)
			), 50);
			_walls.push(_mountain);
			
			_background_elements.add(new FlxSprite(0, 0, Resource.TEST_BACKGROUND));
			_current_town = (TownGameObject.cons(_game_objects).init().set_centered_position(650, 250) as TownGameObject);
			_game_objects.add(_current_town);
			
			_game_objects.add(BaseEnemyGameObject.cons(_game_objects).init().set_centered_position(300, 250));
		}
		
		public override function update():void {
			super.update();
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
			if (FlxG.mouse.justPressed()) {
				var neu_ball:PlayerBall = PlayerBall.cons(_player_balls).init().set_centered_position(_current_town.get_center().x, _current_town.get_center().y) as PlayerBall;
				var dir:Vector3D = Util.normalized(FlxG.mouse.x - _current_town.get_center().x,FlxG.mouse.y - _current_town.get_center().y);
				dir.scaleBy(5);
				neu_ball.velocity.x = dir.x;
				neu_ball.velocity.y = dir.y;
			}
		}
		
	}

}