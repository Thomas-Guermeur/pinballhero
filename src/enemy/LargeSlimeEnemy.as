package enemy 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author spotco
	 */
	public class LargeSlimeEnemy extends BaseEnemyGameObject
	{
		public function LargeSlimeEnemy() {
			this.loadGraphic(Resource.SLIME2);
		}
		public override function get_max_hitpoints():Number { return 15; }
		public override function get_gold_drop():Number { 
			return 10; 
		}
		public override function get_damage():Number { return 1; }
	}

}