package  {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	public class ChatManager extends FlxGroup {
		
		var _text:FlxText;
		var _text_scroll:ScrollText;
		
		var _chat_cover:FlxSprite = new FlxSprite(0, 500 - 30, Resource.CHAT_COVER);
		public function ChatManager(g:GameEngineState) {
			_chat_cover.cameras = [g._hudcamera];
			this.add(_chat_cover);
			
			_text = Util.cons_text(10,473, "", 0xFFFFFF, 20, 1000);
			_text.cameras = _chat_cover.cameras;
			this.add(_text);
			
			_text_scroll = new ScrollText(_text, "", 1);
		}
		
		
		public var _messages:Vector.<String> = new Vector.<String>();
		public function push_message(msg:String):void {
			while (_messages.length > 4)_messages.shift();
			_messages.push(msg);
		}
		
		public function clear_messages():void {
			_messages.length = 0;
			_text_scroll.clear();
			_chat_cover.alpha = 0;
			_text.alpha = 0;
		}
		
		var _chat_cover_vis_mlt:Number = 1;
		public var _spd:Number = 50;
		var _ct:Number = 0;
		public function game_update(g:GameEngineState):void {
			if (_ct <= 0 && _messages.length > 0 && _text_scroll.finished()) {
				_text_scroll.load(_messages.shift());
				
			} else if (_text_scroll.finished()) {
				_ct--;
				if (_messages.length > 0 && _ct > 60) _ct = 60;
				if (_ct <= 60) {
					_chat_cover.alpha -= 0.1;
					_text.alpha -= 0.1;
					_chat_cover.alpha *= _chat_cover_vis_mlt;
				}
			} else {
				_chat_cover.alpha = 1;
				_text.alpha = 1;
				if (_messages.length > 0) {
					_ct = 100;
				} else {
					_ct = 200;
				}
				_text_scroll._update();
				_chat_cover.alpha *= _chat_cover_vis_mlt;
			}
		}
		
	}

}