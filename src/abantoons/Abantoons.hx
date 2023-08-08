package abantoons;

import abantoons.scene.Desktop;

class Abantoons extends hxd.App {
	public static var NULL_TILE : h2d.Tile;
	public static var WIDTH_RATIO : Float = 1;
	public static var HEIGHT_RATIO : Float = 1;

	override function init() {
		this.calculate_ratio();
		this.setScene2D(new Desktop(), true);

		hxd.Window.getInstance().addEventTarget(handleInput);
	}

	override function onResize() {
		super.onResize();
		this.calculate_ratio();
	}

	function calculate_ratio():Void {
		WIDTH_RATIO = engine.width / 800;
		HEIGHT_RATIO = engine.height / 600;
	}

	function init_global():Void {
		NULL_TILE = h2d.Tile.fromColor(0, 1, 1, 0);
	}

	function handleInput(e:hxd.Event) {
		switch (e.kind) {
			case EMove:
				abantoons.core.Mouse.setPos(Std.int(e.relX), Std.int(e.relY));
			case EPush:
				abantoons.core.Mouse.push();
			case ERelease:
				abantoons.core.Mouse.release();
			case EKeyDown:
				abantoons.core.Keyboard.down(e.keyCode);
			case EKeyUp:
				abantoons.core.Keyboard.up(e.keyCode);
			default:
		}
	}
}
