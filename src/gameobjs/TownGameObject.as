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
		
		public function TownGameObject() {
			this.loadGraphic(Resource.TOWN);
		}
		
		public override function get_center():FlxPoint {
			return new FlxPoint(this.x + 31, this.y + 31);
		}
		
	}

}