package geom {
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;

	public class Line {
		
		public var start:FlxPoint, end:FlxPoint;
		
		public function Line(Start:FlxPoint, End:FlxPoint) {
			start	= Start;
			end		= End;
		}
		
		public function getRadians():Number {
			return Math.atan2(end.y - start.y, end.x - start.x);
		}
		
		public function getSlope():Number {
			return (end.y - start.y) / (end.x - start.x);
		}
		
		public static function getVertIntersection(vert:Line, horiz:Line):FlxPoint {
			// vert (vertical) has an infinite slope
			var x1:Number = horiz.start.x;
			var x2:Number = horiz.end.x;
			var y1:Number = horiz.start.y;
			var y2:Number = horiz.end.y;
			
			var x3:Number = vert.start.x;
			var m1:Number = horiz.getSlope();
			return new FlxPoint(x3, m1 * (x3 - x1) + y1);
		}
		
		public static function getIntersection(line1:Line, line2:Line):FlxPoint {
			var m1:Number = line1.getSlope();
			var m2:Number = line2.getSlope();
			
			if (m1 == Number.POSITIVE_INFINITY ||
				m1 == Number.NEGATIVE_INFINITY) {
				return Line.getVertIntersection(line1, line2);
			}
			if (m2 == Number.POSITIVE_INFINITY ||
				m2 == Number.NEGATIVE_INFINITY) {
				return Line.getVertIntersection(line2, line1);
			}
			
			var x1:Number = line1.start.x;
			var x2:Number = line1.end.x;
			var y1:Number = line1.start.y;
			var y2:Number = line1.end.y;
			
			var x3:Number = line2.start.x;
			var x4:Number = line2.end.x;
			var y3:Number = line2.start.y;
			var y4:Number = line2.end.y;

			var pointX:Number = (y3 - y1 + m1 * x1 - m2 * x3) / (m1 - m2);
			var pointY:Number = y1 + m1 * (pointX - x1);
			
			var result:FlxPoint = new FlxPoint(pointX, pointY);
			if (line1.inBoundingBox(result) && line2.inBoundingBox(result)) {
				return result;
			}
			else {
				return null;
			}
		}
		
		public function inBoundingBox(point:FlxPoint):Boolean {
			var minX:Number = Math.min(start.x, end.x) - 0.01;
			var minY:Number = Math.min(start.y, end.y) - 0.01;
			var maxX:Number = Math.max(start.x, end.x) + 0.01;
			var maxY:Number = Math.max(start.y, end.y) + 0.01;
			
			return (
				minX <= point.x && point.x <= maxX &&
				minY <= point.y && point.y <= maxY
			);
		}
	}
}