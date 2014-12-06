package  {
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import org.flixel.*;
	import flash.geom.*;
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.net.*;
	import flash.external.ExternalInterface;
	
	public class Util {

		public static var WID:Number = 1000;
		public static var HEI:Number = 500;
		
		public static const DEG_TO_RAD:Number = Math.PI / 180;
		public static const RAD_TO_DEG:Number = 180 / Math.PI;
		public static const Z_VEC:Vector3D = new Vector3D(0, 0, 1);
		public static const FLXPT_ZERO:FlxPoint = new FlxPoint(0, 0);
		
		public static var MOVE_LEFT:Vector.<String> = Vector.<String>(["A","LEFT"]);
		public static var MOVE_RIGHT:Vector.<String> = Vector.<String>(["D","RIGHT"]);
		public static var MOVE_UP:Vector.<String> = Vector.<String>(["W", "UP"]);
		public static var MOVE_DOWN:Vector.<String> = Vector.<String>(["S", "DOWN"]);
		
		public static var USE_SLOT1:Vector.<String> = Vector.<String>(["SPACE"]);
		public static var USE_SLOT2:Vector.<String> = Vector.<String>(["Z"]);
		public static var USE_SLOT3:Vector.<String> = Vector.<String>(["X"]);
		public static var USE_SLOT4:Vector.<String> = Vector.<String>(["V"]);
		
		public static function isUrl(urls:Array, stage:Stage):Boolean {
			var url:String = stage.loaderInfo.loaderURL;
			var urlStart:Number = url.indexOf("://")+3;
			var urlEnd:Number = url.indexOf("/", urlStart);
			var domain:String = url.substring(urlStart, urlEnd);
			var k1:Boolean = false;
			for (var i:int = 0; i < urls.length; i++) {
				if (domain.indexOf(urls[i]) == -1 || !(domain.indexOf(urls[i]) == domain.length -
					urls[i].length)) {
				} else {
					k1 = true;
				}
			}
			return k1;
		}
		
		public static function zoom_camera():void {
			FlxG.camera.zoom = FlxG.stage.stageWidth / 1000;
			FlxG.camera.x = (FlxG.stage.stageWidth-Util.WID)/2;
			FlxG.camera.y = (FlxG.stage.stageHeight - Util.HEI) / 2;
			FlxG.camera.antialiasing = true;
		}
		
		public static function float_random(min:Number, max:Number):Number {
			return min + Math.random() * (max - min);
		}
		
		public static function int_random(min:int, max:int):int {
			return Math.floor(float_random(min,max)) as int;
		}
		
		public static function is_key(k:Vector.<String>,jp:Boolean=false):Boolean {
			for each (var i:String in k) {
				if (jp) {
					if (FlxG.keys.justPressed(i)) {
						return true;
					}
				} else {
 					if (FlxG.keys[i]) {
						return true;
					}
				}
			}
			return false;
		}
		

		static var tf:TextField = new TextField();
		
		public static function render_text(tar:Graphics, text:String, x:Number, y:Number, fontsize:Number = 12, color:uint = 0xFFFFFF):void {
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.textColor = color;
			tf.embedFonts = true;
			tf.defaultTextFormat = new TextFormat("gamefont",fontsize);
			tf.text = text;
			
			var text_bitmap:BitmapData = new BitmapData(tf.width, tf.height, true, 0x00000000);
			text_bitmap.draw(tf);
			
			var typeTextTranslationX:Number =  x;
			var typeTextTranslationY:Number = y;
			var matrix:Matrix = new Matrix();
			matrix.translate(typeTextTranslationX, typeTextTranslationY);
			
			tar.lineStyle();
			tar.beginBitmapFill(text_bitmap, matrix, true, true);
			tar.drawRect(typeTextTranslationX, typeTextTranslationY, tf.width, tf.height);
			tar.endFill();
		}
		
		public static function get_bounds(game_obj:FlxGroup):Rectangle {
			var o:Object;
			for each (var s:FlxSprite in game_obj.members) {
				if (!o) {
					o = new Object;
					o.min_x = s.x;
					o.min_y = s.y;
					o.max_x = s.x + s.width;
					o.max_y = s.y + s.height;
				} else {
					o.min_x = Math.min(s.x,o.min_x);
					o.min_y = Math.min(s.y,o.min_y);
					o.max_x = Math.max(s.x + s.width,o.max_x);
					o.max_y = Math.max(s.y + s.height,o.max_y);
				}
			}
			return new Rectangle(o.min_x, o.min_y, o.max_x - o.min_x, o.max_y - o.min_y);
		}
		
		public static function round_dec(numIn:Number, decimalPlaces:int):Number {
			var nExp:int = Math.pow(10,decimalPlaces) ;
			var nRetVal:Number = Math.round(numIn * nExp) / nExp
			return nRetVal;
		}
		
		public static function sig_n(chk:Number,val:Number=1):Number {
			if (chk < 0) {
				return -val;
			} else if (chk > 0) {
				return val;
			} else {
				return val;
			}
		}
		
		public static function d2r(d:Number):Number {
			return d * (Math.PI / 180);
		}
		
		public static function r2d(r:Number):Number {
			return r * (180 / Math.PI);
		}
		
		public static function point_dist(ax:Number, ay:Number, bx:Number, by:Number):Number {
			return Math.sqrt(Math.pow(by - ay, 2) + Math.pow(bx - ax, 2));
		}
		
		private static var _cur_song:Sound;
		private static var _cur_play:SoundChannel;
		public static function play_bgm(o:Sound):void {
			if (_mute) {
				_cur_song = o;
				return;
			}
			if (o != _cur_song) {
				_cur_song = o;
				if (_cur_song != null && _cur_play != null ) _cur_play.stop();
				_cur_play = _cur_song.play(0, int.MAX_VALUE, new SoundTransform(0.5));
			}
		}
		
		private static var _mute:Boolean = false;
		public static function mute_toggle():void {
			_mute = !_mute;
			FlxG.mute = _mute;
			if (_mute && _cur_play != null) {
				_cur_play.stop();
			} else if (!_mute && _cur_song != null) {
				_cur_play = _cur_song.play(0, int.MAX_VALUE, new SoundTransform(0.5));
			}
			
		}
			
		public static function lerp_deg(src:Number, dest:Number, amt:Number):Number {
			var shortest_angle=((((dest - src) % 360) + 540) % 360) - 180;
			return shortest_angle * amt;
		}
		
		static var _lerp:FlxPoint = new FlxPoint(0, 0);
		public static function lerp_pos(a:FlxPoint, b:FlxPoint, t:Number):FlxPoint {
			_lerp.x = lerp(a.x, b.x, t);
			_lerp.y = lerp(a.y, b.y, t);
			return _lerp;
		}
		
		public static function drp_pos(a:FlxPoint, b:FlxPoint, div:Number):FlxPoint {
			_lerp.x = drp(a.x, b.x, div);
			_lerp.y = drp(a.y, b.y, div);
			return _lerp;
		}
		
		public static function drp(a:Number, b:Number, div:Number):Number {
			return a + (b - a) / div;
		}
		
		public static function lerp(a:Number, b:Number, t:Number):Number {
			return a + (b - a) * t;
		}
		
		public static function pt_dist(x_0:Number, y_0:Number, x_1:Number, y_1:Number):Number {
			return Math.sqrt(Math.pow(x_1 - x_0, 2) + Math.pow(y_1 - y_0, 2));
		}
		
		public static function cons_text(x:Number, y:Number, text:String, color:uint = 0xFFFFFF, font_size:int = 20, width:Number = 1000):FlxText {
			var _score:FlxText = new FlxText(x,y , width, text);
			_score.setFormat("game", font_size);
			_score.color = color;
			return _score;
		}
		
		static var _normalized:Vector3D = new Vector3D();
		public static function normalized(x:Number, y:Number):Vector3D {
			_normalized.x = x;
			_normalized.y = y;
			_normalized.z = 0;
			_normalized.normalize();
			return _normalized;
		}
		
		static var _copy:Vector3D = new Vector3D();
		public static function copy(v:Vector3D):Vector3D {
			_copy.x = v.x;
			_copy.y = v.y;
			_copy.z = v.z;
			return _copy;
		}
		
		static var _flxpt:FlxPoint = new FlxPoint();
		public static function flxpt(x:Number, y:Number):FlxPoint {
			_flxpt.x = x;
			_flxpt.y = y;
			return _flxpt;
		}
		static var _flxpt2:FlxPoint = new FlxPoint();
		public static function flxpt2(x:Number, y:Number):FlxPoint {
			_flxpt2.x = x;
			_flxpt2.y = y;
			return _flxpt2;
		}
		
		public static function pt_to_flxrotation(facing_x:Number, facing_y:Number):Number {
			return Math.atan2(facing_y, facing_x) * Util.RAD_TO_DEG;
		}
		
		static var _flxrotation_to_pt:FlxPoint = new FlxPoint(0, 0);
		public static function flxrotation_to_pt(rotation:Number):FlxPoint {
			_flxrotation_to_pt.x = Math.cos(Util.DEG_TO_RAD * rotation);
			_flxrotation_to_pt.y = Math.sin(Util.DEG_TO_RAD * rotation);
			return _flxrotation_to_pt;
		}
		
		static var _right_mouse_down:Boolean = false;
		static var _right_mouse_just_down:Boolean = false;
		public static function set_right_mouse_down(t:Boolean):void {
			_right_mouse_down = t;
			_right_mouse_just_down = t;
		}
		public static function get_right_mouse_down():Boolean {
			return _right_mouse_down;
		}
		public static function get_right_mouse_just_down():Boolean {
			var rtv:Boolean = _right_mouse_just_down;
			_right_mouse_just_down = false;
			return rtv;
		}
		
		public static function sin_lerp(min:Number, max:Number, t:Number):Number {
			t = t > 1 ? 1 : t;
			t = t < 0 ? 0 : t;
			return Util.lerp(min, max, ( -Math.cos(t * Math.PI) + 1) / 2);
		}
		
		public static var RIGHT_MOUSE_PRESSED:Boolean = false;
		public static function get_is_right_mouse_or_equiv_pressed():Boolean {
			return RIGHT_MOUSE_PRESSED || FlxG.keys.SPACE;
		}
		
	}

}