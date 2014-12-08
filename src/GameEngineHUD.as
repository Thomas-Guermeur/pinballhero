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
		public var _tiltText:FlxSprite;
		
		public function GameEngineHUD(g:GameEngineState) 
		{
			super.add(_gameui);
			super.add(_castle_finish_ui);
			
			_tiltBar = new FlxSprite(963, 0, Resource.HUD_TILTBAR).set_cameras([g._hudcamera]);
			_tiltBar.cameras = [g._hudcamera];
			this.add(_tiltBar);
			
			_tiltText = new FlxSprite(966, 20, Resource.HUD_TILTTEXT).set_cameras([g._hudcamera]);
			_tiltText.cameras  = [g._hudcamera];
			this.add(_tiltText);
			
			_castle_finish_bar = new FlxSprite(0, 340, Resource.CASTLE_FINISH_COVER);
			_castle_finish_bar.cameras  = [g._hudcamera];
			_castle_finish_ui.add(_castle_finish_bar);
			
			_castle_finish_text = Util.cons_text(0, 355, "", 0xFFFFFF, 24, 1000);
			_castle_finish_text.cameras = [g._hudcamera];
			_castle_finish_text.alignment = "center";
			_castle_finish_ui.add(_castle_finish_text);
			
			_castle_finish_text_scroll = new ScrollText(_castle_finish_text, "", 2);
			_castle_finish_text_scroll._chars_per_tick = 1;
			
			_gameui.visible = true;
			_castle_finish_ui.visible = false;
		}
		
		private var _animct:int = 0;
		public function game_update(g:GameEngineState):void
		{
			if (_castle_finish_ui.visible) {
				if (_castle_finish_ui_alpha < 1) {
					_castle_finish_ui_alpha += 0.1;
					_castle_finish_ui.setAll("alpha", _castle_finish_ui_alpha);
				}
				if (_castle_finish_ui_alpha > 0.8) {
					var prevf:Boolean = _castle_finish_text_scroll.finished();
					_castle_finish_text_scroll._update();
					if (_castle_finish_text_scroll.finished()) {
						if (!prevf) {
							_animct = 60;
						} else {
							_animct--;
							if (_animct < 0) {
								if (_castle_finish_ui_remaining_messages.length > 0) {
									_castle_finish_text_scroll.load(_castle_finish_ui_remaining_messages.shift());
								} else {
									g.transition_next_level();
									_castle_finish_ui.visible = false;
									_gameui.visible = true;
								}
							}
						}
					}
					
				}

				
			} else if (_gameui.visible) {
				_animct++;
				if (g._tilt_count >= g._tilt_count_max) {
					if (_animct % 20 == 0) {
						_tiltText.visible = !_tiltText.visible;
					}
					
				} else {
					_tiltText.visible = false;
				}
				update_tiltbar(g._tilt_count / g._tilt_count_max);
			}
		}
		
		public var _castle_finish_bar:FlxSprite;
		public var _castle_finish_text:FlxText;
		public var _castle_finish_text_scroll:ScrollText;
		public var _castle_finish_ui_alpha:Number = 0;
		public var _castle_finish_ui_remaining_messages:Vector.<String> = new Vector.<String>();
		
		public function show_castle_finish_message(g:GameEngineState, msgs:Array):void {
			_gameui.visible = false;
			_castle_finish_ui.visible = true;
			_castle_finish_text_scroll.load(msgs.shift());
			_castle_finish_ui.setAll("alpha", 0);
			_castle_finish_ui_alpha = 0;
			for each(var msg:String in msgs) {
				_castle_finish_ui_remaining_messages.push(msg);
			}
		}
		
		public var _gameui:FlxGroup = new FlxGroup();
		public var _castle_finish_ui:FlxGroup = new FlxGroup();
		public override function add(Object:FlxBasic):FlxBasic
		{
			return _gameui.add(Object);
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