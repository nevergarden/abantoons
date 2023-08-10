package abantoons.physics.col;

import abantoons.type.Point;
import abantoons.type.Polygon;

class PointPolygonCollision implements Collidable {
	final p : Point;
	final poly : Polygon;

	public function new(p:Point, polygon:Polygon) {
		this.p = p;
		this.poly = polygon;
	}

	public static function collision(p:Point, polygon:Polygon) {
		var collision = false;

		// go through each of the vertices, plus
		// the next vertex in the list
		var next = 0;
		for (current in 0...polygon.length) {

			// get next vertex in list
			// if we've hit the end, wrap around to 0
			next = current+1;
			if (next == polygon.length) next = 0;

			// get the PVectors at our current position
			// this makes our if statement a little cleaner
			var vc = polygon[current];    // c for "current"
			var vn = polygon[next];       // n for "next"

			// compare position, flip 'collision' variable
			// back and forth
			if (((vc.y >= p.x && vn.y < p.y) || (vc.y < p.y && vn.y >= p.y)) && (p.x < (vn.x-vc.x)*(p.y-vc.y) / (vn.y-vc.y)+vc.x)) {
					collision = !collision;
			}
		}
		return collision;
	}

	public function collides():Bool {
		return collision(this.p, this.poly);
	}
}