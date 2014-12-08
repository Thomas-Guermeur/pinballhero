package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import particles.*;
	
	public class GoldPickup extends GameObject {
		
		public function GoldPickup() {
			super();
		}
		
		public var _ct:Number = 0;
		public var _vel:FlxPoint = new FlxPoint();
		var _flash_ct:int = 0;
		var _magneted_hero:PlayerBall = null
		var _type:Number = 0;
		var _fadeout_speed:Number = 0;
		
		var _ignore_ct:Number;
		
		public function init(x:Number, y:Number, scf:Number = 1):GoldPickup {
			this.reset(0,0);
			this.loadGraphic(Resource.GOLD);
			_fadeout_speed = 0.001;
			this.reset(x, y);
			
			_ct = 0;
			_vel.x = Util.float_random(-6*scf,6*scf);
			_vel.y = Util.float_random(-6*scf,6*scf);
			_magneted_hero = null;
			_picked_up = false;
			_ignore_ct = 10;
			this.set_scale(0.5);
			return this;
		}
		
		
		var _picked_up:Boolean = false;
		public override function game_update(g:GameEngineState):void {
			if (_magneted_hero != null && !_magneted_hero.alive) _magneted_hero = null;
			if (_ignore_ct <= 0) {
				for (var i_playerball:Number = g._player_balls.length - 1; i_playerball >= 0; i_playerball--) {
					var itr_playerball:PlayerBall = g._player_balls.members[i_playerball];
					if (itr_playerball.alive) {
						var dist:Number = Util.pt_dist(this.x, this.y, itr_playerball.get_center().x, itr_playerball.get_center().y);
						if (dist < 15) {
							if (!_picked_up) {
								_picked_up =  true;
								g.pickup_gold();
							}
							break;
						} else if (dist < 50) {
							_magneted_hero = itr_playerball;
							break;
						}
					}
				}
			} else {
				_ignore_ct--;
			}
			
			this.x += _vel.x;
			this.y += _vel.y;
			
			if (_magneted_hero != null) {
				var player:FlxPoint = _magneted_hero.get_center();
				var v:Vector3D = Util.normalized(player.x - this.x, player.y - this.y);
				v.scaleBy(Math.max(5.5,Util.point_dist(player.x,player.y,this.x,this.y)/200 * 5 + 5.5));
				_vel.x = v.x;
				_vel.y = v.y;
			} else {
				_vel.x *= 0.95;
				_vel.y *= 0.95;
				
			}
			
			_ct += _fadeout_speed;
			_flash_ct++;
			if (_ct > 0.7) {
				if (_flash_ct % 10 == 0) {
					this.alpha = this.alpha == 1 ? 0.6 : 1;
				}
				
			} else {
				this.alpha = 1;
			}
			if (_ct >= 1) {
				_picked_up = true;
			}
		}
		
		public override function should_remove(g:GameEngineState):Boolean { return _picked_up; }
		public override function do_remove(g:GameEngineState):void {
			this.kill();
			
		}
		
	}

}