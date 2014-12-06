package {
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	public class BaseParticle extends FlxSprite {
		public function game_update(g:GameEngineState):void { }
		public function should_remove(g:GameEngineState):Boolean { return false; }
		public function do_remove(g:GameEngineState):void { }
	}

}