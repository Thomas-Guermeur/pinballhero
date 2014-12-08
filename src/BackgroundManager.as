package  
{
	import flash.display.Sprite;
	import flash.net.FileReferenceList;
	import flash.ui.*;
	import flash.geom.Vector3D;
	import gameobjs.TownLandmark;
	import flash.geom.*;
	import org.flixel.*;
	public class BackgroundManager extends FlxGroup {
		
		private static var TILE_WID:int = 512;
		private static var TILE_HEI:int = 512;
		
		private var _background_tiles = { };
		private var _background_keys:Vector.<String> = new Vector.<String>();
		
		public function BackgroundManager(g:GameEngineState) {
		}
		
		public function game_update(g:GameEngineState):void {
			var keys:Vector.<String> = get_all_viewed_keys(g);
			var i:int;
			var key:String;
			for (i = 0; i < keys.length; i++) {
				key = keys[i];
				var xc:Number = Number(key.split("_")[0]) * TILE_WID;
				var yc:Number = Number(key.split("_")[1]) * TILE_HEI;
				if (_background_tiles[key] == null) {
					_background_tiles[key] = cons_tile(xc, yc, g);
				}
				if (_background_keys.indexOf(key) == -1) _background_keys.push(key);
				var spr:FlxSprite = _background_tiles[key];
				if (!spr.alive) {
					spr.revive();
				}
			}
			
			for (i = _background_keys.length - 1; i >= 0; i-- ) {
				key = _background_keys[i];
				var sprite:FlxSprite = _background_tiles[key];
				if (keys.indexOf(key) == -1) {
					_background_keys.splice(i, 1);
					sprite.kill();
					
				}
			}
		}
		
		public function get_all_viewed_keys(g:GameEngineState):Vector.<String> {
			var center_x:Number = FlxG.camera.scroll.x - FlxG.camera.x + 1000/2;
			var center_y:Number = FlxG.camera.scroll.y - FlxG.camera.y + 500/2;
			
		
			var view_rect = {
				x1: center_x - 1200,
				y1: center_y - 1000,
				x2: center_x + 1200,
				y2: center_y + 1000
			}
			var rtv:Vector.<String> = new Vector.<String>();
			
			var x:int = int(view_rect.x1/TILE_WID)*TILE_WID - TILE_WID;
			for (; x < view_rect.x2; x += TILE_WID) {
				for (var y:int = int(view_rect.y1/TILE_HEI)*TILE_HEI - TILE_HEI; y < view_rect.y2; y += TILE_HEI) {
					var xk:int = x / TILE_WID;
					var yk:int = y / TILE_HEI;
					rtv.push(background_tile_key(xk, yk));
				}
			}
			
			return rtv;
		}
		
		public function background_tile_key(x:int, y:int):String {
			return x + "_" + y;
		}
		
		public function cons_tile(x:Number,  y:Number, g:GameEngineState):FlxSprite {
			var tmp:FlxSprite = new FlxSprite(x, y, Resource.CHERCKERTILE);
			tmp.cameras = [g._gamecamera];
			this.add(tmp);
			return tmp;
		}
		
	}

}