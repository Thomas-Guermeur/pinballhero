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
	public class PatrollingEnemy extends BaseEnemyGameObject {
		
		private var outbound:Boolean = true;
		private var start:FlxPoint, end:FlxPoint;
		
		public function init():PatrollingEnemy {
			this.reset(0,0);
			return this;
		}
		
		public function patrolTo(px:Number, py:Number):void {
			start.x = x;
			start.y = y;
			end.x = px;
			end.y = py;
		}
		
		public override function game_update(g:GameEngineState):void {
			super.game_update(g);
			
			var rad:Number;
			if (outbound) {
				if (Util.point_dist(end.x, end.y, x, y) < width) {
					outbound = false;
					
					rad = Math.atan2(end.y - y, end.x - x);
					velocity.x = Math.cos(rad);
					velocity.y = Math.sin(rad);
				}
			}
			else {
				if (Util.point_dist(start.x, start.y, x, y) < width) {
					outbound = true;
					
					rad = Math.atan2(start.y - y, start.x - x);
					velocity.x = Math.cos(rad);
					velocity.y = Math.sin(rad);
				}
			}
		}
	}

}