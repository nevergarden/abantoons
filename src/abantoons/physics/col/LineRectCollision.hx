package abantoons.physics.col;

import abantoons.type.Rectangle;
import abantoons.type.Line;

class LineRectCollision implements Collidable {


	public static inline function collision(line:Line, rect:Rectangle) : Bool {
		// check if the line has hit any of the rectangle's sides
		// uses the Line/Line function below
		var left =   LineLineCollision.collision(line, { p1 : { x: rect.x, y: rect.y }, p2: {x: rect.x, y: rect.y+rect.h}});
		var right =  LineLineCollision.collision(line, { p1 : { x: rect.x+rect.w, y: rect.y}, p2: {x: rect.x+rect.w, y: rect.y+rect.h}});
		var top =    LineLineCollision.collision(line, { p1 : { x: rect.x, y: rect.y }, p2: {x: rect.x+rect.w, y: rect.y}});
		var bottom = LineLineCollision.collision(line, { p1 : { x: rect.x, y: rect.y+rect.h }, p2: {x: rect.x+rect.w, y: rect.y+rect.h}});

		// if ANY of the above are true, the line
		// has hit the rectangle
		if (left || right || top || bottom) {
			return true;
		}
		return false;
	}

	public function collides():Bool {
		throw new haxe.exceptions.NotImplementedException();
	}
}