package  
{
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;
	import gameobjs.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	/**
	 * ...
	 * @author spotco
	 */
	public class PlayerBall extends GameObject
	{
		
		public var _engaged_in_battle:Boolean = false;
		public var _battling_enemies:Vector.<BaseEnemyGameObject> = new Vector.<BaseEnemyGameObject>();
		
		public var _hitpoints:Number = 15;
		public var _max_hitpoints:Number = 15;
		
		public function PlayerBall() {
			this.loadGraphic(Resource.PLAYER);
		}
		
		private var _healthbar:FlxBar;
		private function update_health_bar(g:GameEngineState):void {
			if (this._hitpoints >= _max_hitpoints) return; 
			if (_healthbar == null) {
				_healthbar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 30, 4, this, "_hitpoints", 0, _max_hitpoints);
				g._healthbars.add(_healthbar);
			}
			_healthbar.trackParent(9, 3);
		}
		
		public override function game_update(g:GameEngineState):void {
			this.update_health_bar(g);
			
			if (_engaged_in_battle) {
				var attack_this_frame:Boolean = attack_animation_update();
				
				if (attack_this_frame) {
					for (var i:Number = _battling_enemies.length-1; i >= 0; i--) {
						_battling_enemies[i]._hitpoints--;
						break;
					}
				}
				
			} else {
				this.angle = Util.RAD_TO_DEG * Math.atan2(velocity.y, velocity.x) + 90;
				var center:FlxPoint = this.get_center();
				center.x += velocity.x;
				center.y += velocity.y;
				this.set_centered_position(center.x, center.y);
			}
		}
		
		public override function get_center():FlxPoint {
			return new FlxPoint(this.x + 25, this.y + 25);
		}
		
		private var _actual_position:FlxPoint = new FlxPoint();
		public override function set_centered_position(x:Number, y:Number):GameObject {
			_actual_position.x = x; _actual_position.y = y;
			return super.set_centered_position(x, y);
		}
		
		private var _attack_anim_ct:Number = 0;
		private var _attack_anim_ct_max:Number = 20;
		private var _attack_random_dir:Vector3D = new Vector3D();
		private function attack_animation_update():Boolean {
			if (_attack_anim_ct <= 0) {
				_attack_anim_ct = Util.float_random(_attack_anim_ct_max - 5, _attack_anim_ct_max + 5);
				_attack_random_dir = Util.normalized(Util.float_random( -1, 1), Util.float_random( -1, 1));
				this.angle = Util.RAD_TO_DEG * Math.atan2(_attack_random_dir.y,_attack_random_dir.x) + 90;
				return true;
			} else {
				_attack_anim_ct--;
				var theta:Number = (1 - (_attack_anim_ct / _attack_anim_ct_max))*Math.PI;
				super.set_centered_position(_actual_position.x + Math.sin(theta) * _attack_random_dir.x * 15, _actual_position.y + Math.sin(theta) * _attack_random_dir.y * 15);
				return false;
			}
		}
		
	}

}