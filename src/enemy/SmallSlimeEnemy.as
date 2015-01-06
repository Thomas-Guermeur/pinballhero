package enemy 
{
	/**
	 * ...
	 * @author spotco
	 */
	public class SmallSlimeEnemy  extends BaseEnemyGameObject
	{
		public function SmallSlimeEnemy() {
			this.loadGraphic(Resource.SLIME1,true,false,53,59);
			this.addAnimation("stand", [0,1,2,1], 5);
			this.addAnimation("attack", [0, 1, 2, 1], 15);
			this.play("stand");
		}
		public override function get_name():String {
			return "Generic Slime";
		}
		public override function get_max_hitpoints():Number { return 4; }
		public override function get_gold_drop():Number { return 3; }
		public override function get_damage():Number { return 1; }
	}

}