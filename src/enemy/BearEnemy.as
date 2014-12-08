package enemy 
{
	/**
	 * ...
	 * @author spotco
	 */
	public class BearEnemy extends BaseEnemyGameObject {
		public function BearEnemy() {
			this.loadGraphic(Resource.BEAR);
		}
		public override function get_max_hitpoints():Number { return 12; }
		public override function get_gold_drop():Number { return 10; }
		public override function get_damage():Number { return 2; }
	}

}