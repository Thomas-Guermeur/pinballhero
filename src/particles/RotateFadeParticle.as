package particles {
	import org.flixel.*;
	
	public class RotateFadeParticle extends BaseParticle {
			
		public static function cons(g:FlxGroup):RotateFadeParticle {
			var rtv:RotateFadeParticle = g.getFirstAvailable(RotateFadeParticle) as RotateFadeParticle;
			if (rtv == null) {
				rtv = new RotateFadeParticle();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function RotateFadeParticle() {
			super();
			this.loadGraphic(Resource.EXPLOSION); 
		}
		
		public var _vx:Number = 0;
		public var _vy:Number = 0;
		public var _vr:Number = 0;
		public var _ct:Number = 0;
		
		var _has_played_sfx:Boolean = false;
		public function init(x:Number, y:Number):RotateFadeParticle {
			this.reset(x, y);
			_ct = 0;
			this.alpha = 1;
			this.scale.x = 1;
			this.scale.y = 1;
			_has_played_sfx = false;
			
			return this;
		}
		
		public function p_set_velocity(vx:Number, vy:Number):RotateFadeParticle {
			_vx = vx;
			_vy = vy;	
			return this;
		}
		
		public function p_set_vr(vr:Number):RotateFadeParticle {
			_vr = vr;
			return this;
		}
		
		public function p_set_scale(s:Number):RotateFadeParticle {
			this.set_scale(s);
			return this;
		}
		
		public function p_final_scale(s:Number):RotateFadeParticle {
			return this;
		}
		
		var _initial_alpha:Number = 1;
		var _final_alpha:Number = 0;
		public function p_set_alpha(initial:Number, finals:Number):RotateFadeParticle {
			_initial_alpha = initial;
			_final_alpha = finals;
			return this;
		}
		
		var _delay:Number = 0;
		public function p_set_delay(ct:Number):RotateFadeParticle {
			_delay = ct;
			return this;
		}
		
		var _ctspeed:Number = 0.1;
		public function p_set_ctspeed(ctspd:Number):RotateFadeParticle {
			_ctspeed = ctspd;
			return this;
		}
		
		public override function game_update(g:GameEngineState):void {
			if (_delay > 0) {
				_delay--;
				this.alpha = 0;
				return;
			} else {
				this.alpha = _initial_alpha + (_final_alpha - _initial_alpha) * (_ct);
			}
			if (!_has_played_sfx ) {
				_has_played_sfx = true;
			}
			
			this.angle += _vr;
			this.x += _vx;
			this.y += _vy;
			
			_ct += _ctspeed;
		}
		
		public override function should_remove(g:GameEngineState):Boolean {
			return _ct >= 1;
		}
		
		public override function do_remove(g:GameEngineState):void {
			this.kill();
		}
	}

}