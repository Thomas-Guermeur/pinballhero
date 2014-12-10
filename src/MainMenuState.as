package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author spotco
	 */
	public class MainMenuState extends FlxState
	{
		
		public function MainMenuState() 
		{
			super();
			var img:FlxSprite = new FlxSprite(0, 0, Resource.TITLE_SCREEN);
			this.add(img);
			this.add(_text);
			Util.play_bgm(Resource.BGM_MENU);
			
		}
		var _text:FlxSprite = new FlxSprite(750, 250, Resource.TITLE_TEXT);
		var _ct:Number = 0;
		var _last:Boolean = true;
		public override function update():void {
			if ((!_last && FlxG.keys.any()) || FlxG.mouse.justReleased()) {
				FlxG.play(Resource.SFX_POWERUP);
				FlxG.switchState(new GameEngineState());
			}
			_last = FlxG.keys.any();
			_ct++;
			if (_ct > 40) {
				_ct = 0;
				_text.visible = !_text.visible;
			}
		}
		
	}

}