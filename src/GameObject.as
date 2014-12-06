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
		public function game_update():void {}
		public function get_center():FlxPoint { return new FlxPoint(0, 0); }
		public function set_centered_position(x:Number, y:Number):GameObject {
			var centre:FlxPoint = this.get_center();
			var off:FlxPoint = new FlxPoint(centre.x - this.x, centre.y - this.y);
			this.set_position(x - off.x, y - off.y);
			return this;
		}
	}

}