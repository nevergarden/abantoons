package abantoons.physics.col;

import abantoons.type.Line;
import abantoons.type.Point;
import abantoons.type.Polygon;
import abantoons.type.Rectangle;

class RectPolygonCollision implements Collidable {
	final rect : Rectangle;
	final polygon : Polygon;

	public function new(rect:Rectangle, polygon:Polygon) {
		this.rect = rect;
		this.polygon = polygon;
	}

	public function collides() : Bool {
		return collision(this.rect, this.polygon);
	}

	public static function collision(rect: Rectangle, polygon:Polygon) : Bool {
		var next = 0;
		for (current in 0...polygon.length) {
			next = current+1;
			if (next == polygon.length) {
				next = 0;
			}
			var vc : Point = polygon[current];
			var vn : Point = polygon[next]; 
			
			var col : Bool = LineRectCollision.collision({p1: {x: vc.x, y: vc.y}, p2: {x: vn.x, y: vn.y}}, rect);
			if (col) {
				return true;
			}

			var inside : Bool = PointPolygonCollision.collision({x: rect.x, y: rect.y}, polygon);
			if (inside)
				return true;
		}
		return false;
	}
}