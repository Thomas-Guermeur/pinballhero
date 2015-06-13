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
			this.loadGraphic(Resource.SLIME2,true,false,104,78);
			this.addAnimation("stand", [0,1,2,1], 5);
			this.addAnimation("attack", [0, 1, 2, 1], 15);
			this.play("stand");
		}
		public override function get_name():String {
			return "Un grobaveux furieux";
		}
		public override function get_max_hitpoints():Number { return 15; }
		public override function get_gold_drop():Number { 
			return 10; 
		}
		public override function get_damage():Number { return 1; }
	}

}
