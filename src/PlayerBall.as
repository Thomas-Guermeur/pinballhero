package  
{
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;
	import gameobjs.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	import particles.RotateFadeParticle;
	/**
	 * ...
	 * @author spotco
	 */
	public class PlayerBall extends GameObject
	{
		public var _battling_enemies:Vector.<BaseEnemyGameObject> = new Vector.<BaseEnemyGameObject>();
		
		public var _hitpoints:Number = 15;
		public var _max_hitpoints:Number = 15;
		
		public function init():GameObject {
			_hitpoints = _max_hitpoints;
			_battling_enemies.length = 0;
			this.reset(0, 0);
			return this;
		}
		
		public override function should_remove(g:GameEngineState):Boolean {
			return this._hitpoints <= 0;
		}
		
		public override function do_remove(g:GameEngineState):void {
			if (_healthbar != null) g._healthbars.remove(_healthbar);
			_healthbar = null;
			this.kill();
			
			(GameEngineState.particle_cons(RotateFadeParticle,g._particles) as RotateFadeParticle)
			.init(this.get_center().x - 14, this.get_center().y - 22, Resource.HEROGHOST)
			.p_set_ctspeed(0.025)
			.p_set_alpha(1, 0)
			.p_set_velocity(0, Util.float_random( -0.1, -0.6));
		}
		
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
		
		private var _pause_time:Number = 0;
		public override function game_update(g:GameEngineState):void {
			this.update_health_bar(g);
			
			for (var i:Number = _battling_enemies.length - 1; i >= 0; i--) {
				if (!_battling_enemies[i].alive) {
					_battling_enemies.splice(i, 1);
					_pause_time = 60;
					
					for (var j:Number = 0; j < 10; j++) {
						(GameEngineState.particle_cons(RotateFadeParticle,g._particles) as RotateFadeParticle)
						.init(_actual_position.x + Util.float_random(-50,-10), _actual_position.y + Util.float_random(-10,10), Resource.SPARKLE)
						.p_set_scale(Util.float_random(0.2, 0.3))
						.p_set_delay(Util.float_random(0, 10))
						.p_set_vr(Util.float_random( -10, 10))
						.p_set_alpha(0.8, 0).p_set_velocity(0, Util.float_random(-3, -1))
						.p_set_ctspeed(0.05);
					}
				}
			}
			if (_pause_time > 0) {
				_pause_time--;
				this.update_celebrate_anim();
				
			} else if (_battling_enemies.length > 0) {
				var attack_this_frame:Boolean = attack_animation_update();
				if (attack_this_frame) {
					for (i = _battling_enemies.length-1; i >= 0; i--) {
						_battling_enemies[i]._hitpoints--;
						var hfp:Vector3D = new Vector3D(
							_battling_enemies[i].get_center().x - this.get_center().x,
							_battling_enemies[i].get_center().y - this.get_center().y
						);
						hfp.scaleBy(0.5);
						((GameEngineState.particle_cons(RotateFadeParticle, g._particles) as RotateFadeParticle).init(
							this.get_center().x + hfp.x + Util.float_random( -3, 3),
							this.get_center().y + hfp.y + Util.float_random( -3, 3)
						) as RotateFadeParticle).p_set_scale(Util.float_random(0.5,0.8));
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
		
		private function update_celebrate_anim() {
			this.angle = Util.drp(this.angle, Util.RAD_TO_DEG * Math.atan2(velocity.y, velocity.x) + 90, 20);			
			if (_attack_anim_ct <= 0) {
				_attack_anim_ct = Util.float_random(_attack_anim_ct_max*0.8 - 5, _attack_anim_ct_max*0.8 + 5);
				_attack_random_dir = Util.normalized(Util.float_random( -1, 1), Util.float_random( -1, 1));
				return true;
			} else {
				_attack_anim_ct--;
				var theta:Number = (1 - (_attack_anim_ct / _attack_anim_ct_max))*Math.PI;
				super.set_centered_position(_actual_position.x, _actual_position.y + Math.sin(theta) * 15);
				return false;
			}
		}
		
		public function is_nth_is_group(group:FlxGroup):Number {
			var ct:Number = 0;
			for (var i:Number = 0; i < group.length; i++) {
				if (group.members[i].alive) {
					if (group.members[i] == this) {
						return ct;
					} else {
						ct++;
					}
				}
			}
			return -1;
		}
		
	}

}