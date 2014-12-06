package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	
	/**
	 * ...
	 * @author spotco
	 */
	public class TownGameObject extends GameObject
	{
		
		public static function cons(g:FlxGroup):TownGameObject {
			var rtv:TownGameObject = g.getFirstAvailable(TownGameObject) as TownGameObject;
			if (rtv == null) {
				rtv = new TownGameObject();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function init():TownGameObject {
			return this;
		}
		
		public function TownGameObject() {
			this.loadGraphic(Resource.TOWN);
		}
		
		public override function get_center():FlxPoint {
			return new FlxPoint(this.x + 31, this.y + 31);
		}
		
	}

}