package enemy 
{
	/**
	 * ...
	 * @author spotco
	 */
	public class DragonEnemy extends BaseEnemyGameObject
	{
		public function DragonEnemy() {
			this.loadGraphic(Resource.DRAGON);
		}
		public override function get_max_hitpoints():Number { return 30; }
		public override function get_gold_drop():Number { return 15; }
		public override function get_damage():Number { return 3; }
	}

}