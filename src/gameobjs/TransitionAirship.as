package gameobjs 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author spotco
	 */
	public class TransitionAirship extends FlxGroup {
		private var _ship:FlxSprite;
		private var _shadow:FlxSprite;
		public function TransitionAirship(g:GameEngineState) {
			_shadow = new FlxSprite();
			_shadow.loadGraphic(Resource.AIRSHIP_SHADOW);
			_shadow.cameras = [g._gamecamera];
			this.add(_shadow);
			
			_ship = new FlxSprite();
			_ship.loadGraphic(Resource.AIRSHIP);
			_ship.cameras = [g._gamecamera];
			this.add(_ship);
			
			_hei = 0;
			_mode = 0;
		}
		
		public var _hei:Number = 0;
		public var _hei_max:Number = 125;
		
		private var _hei_theta:Number = 0;
		
		public var _transition_t:Number = 0;
		public var _transition_initial_pos:FlxPoint = new FlxPoint();
		
		public var _pos:FlxPoint = new FlxPoint();
		public var _mode:Number = 0;
		public function set_position(x:Number, y:Number):void {
			_hei_theta += 0.1;
			_ship.set_position(x - _ship.width / 2, y - _ship.height - _hei + Math.sin(_hei_theta)*5);
			_shadow.set_scale((1 - (_hei / _hei_max))*0.3+0.5);
			_shadow.set_position(x - _shadow.width / 2, y - _shadow.height/ 2);
			_pos.x = x;
			_pos.y = y;
		}
		
	}

}