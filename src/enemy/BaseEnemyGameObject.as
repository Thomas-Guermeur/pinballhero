package enemy 
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
		
		public function BaseEnemyGameObject() {
			this.loadGraphic(Resource.SLIME1);
		}
		public function get_max_hitpoints():Number { return 5; }
		public function get_gold_drop():Number { return 5; }
		public function get_damage():Number { return 1; }
		
		public var _battling_heros:Vector.<PlayerBall> = new Vector.<PlayerBall>();		
		public var _hitpoints:Number = 5;
		
		// the number of people the enemy will damage at once
		public var _aoe:int = 1;
		
		public function init():GameObject {
			this.reset(0,0);
			_hitpoints = get_max_hitpoints();
			_battling_heros.length = 0;
			_aoe = 1;
			return this;
		}
		
		public function setAOE(count:Number):void {
			_aoe = count;
		}
		
		public override function should_remove(g:GameEngineState):Boolean {
			return this._hitpoints <= 0;
		}
		
		public override function do_remove(g:GameEngineState):void {
			if (_healthbar != null) g._healthbars.remove(_healthbar);
			_healthbar = null;
			this.kill();
			
			g._chatmanager.push_message("Monster has been slain!");
			
			for (var i:Number = 0; i < get_gold_drop(); i++) {
				(GameEngineState.cons(GoldPickup, g._game_objects) as GoldPickup).init(this.get_center().x + Util.float_random(-10,10), this.get_center().y + Util.float_random(-10,10));
			}
		}
		
		private var _healthbar:FlxBar;
		private function update_health_bar(g:GameEngineState):void {
			if (this._hitpoints >= get_max_hitpoints()) return; 
			if (_healthbar == null) {
				
				_healthbar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, this.width, 6, this, "_hitpoints", 0, get_max_hitpoints());
				_healthbar.cameras = [g._gamecamera];
				g._healthbars.add(_healthbar);
			}
			_healthbar.trackParent(0, 0);
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
					var count:int = 0;
					for (i = _battling_heros.length-1; i >= 0; i--) {
						_battling_heros[i]._hitpoints-=get_damage();
						var hfp:Vector3D = new Vector3D(_battling_heros[i].get_center().x - this.get_center().x, _battling_heros[i].get_center().y - this.get_center().y);
						hfp.scaleBy(0.75);
						
						(GameEngineState.particle_cons(RotateFadeParticle,g._particles) as RotateFadeParticle)
						.init(this.get_center().x + hfp.x + Util.float_random( -3, 3), this.get_center().y + hfp.y + Util.float_random( -3, 3))
						.p_set_scale(Util.float_random(0.8, 1));
						
						count++;
						if (count >= _aoe) {
							break;
						}
					}
				}
			} else {
				_attack_anim_ct = Util.float_random(_attack_anim_ct_max - 4, _attack_anim_ct_max + 4);
				_first_battle_tick = false;
				_attack_anim_ct = 0;
			}
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
				_attack_anim_ct = Util.float_random(_attack_anim_ct_max - 4, _attack_anim_ct_max + 4);
				if (!_first_battle_tick && _battling_heros.length > 0) {
					var tar_hero:PlayerBall = _battling_heros[0];
					_attack_random_dir = Util.normalized( tar_hero.velocity.x, tar_hero.velocity.y);
					_attack_random_dir.scaleBy(8);
					_first_battle_tick = true;
					
				} else {
					_attack_random_dir = Util.normalized(Util.float_random( -1, 1), Util.float_random( -1, 1));
					_attack_random_dir.scaleBy(4);
				}
				return true;
			} else {
				_attack_anim_ct--;
				var theta:Number = (1 - (_attack_anim_ct / _attack_anim_ct_max))*Math.PI;
				super.set_centered_position(_actual_position.x + Math.sin(theta) * _attack_random_dir.x * 7, _actual_position.y + Math.sin(theta) * _attack_random_dir.y * 7);
				return false;
			}
		}
		
	}

}