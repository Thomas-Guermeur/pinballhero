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
			this.loadGraphic(Resource.MOUNTAIN_MED);
			
			x -= this.width / 2;
			y -= this.height / 2;
		}
	}

}