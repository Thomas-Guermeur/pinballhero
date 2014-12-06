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
		public var _current_town:TownGameObject;
		
		public var _aimretic:FlxSprite = new FlxSprite(0, 0, Resource.AIMRETIC);
		public var _walls:Array = new Array();
		public var _mountain:ThickPath;
		
		public override function create():void {
			this.add(_background_elements);
			this.add(_player_balls);
			this.add(_game_objects);
			this.add(_aimretic);
			
			_mountain = new ThickPath(new Array(
				new FlxPoint(0, 0),
				new FlxPoint(100, 400)
			), 50);
			_walls.push(_mountain);
			
			_background_elements.add(new FlxSprite(0, 0, Resource.TEST_BACKGROUND));
			_current_town = (new TownGameObject().set_centered_position(650, 250) as TownGameObject);
			_game_objects.add(_current_town);
			
			_game_objects.add(new BaseEnemyGameObject().set_centered_position(300, 250));
		}
		
		public override function update():void {
			
			for each (var itr_playerball:PlayerBall in _player_balls.members) {
				if (itr_playerball.alive) {
					itr_playerball.game_update(this);
				}
				
				for each (var wall:ThickPath in _walls) {
					wall.bounceCollision(itr_playerball);
				}
			}
			
			for each (var itr_gameobj:GameObject in _game_objects.members) {
				if (itr_gameobj.alive) {
					itr_gameobj.game_update(this);
				}
			}
			
			_aimretic.set_position(_current_town.get_center().x, _current_town.get_center().y-150);
			_aimretic.angle = Util.RAD_TO_DEG * Math.atan2(FlxG.mouse.y - _current_town.get_center().y, FlxG.mouse.x - _current_town.get_center().x) + 90;
			if (FlxG.mouse.justPressed()) {
				var neu_ball:PlayerBall = new PlayerBall().set_centered_position(_current_town.get_center().x, _current_town.get_center().y) as PlayerBall;
				var dir:Vector3D = Util.normalized(FlxG.mouse.x - _current_town.get_center().x,FlxG.mouse.y - _current_town.get_center().y);
				dir.scaleBy(5);
				neu_ball.velocity.x = dir.x;
				neu_ball.velocity.y = dir.y;
				_player_balls.add(neu_ball);
			}
		}
		
	}

}