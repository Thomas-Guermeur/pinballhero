package gameobjs 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author spotco
	 */
	public class NextHeroPopup extends FlxGroup
	{
		
		private var _bubble:FlxSprite;
		private var _toptext:FlxText;
		private var _bottomtext:FlxText;
		
		public function NextHeroPopup(g:GameEngineState) {
			_bubble = new FlxSprite(0, 0, Resource.NEXTHERO_POPUP);
			this.add(_bubble);
			_toptext = new FlxText(0, 0, 80, "NEXT");
			_toptext.color = 0x444444;
			_toptext.size = 12;
			this.add(_toptext);
			_bottomtext = new FlxText(0, 0, 120, "");
			_bottomtext.color = 0x000000;
			_bottomtext.size = 24;
			this.add(_bottomtext);
			set_alpha(0.8);
			_bubble.cameras = _toptext.cameras = _bottomtext.cameras = [g._gamecamera];
		}
		
		private var _town_pos:FlxPoint = new FlxPoint();
		private function set_town_position(x:Number, y:Number):void {
			_town_pos.x = x;
			_town_pos.y = y;
		}
		
		private function update_positions():void {
			_bubble.set_position(_town_pos.x, _town_pos.y+offset_y);
			_toptext.set_position(_town_pos.x+45, _town_pos.y+7+offset_y);
			_bottomtext.set_position(_town_pos.x+50, _town_pos.y+25+offset_y);
		}
		public function set_alpha(n:Number):void {
			_bubble.alpha = n;
			_toptext.alpha = n;
			_bottomtext.alpha = n;
		}
		public function get_alpha():Number {
			return _bubble.alpha;
		}
		
		public function game_update(g:GameEngineState) {
			this.set_town_position(g._current_town.get_center().x -68, g._current_town.get_center().y - 110);
			update_positions();
			
			theta += 0.02;
			offset_y = Math.sin(theta) * 5;
			if (_bottomtext.text != g._gold_until_next_ball + "") {
				_bottomtext.text = g._gold_until_next_ball + "";
			}
		}
		
		private var offset_y:Number = 0;
		private var theta:Number = 0;
		
	}

}