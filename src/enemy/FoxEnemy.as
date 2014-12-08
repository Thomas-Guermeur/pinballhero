package enemy 
{
	/**
	 * ...
	 * @author spotco
	 */
	public class FoxEnemy  extends BaseEnemyGameObject
	{
		public function FoxEnemy() {
			this.loadGraphic(Resource.FOX);
		}
		public override function get_max_hitpoints():Number { return 5; }
		public override function get_gold_drop():Number { return 5; }
		public override function get_damage():Number { return 1; }
	}

}