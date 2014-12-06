package  
{
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	/**
	 * ...
	 * @author spotco
	 */
	public class PlayerBall extends GameObject
	{
		
		public var _engaged_in_battle:Boolean = false;
		
		public function PlayerBall() {
			this.loadGraphic(Resource.PLAYER);
		}
		
		public override function game_update(g:GameEngineState):void {
			if (_engaged_in_battle) {
				
			} else {
				this.angle = Util.RAD_TO_DEG * Math.atan2(velocity.y, velocity.x) + 90;
				this.x += velocity.x;
				this.y += velocity.y;
			}
		}
		
		public override function get_center():FlxPoint {
			return new FlxPoint(this.x + 25, this.y + 25);
		}
		
	}

}