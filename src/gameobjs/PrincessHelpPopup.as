package gameobjs 
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author spotco
	 */
	public class PrincessHelpPopup extends GameObject
	{
		
		public function PrincessHelpPopup() 
		{
			this.loadGraphic(Resource.PRINCESS_HELP, true, false, 101, 90);
			this.addAnimation("play", [0, 1], 3);
		}
		
		public function init():PrincessHelpPopup {	
			this.reset(0,0);
			_kill = false;
			this.play("play");
			return this;
		}
		
		private var _ct:Number = Util.float_random(5,30);
		private var _yoff:Number = 0;
		public override function game_update(g:GameEngineState):void {
			_ct++;
			_yoff = Util.drp(_yoff, 0, 5);
			if (_ct > 45) {
				_yoff = -15;
				_ct = 0;
			}
			this.set_centered_position(_castle_pos.x+40, _castle_pos.y-55+_yoff);
			this.alpha = Util.drp(this.alpha, _tar_alpha, 5);
		}
		
		public var _tar_alpha:Number = 1;
		
		public var _kill:Boolean = true;
		public override function should_remove(g:GameEngineState):Boolean {
			return _kill;
		}
		
		private var _castle_pos:FlxPoint = new FlxPoint();
		public function set_castle_pos(x:Number, y:Number):void {
			_castle_pos.x = x;
			_castle_pos.y = y;
		}
		
		
		
	}

}