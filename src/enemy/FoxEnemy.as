package enemy 
{
	/**
	 * ...
	 * @author spotco
	 */
	public class FoxEnemy  extends BaseEnemyGameObject
	{
		public function FoxEnemy() {
			this.loadGraphic(Resource.FOX,true,false,71,76);
			this.addAnimation("stand", [5,6,7,8], 5);
			this.addAnimation("attack", [0, 1, 2, 3], 5);
			this.play("stand");
		}
		public override function get_max_hitpoints():Number { return 5; }
		public override function get_gold_drop():Number { return 5; }
		public override function get_damage():Number { return 1; }
	}

}