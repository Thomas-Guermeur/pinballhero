package particles {
	import org.flixel.*;
	
	public class RotateFadeParticle extends BaseParticle {
		
		public function RotateFadeParticle() {
			super();
		}
		
		public var _vx:Number = 0;
		public var _vy:Number = 0;
		public var _vr:Number = 0;
		public var _ct:Number = 0;

		private var _has_played_sfx:Boolean = false;
		private var _initial_alpha:Number = 1;
		private var _final_alpha:Number = 0;
		private var _delay:Number = 0;
		private var _ctspeed:Number = 0.1;

		private var _loaded_resc:Class = null;
		public function init(x:Number, y:Number, graphic:Class = null):RotateFadeParticle {
			if (graphic == null) {
				graphic = Resource.EXPLOSION;
			}
			if (_loaded_resc != graphic) {
				this.framePixels.fillRect(this.framePixels.rect, 0);
				this.loadGraphic(graphic);
			}
			this.reset(x, y);
			_ct = 0;
			this.alpha = 1;
			this.scale.x = 1;
			this.scale.y = 1;
			_has_played_sfx = false;
			this._vx = 0;
			this._vy = 0;
			this._initial_alpha = 1;
			this._final_alpha = 0;
			this._vr = 0;
			this.color = 0xFFFFFF;
			this.angle = 0;
			return this;
		}
		
		public function p_set_color(color:uint):RotateFadeParticle {
			this.color = color;
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
		
		public function p_set_alpha(initial:Number, finals:Number):RotateFadeParticle {
			_initial_alpha = initial;
			_final_alpha = finals;
			return this;
		}
		
		public function p_set_delay(ct:Number):RotateFadeParticle {
			_delay = ct;
			return this;
		}
		
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