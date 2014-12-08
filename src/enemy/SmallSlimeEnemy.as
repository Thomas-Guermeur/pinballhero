package enemy 
{
	/**
	 * ...
	 * @author spotco
	 */
	public class SmallSlimeEnemy  extends BaseEnemyGameObject
	{
		public function SmallSlimeEnemy() {
			this.loadGraphic(Resource.SLIME1);
		}
		public override function get_max_hitpoints():Number { return 3; }
		public override function get_gold_drop():Number { return 3; }
		public override function get_damage():Number { return 0.5; }
	}

}