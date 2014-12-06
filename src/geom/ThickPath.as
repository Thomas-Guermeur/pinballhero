package geom {
	
	import org.flixel.*;

	import flash.display.Graphics;

	public class ThickPath extends FlxPath {
		public var thickness:Number;
		
		public function ThickPath(nodes:Array, Thickness:Number) {
			super(nodes);
			thickness = Thickness;
		}
		
		public function bounceCollision(particle:FlxObject):void {
			var nextParticle:FlxPoint = new FlxPoint(
				particle.x + particle.velocity.x,
				particle.y + particle.velocity.y
			);
			var playerPath:Line = new Line(
				new FlxPoint(particle.x, particle.y),
				nextParticle);
			var playerSlope:Number = playerPath.getSlope();
			
			// keep track of all possible collision (and the corresponding line
			var collisions:Array = new Array();
			var collideLines:Array = new Array();
			
			for (var i:Number = 0; i < nodes.length - 1; i++) {
				var curr:FlxPoint = nodes[i];
				var next:FlxPoint = nodes[i + 1];
				
				var wallLine:Line = new Line(curr, next);
				var extLine:Line = getExtendedSurface(curr, next);
				
				var sideLine1:Line = new Line(curr, extLine.start);
				var sideLine2:Line = new Line(next, extLine.end);
				
				var collide:FlxPoint;
				collide = Line.getIntersection(wallLine, playerPath);
				if (collide) {
					collisions.push(collide);
					collideLines.push(wallLine);
				}
				collide = Line.getIntersection(extLine, playerPath)
				if (collide) {
					collisions.push(collide);
					collideLines.push(wallLine);
				}
				collide = Line.getIntersection(sideLine1, playerPath)
				if (collide) {
					collisions.push(collide);
					collideLines.push(wallLine);
				}
				collide = Line.getIntersection(sideLine2, playerPath)
				if (collide) {
					collisions.push(collide);
					collideLines.push(wallLine);
				}
			}
			
			// find closest collision to player
			var closest:Number = Number.POSITIVE_INFINITY;
			var collisionLine:Line;
			for (var c:String in collisions) {
				var point:FlxPoint = collisions[c];
				
				var dx:Number = point.x - particle.x;
				var dy:Number = point.y - particle.y;
				var dist:Number = dx * dx + dy * dy;
				
				var diry:int = dy < 0 ? -1 : 1;
				var dirx:int = dx < 0 ? -1 : 1;
				var vely:int = particle.velocity.y < 0 ? -1 : 1;
				var velx:int = particle.velocity.x < 0 ? -1 : 1;
				
				if (dist < closest && Math.sqrt(dist) < particle.width && dirx == velx && diry == vely) {
					closest = dist;
					collisionLine = collideLines[c];
				}
			}
			
			if (collisionLine) {
				// bounce player
				var rad:Number = -playerPath.getRadians() + 2 * collisionLine.getRadians();
				var d:Number = Util.point_dist(0, 0, particle.velocity.x, particle.velocity.y);
				particle.velocity.x = d * Math.cos(rad);
				particle.velocity.y = d * Math.sin(rad);
			}
			
			// TODO: maybe return something fancy to render game feel
		}
		
		/*
		 * Return the extended surface of the wall (after applying thickness
		 */
		private function getExtendedSurface(curr:FlxPoint, next:FlxPoint):Line {
			var wallRadians:Number = new Line(curr, next).getRadians() - Math.PI / 2;
			var wallDiffX:Number = thickness * Math.cos(wallRadians);
			var wallDiffY:Number = thickness * Math.sin(wallRadians);
			
			return new Line(
				new FlxPoint(curr.x + wallDiffX, curr.y + wallDiffY),
				new FlxPoint(next.x + wallDiffX, next.y + wallDiffY)
			);
		}
		
		override public function drawDebug(Camera:FlxCamera=null):void {
			var gfx:Graphics = FlxG.flashGfx;
			gfx.clear();
			
			for (var i:Number = 0; i < nodes.length - 1; i++) {
				var curr:FlxPoint = nodes[i];
				var next:FlxPoint = nodes[i + 1];
				
				var ext:Line = getExtendedSurface(curr, next);
				
				gfx.beginFill(0xffffff, .7);
				gfx.lineStyle(2, 0, 1);
				gfx.moveTo(curr.x, curr.y);
				gfx.lineTo(next.x, next.y);
				gfx.lineTo(ext.end.x, ext.end.y);
				gfx.lineTo(ext.start.x, ext.start.y);
				gfx.lineTo(curr.x, curr.y);
				gfx.endFill();
			}
		}
	}
}