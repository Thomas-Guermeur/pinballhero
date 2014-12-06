package gameobjs {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import flash.ui.*;	
	
	/**
	 * ...
	 * @author spotco
	 */
	public class PubLandmark extends Landmark {
		
		public function PubLandmark() {
			this.loadGraphic(Resource.TOWN);
		}
		
		public override function handleVisitor(visitor:PlayerBall, g:GameEngineState):void {
			var speed:Number = getVisitorSpeed(visitor);
			var radians:Number = Math.atan2(visitor.velocity.y, visitor.velocity.x);
			
			var rad1:Number = Math.PI / 4 - radians;
			var rad2:Number = -Math.PI / 4 - radians;
			
			visitor.velocity.y = speed * Math.sin(rad1);
			visitor.velocity.x = speed * Math.cos(rad1);
			
			var buddy:GameObject = GameEngineState.cons(PlayerBall, g._player_balls);
			buddy.velocity.y = speed * Math.sin(rad2);
			buddy.velocity.x = speed * Math.cos(rad2);
		}
	}

}