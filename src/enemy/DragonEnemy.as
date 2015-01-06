package enemy 
{
	/**
	 * ...
	 * @author spotco
	 */
	public class DragonEnemy extends BaseEnemyGameObject
	{
		public function DragonEnemy() {
			this.loadGraphic(Resource.DRAGON, true, false, 170, 155);
			this.addAnimation("stand", [0, 1, 2, 3,4,5,6], 5);
			this.addAnimation("attack", [0, 1, 2, 3,4,5,6], 5);
			this.play("stand");
		}
		public override function get_name():String {
			return "Super Final Boss Dragon";
		}
		public override function get_max_hitpoints():Number { return 30; }
		public override function get_gold_drop():Number { return 15; }
		public override function get_damage():Number { return 3; }
	}

}