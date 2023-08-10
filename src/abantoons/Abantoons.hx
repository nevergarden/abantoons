package abantoons;

import abantoons.scene.Desktop;

class Abantoons extends hxd.App {
	public static var NULL_TILE : h2d.Tile;
	public static var WIDTH : Int = 1280;
	public static var HEIGHT : Int = 720;

	override function init() {
		this.setScene2D(new Desktop(), true);

		hxd.Window.getInstance().addEventTarget(handleInput);
	}

	override function onResize() {
		super.onResize();
	}

	function init_global():Void {
		NULL_TILE = h2d.Tile.fromColor(0, 1, 1, 0);
	}

	function handleInput(e:hxd.Event) {
		switch (e.kind) {
			case EMove:
				abantoons.core.Mouse.setPos(Std.int(e.relX), Std.int(e.relY));
			case EPush:
				abantoons.core.Mouse.push(e.button);
			case ERelease:
				abantoons.core.Mouse.release(e.button);
			case EKeyDown:
				abantoons.core.Keyboard.down(e.keyCode);
			case EKeyUp:
				abantoons.core.Keyboard.up(e.keyCode);
			case EFocusLost:
				abantoons.core.Keyboard.upAll();
			default:
		}
	}
}
