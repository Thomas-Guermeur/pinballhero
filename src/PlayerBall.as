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
		
		public var tmp = 0;
		
		public static const CELEBRATORY_TIME:int = 60;
		public static const SIGN_TIME:int = 40;
		
		public var _battling_enemies:Vector.<BaseEnemyGameObject> = new Vector.<BaseEnemyGameObject>();
		public var _visiting_landmark:Landmark = null;
		
		public var _hitpoints:Number = 20;
		public var _max_hitpoints:Number = 20;
		public var _invuln_ct:Number = 0;
		
		public function init():PlayerBall {
			this.reset(0, 0);
			_hitpoints = _max_hitpoints;
			_battling_enemies.length = 0;
			_pause_time = 0;
			_sign_time = 0;
			_attack_anim_ct = Util.float_random(_attack_anim_ct_max - 5, _attack_anim_ct_max + 5);
			_battling_enemies.length = 0;
			_visiting_landmark = null;
			visible = true;
			
			
			this.set_scale(1);
			this.play("walk");
			this.set_timestamp();
			_invuln_ct = 0;
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
			
			g._chatmanager.push_message("A hero has fallen!");
		}
		
		public function PlayerBall() {
			this.loadGraphic(Resource.PLAYER, true, false, 45, 52);
			this.addAnimation("attack", [0, 1], 5);
			this.addAnimation("walk", [2, 3], 5);
		}
		
		public var _healthbar:FlxBar;
		private function update_health_bar(g:GameEngineState):void {
			if (this._hitpoints >= _max_hitpoints) return; 
			if (_healthbar == null) {
				_healthbar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 30, 4, this, "_hitpoints", 0, _max_hitpoints);
				_healthbar.cameras = [g._gamecamera];
				g._healthbars.add(_healthbar);
			}
			_healthbar.trackParent(9, 3);
		}
		
		public function hitSign(g:GameEngineState):void {
			if (_sign_time > 0) {
				return;
			}
			_sign_time = SIGN_TIME;
			
			(GameEngineState.particle_cons(RotateFadeParticle, g._particles) as RotateFadeParticle)
				.init(_actual_position.x, _actual_position.y - 10, Resource.QUESTION)
				.p_set_delay(Util.float_random(0, 10))
				.p_set_alpha(0.8, 0)
				.p_set_velocity(0, Util.float_random(-1.2, -1))
				.p_set_ctspeed(0.01);
		}
		
		var _test = 0;
		
		public var _pause_time:int = 0;
		public var _sign_time:int = 0;
		private var _health_decr_ct:Number = 0;
		public var _launched_ct:Number = 0;
		private static var STAR_COLORS:Array = [0x80D5D5, 0xBFEAEA, 0xFFFFFF, 0x71DD55, 0xA6EA95, 0x9FDFDF, 0xF1F163];
		public override function game_update(g:GameEngineState):void {
			_invuln_ct--;
			this.update_health_bar(g);
			
			if (_visiting_landmark != null) {
				this.visible = false;
			} else {
				this.visible = true;
			}
			
			for (var i:Number = _battling_enemies.length - 1; i >= 0; i--) {
				if (!_battling_enemies[i].alive) {
					_battling_enemies.splice(i, 1);
					_pause_time = CELEBRATORY_TIME;
					play("walk");
					
					for (var j:Number = 0; j < 10; j++) {
						(GameEngineState.particle_cons(RotateFadeParticle, g._particles) as RotateFadeParticle)
							.init(_actual_position.x + Util.float_random(-50,-10), _actual_position.y + Util.float_random(-10,10), Resource.SPARKLE)
							.p_set_scale(Util.float_random(0.3, 0.5))
							.p_set_delay(Util.float_random(0, 10))
							.p_set_vr(Util.float_random( -10, 10))
							.p_set_alpha(0.8, 0)
							.p_set_velocity(0, Util.float_random(-3, -1))
							.p_set_ctspeed(0.025)
							.p_set_color(STAR_COLORS[Math.floor(Math.random()*STAR_COLORS.length)]);
					}
				}
			}
			if (_sign_time > 0) {
				_sign_time--;
			} else if (_pause_time > 0) {
				_pause_time--;
				this.update_celebrate_anim();
				
			} else if (_battling_enemies.length > 0) {
				var attack_this_frame:Boolean = attack_animation_update();
				play("attack");
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
				
			} else if (_visiting_landmark != null) {

			} else {
				_first_battle_tick = false;
				_attack_anim_ct = 0;
				//this.angle = Util.RAD_TO_DEG * Math.atan2(velocity.y, velocity.x) + 90;
				var center:FlxPoint = this.get_center();
				center.x += velocity.x;
				center.y += velocity.y;
				velocity.y += 0.135;
				this.set_centered_position(center.x, center.y);
				_launched_ct++;
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
		
		private var _first_battle_tick:Boolean = false;
		private var _attack_anim_ct:Number = 0;
		private var _attack_anim_ct_max:Number = 20;
		private var _attack_random_dir:Vector3D = new Vector3D();
		private function attack_animation_update():Boolean {
			if (_attack_anim_ct <= 0) {
				_attack_anim_ct = Util.float_random(_attack_anim_ct_max - 5, _attack_anim_ct_max + 5);
				
				if (!_first_battle_tick) {
					_attack_random_dir = Util.normalized( -velocity.x, -velocity.y);
					_attack_random_dir.scaleBy(50);
					_first_battle_tick = true;
					FlxG.shake(0.005, 0.1);
					
				} else {
					_attack_random_dir = Util.normalized(Util.float_random( -1, 1), Util.float_random( -1, 1));
					_attack_random_dir.scaleBy(10);
				}
				return true;
			} else {
				_attack_anim_ct--;
				var theta:Number = (1 - (_attack_anim_ct / _attack_anim_ct_max))*Math.PI;
				super.set_centered_position(_actual_position.x + Math.sin(theta) * _attack_random_dir.x, _actual_position.y + Math.sin(theta) * _attack_random_dir.y);
				return false;
			}
		}
		
		private function update_celebrate_anim():Boolean {		
			this.angle = 0;
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
		
		private static var TIMESTAMP_CT:Number = 0;
		public var _timestamp:Number = 0;
		private function set_timestamp():PlayerBall {
			_timestamp = TIMESTAMP_CT++;
			return this;
		}
		
		private static var _is_nth_group_sort:Vector.<PlayerBall> = new Vector.<PlayerBall>();
		public function is_nth_is_group(group:FlxGroup):Number {
			_is_nth_group_sort.length = 0;
			for (var i:Number = 0; i < group.length; i++) {
				if (group.members[i].alive) {
					_is_nth_group_sort.push(group.members[i]);
				}
			}
			_is_nth_group_sort.sort(function(a:PlayerBall, b:PlayerBall):Number {
				return a._timestamp - b._timestamp;
			});
			for (i = 0; i < _is_nth_group_sort.length; i++) {
					if (_is_nth_group_sort[i] == this) {
						_is_nth_group_sort.length = 0;
						return i;
					}
			}
			_is_nth_group_sort.length = 0;
			return -1;
		}
		
		
	}

}