package abantoons.core;

enum KeyboardEventType {
	KeyDown(keyCode:Int);
	KeyUp(keyCode:Int);
}

class Keyboard {
	private static final elisteners : Array<KeyboardEventType->Void> = [];

	public static var keysDown:Map<Int, Bool> = new Map<Int, Bool>();

	public static function setKeyDown(keyCode:Int) {
		keysDown.set(keyCode, true);
	}

	public static function setKeyUp(keyCode:Int) {
		keysDown.set(keyCode, false);
	}

	public static function addEventListener(f:KeyboardEventType->Void) {
		elisteners.push(f);
	}

	static function dispatch(type:KeyboardEventType) {
		for(each in elisteners)
			each(type);
	}

	public static function removeEventListener(f:KeyboardEventType->Void) {
		elisteners.remove(f);
	}

	public static function down(code:Int) {
		setKeyDown(code);
		dispatch(KeyDown(code));
	}

	public static function up(code:Int) {
		setKeyUp(code);
		dispatch(KeyUp(code));
	}
}