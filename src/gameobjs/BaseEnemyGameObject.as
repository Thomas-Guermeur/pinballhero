package gameobjs 
{
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;
	import gameobjs.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	import particles.*;
	/**
	 * ...
	 * @author spotco
	 */
	public class BaseEnemyGameObject extends GameObject {
		
		public var _battling_heros:Vector.<PlayerBall> = new Vector.<PlayerBall>();
		
		public var _hitpoints:Number = 5;
		public var _max_hitpoints:Number = 5;
		
		public static function cons(g:FlxGroup):BaseEnemyGameObject {
			var rtv:BaseEnemyGameObject = g.getFirstAvailable(BaseEnemyGameObject) as BaseEnemyGameObject;
			if (rtv == null) {
				rtv = new BaseEnemyGameObject();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function init():BaseEnemyGameObject {
			_hitpoints = _max_hitpoints;
			_battling_heros.length = 0;
			return this;
		}
		
		public function BaseEnemyGameObject() {
			this.loadGraphic(Resource.ENEMY);
		}
		
		public override function get_center():FlxPoint {
			return new FlxPoint(this.x + 22.5, this.y + 22.5);
		}
		
		public override function is_hit_game_object(other:GameObject):Boolean {
			return Util.point_dist(this.get_center().x, this.get_center().y, other.get_center().x, other.get_center().y) < 30;
		}
		
		public override function should_remove(g:GameEngineState):Boolean {
			return this._hitpoints <= 0;
		}
		
		public override function do_remove(g:GameEngineState):void {
			if (_healthbar != null) g._healthbars.remove(_healthbar);
			_healthbar = null;
			this.kill();
		}
		
		private var _healthbar:FlxBar;
		private function update_health_bar(g:GameEngineState):void {
			if (this._hitpoints >= _max_hitpoints) return; 
			if (_healthbar == null) {
				
				_healthbar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 60, 4, this, "_hitpoints", 0, _max_hitpoints);
				g._healthbars.add(_healthbar);
			}
			_healthbar.trackParent(-5, -7);
		}
		
		public override function game_update(g:GameEngineState):void {
			this.update_health_bar(g);
			
			for (var i:Number = _battling_heros.length - 1; i >= 0; i--) {
				if (!_battling_heros[i].alive) _battling_heros.splice(i, 1);
			}
			
			for each (var itr_playerball:PlayerBall in g._player_balls.members) {
				if (itr_playerball.alive && this.is_hit_game_object(itr_playerball)) {
					if (itr_playerball._battling_enemies.indexOf(this) == -1) {
						_battling_heros.push(itr_playerball);
						itr_playerball._battling_enemies.push(this);
					}
				}
			}
			
			if (_battling_heros.length > 0) {
				var attack_this_frame:Boolean = attack_animation_update();
				
				if (attack_this_frame) {
					for (var i:Number = _battling_heros.length-1; i >= 0; i--) {
						_battling_heros[i]._hitpoints--;
						var hfp:Vector3D = new Vector3D(_battling_heros[i].get_center().x - this.get_center().x, _battling_heros[i].get_center().y - this.get_center().y);
						hfp.scaleBy(0.75);
						RotateFadeParticle.cons(g._particles)
						.init(this.get_center().x + hfp.x + Util.float_random( -3, 3), this.get_center().y + hfp.y + Util.float_random( -3, 3))
						.p_set_scale(Util.float_random(0.8, 1));
						break;
					}
				}
			}
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
				FlxG.shake(0.005, 0.1);
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