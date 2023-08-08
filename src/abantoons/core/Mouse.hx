package abantoons.core;

enum MouseEventType {
	Push;
	Move;
	Release;
}

class Mouse {
	private static final elisteners : Array<MouseEventType->Void> = [];
	
	public static var posX(default, null):Int;
	public static var posY(default, null):Int;

	public static function setPos(x:Int, y:Int) {
		posX = x;
		posY = y;
		dispatch(Move);
	}

	public static function addEventListener(f:MouseEventType->Void) {
		elisteners.push(f);
	}

	static function dispatch(type:MouseEventType) {
		for(each in elisteners)
			each(type);
	}

	public static function removeEventListener(f:MouseEventType->Void) {
		elisteners.remove(f);
	}

	public static function push() {
		dispatch(Push);
	}

	public static function release() {
		dispatch(Release);
	}
}