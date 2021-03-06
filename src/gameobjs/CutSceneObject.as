package gameobjs 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author spotco
	 */
	public class CutSceneObject extends GameObject
	{
		public function init():CutSceneObject {
			this.reset(0,0);
			//this.pixels.fillRect(this.pixels.rect, 0);
			_is_talk = false;
			return this;
		}
		
		public function load_princess_anim():CutSceneObject {
			this.loadGraphic(Resource.PRINCESS);
			return this;
		}
		
		public function load_hero_anim(spawn_ct:Number):CutSceneObject {
			this.destroyAnims();
			if (spawn_ct == 0) {
				this.loadGraphic(Resource.PLAYER, true, false, 45, 52);
				this.addAnimation("walk", [2, 3], 5);
			} else if (spawn_ct == 1) {
				this.loadGraphic(Resource.PLAYER_WIZARD, true, false, 46, 48);
				this.addAnimation("walk", [0, 1], 5);
			} else if (spawn_ct == 2) {
				this.loadGraphic(Resource.PLAYER_ARCHER, true, false, 46, 73);
				this.addAnimation("walk", [0, 1], 5);
			} else {
				this.loadGraphic(Resource.PLAYER_KNIGHT, true, false, 46, 68);
				this.addAnimation("walk", [0, 1], 5);
			}
			this.play("walk");
			return this;
		}
		
		public function load_dog_anim():CutSceneObject {
			this.loadGraphic(Resource.DOG);
			return this;
		}
		
		public function load_old_man_anim():CutSceneObject {
			this.loadGraphic(Resource.OLD_MAN);
			return this;
		}
		
		public function load_bones_anim():CutSceneObject {
			this.loadGraphic(Resource.BONES);
			return this;
		}
		
		private var _actual_pos:FlxPoint = new FlxPoint();
		public var _is_talk:Boolean = false;
		public function set_talk():CutSceneObject {
			_actual_pos.x = this.x;
			_actual_pos.y = this.y;
			_is_talk = true;
			return this;
		}
		
		private var _ct:Number = 0;
		public override function game_update(g:GameEngineState):void {
			_ct++;
			if (_is_talk) {
				if (g._hud._castle_finish_ui.visible && !g._hud._castle_finish_text_scroll.finished()) {
					if (_ct % 15 == 0) {
						this.y -= 10;
					}
				}
				this.y = Util.drp(this.y, _actual_pos.y, 5);
			}
		}

		
	}

}