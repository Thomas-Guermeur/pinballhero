package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author spotco
	 */
	public class GameEndState extends FlxState
	{
		
		public function GameEndState() 
		{
			super();
			var img:FlxSprite = new FlxSprite();
			img.makeGraphic(1000, 500, 0xFF000000);
			this.add(img);
			var text:FlxText = Util.cons_text(0, 200, "Fin", 0xFFFFFF, 64, 1000);
			text.alignment = "center"
			this.add(text);
			
			var text2:FlxText = Util.cons_text(0, 300, "Merci d'avoir joué !", 0xFFFFFF, 32, 1000);
			text2.alignment = "center"
			this.add(text2);
			Util.play_bgm(Resource.BGM_MENU);
		}
		var _ct:Number = 0;
		var _last:Boolean = true;
		public override function update():void {
			if ((!_last && FlxG.keys.any()) || FlxG.mouse.justReleased()) {
				FlxG.switchState(new MainMenuState());
				FlxG.play(Resource.SFX_POWERUP);
			}
			_last = FlxG.keys.any();
		}
	}
}
