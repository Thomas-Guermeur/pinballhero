package  
{
	import org.flixel.*;
	import flash.geom.*;
	/**
	 * ...
	 * @author spotco
	 */
	public class GameEngineHUD extends FlxGroup
	{
		
		public var _tiltBar:FlxSprite;
		public var _tiltControls:FlxSprite;
		public var _tiltText:FlxSprite;
		
		public function GameEngineHUD(g:GameEngineState) 
		{
			_tiltBar = new FlxSprite(963, 0, Resource.HUD_TILTBAR).set_cameras([g._hudcamera]);
			this.add(_tiltBar);
			
			_tiltText = new FlxSprite(966, 20, Resource.HUD_TILTTEXT).set_cameras([g._hudcamera]);
			this.add(_tiltText);
			
			_tiltControls = new FlxSprite(966, 200, Resource.HUD_TILTCONTROLS).set_cameras([g._hudcamera]);
			this.add(_tiltControls);
		}
		
		private var _animct:int = 0;
		public function game_update(g:GameEngineState):void
		{
			_animct++;
			if (g._tilt_count >= g._tilt_count_max) {
				
				_tiltControls.visible = true;
				if (_animct % 20 == 0) {
					_tiltText.visible = !_tiltText.visible;
				}
				
			} else {
				
				_tiltControls.visible = false;
				_tiltText.visible = false;
			}
			update_tiltbar(g._tilt_count / g._tilt_count_max);
		}
		
		private static var TILT_BAR:FlxSprite = new FlxSprite(0, 0, Resource.HUD_TILTBAR);
		private static var TILT_BAR_EMPTY:FlxSprite = new FlxSprite(0, 0, Resource.HUD_TILTBAR_EMPTY);
		private var _tilt_bar_pct:Number = 0;
		public function update_tiltbar(pct:Number):void {
			if (pct != _tilt_bar_pct) {
				var tar:FlxSprite = TILT_BAR;
				_tiltBar.framePixels.copyPixels(
					tar.framePixels,
					new Rectangle(0, 0, tar.width, tar.height),
					new Point(0, 0)
				);
				_tiltBar.framePixels.copyPixels(
					TILT_BAR_EMPTY.framePixels,
					new Rectangle(0, tar.height * pct, tar.width, tar.height - tar.height*pct),
					new Point(0, 0)
				);
				_tilt_bar_pct = pct;
			}
		}
		
	}

}