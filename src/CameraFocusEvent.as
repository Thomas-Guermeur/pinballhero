package  
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author spotco
	 */
	public class CameraFocusEvent 
	{
		public static var PRIORITY_GAMECUTSCENE:Number = 1;
		public static var PRIORITY_REGULAR:Number = 0;
		
		public var _position:FlxPoint = new FlxPoint();
		public var _priority:Number = 0;
		public var _zoom_tar:Number = 1;
		public var _ct:Number = 0;
		
		public function CameraFocusEvent(x:Number, y:Number, ct:Number, zoom:Number, priority:Number = 0) {
			this._position.x = x;
			this._position.y = y;
			this._zoom_tar = zoom;
			this._priority = priority;
			this._ct = ct;
		}
		
	}

}