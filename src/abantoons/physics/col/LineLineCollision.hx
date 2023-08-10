package abantoons.physics.col;

import abantoons.type.Line;

class LineLineCollision implements Collidable {
	final line1:Line;
	final line2:Line;

	public function new(line1:Line, line2:Line) {
		this.line1 = line1;
		this.line2 = line2;
	}
	
	public static inline function collision(l1:Line, l2:Line) : Bool {
		var uA : Float = ((l2.p2.x-l2.p1.x)*(l1.p1.y-l2.p1.y) - (l2.p2.y-l2.p1.y)*(l1.p1.x-l2.p1.x)) / ((l2.p2.y-l2.p1.y)*(l1.p2.x-l1.p1.x) - (l2.p2.x-l2.p1.x)*(l1.p2.y-l1.p1.y));
  	var uB : Float = ((l1.p2.x-l1.p1.x)*(l1.p1.y-l2.p1.y) - (l1.p2.y-l1.p1.y)*(l1.p1.x-l2.p1.x)) / ((l2.p2.y-l2.p1.y)*(l1.p2.x-l1.p1.x) - (l2.p2.x-l2.p1.x)*(l1.p2.y-l1.p1.y));

		if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
			return true;
		}
		return false;
	}

	public function collides():Bool {
		return collision(this.line1, this.line2);
	}
}