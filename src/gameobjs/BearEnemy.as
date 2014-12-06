package gameobjs 
{
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;
	import gameobjs.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	import particles.*;
	/**
	 * ...
	 * @author spotco
	 */
	public class BearEnemy extends BaseEnemyGameObject {
		public function BearEnemy() {
			this.loadGraphic(Resource.BEAR, true, false, 88, 61);
			this.addAnimation("idle", [0, 1, 2, 3, 4, 5], 8);
		}
		
		public override function init():GameObject {
			_hitpoints = _max_hitpoints;
			_battling_heros.length = 0;
			_aoe = 1;
			
			play("idle");
			return this;
		}
	}

}