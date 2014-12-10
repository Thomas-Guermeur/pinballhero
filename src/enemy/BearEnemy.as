package enemy 
{
	/**
	 * ...
	 * @author spotco
	 */
	public class BearEnemy extends BaseEnemyGameObject {
		public function BearEnemy() {
			this.loadGraphic(Resource.BEAR, true, false, 95, 71);
			this.addAnimation("stand", [0, 1, 2, 3], 5);
			this.addAnimation("attack", [4, 5, 6, 7, 8],5);
			this.play("stand");
		}
		public override function get_max_hitpoints():Number { return 12; }
		public override function get_gold_drop():Number { return 10; }
		public override function get_damage():Number { return 2; }
	}

}