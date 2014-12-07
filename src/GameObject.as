package  
{
	import org.flixel.*;
	import flash.ui.*;	
	/**
	 * ...
	 * @author spotco
	 */
	public class GameObject extends FlxSprite
	{	
		public function game_update(g:GameEngineState):void {}
		public function get_center():FlxPoint { return new FlxPoint(this.x, this.y); }
		public function set_centered_position(x:Number, y:Number):GameObject {
			var centre:FlxPoint = this.get_center();
			var off:FlxPoint = new FlxPoint(centre.x - this.x, centre.y - this.y);
			this.set_position(x - off.x, y - off.y);
			return this;
		}
		public function is_hit_game_object(other:GameObject):Boolean {
			return Util.point_dist(this.get_center().x, this.get_center().y, other.get_center().x, other.get_center().y) < (this.width + other.width) / 2;
		}
		
		public function should_remove(g:GameEngineState):Boolean { return false; }
		public function do_remove(g:GameEngineState):void { }
	}

}