package gameobjs 
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author 
	 */
	public class Mountain extends FlxSprite {
		
		public function Mountain(X:Number, Y:Number) {
			super(X, Y);
			this.loadGraphic([Resource.MOUNTAIN_SMALL,Resource.MOUNTAIN_MED,Resource.MOUNTAIN_BIG][Util.int_random(0,3)]);
			
			x -= this.width / 2;
			y -= this.height / 2;
		}
		
		public function hit(x:Number, y:Number):void {
			if (Util.pt_dist(x, y, this.x, this.y) < 90) {
				this.set_scale(1 + Util.pt_dist(x, y, this.x+this.width/2, this.y+this.height/2) / 90);
			}
		}
		
		public override function update():void {
			this.set_scale(Util.drp(this.scale.x, 1, 10));
		}
	}

}