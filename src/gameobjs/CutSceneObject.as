package gameobjs 
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author spotco
	 */
	public class CutSceneObject extends GameObject
	{
		public function init():CutSceneObject {
			this.pixels.fillRect(this.pixels.rect, 0);
			return this;
		}
		
		public function load_princess_anim():CutSceneObject {
			this.loadGraphic(Resource.PRINCESS);
			return this;
		}
		
		public function load_hero_anim():CutSceneObject {
			this.loadGraphic(Resource.PLAYER, true, false, 45, 52);
			this.addAnimation("walk", [2, 3], 5);
			this.play("walk");
			return this;
		}

		
	}

}