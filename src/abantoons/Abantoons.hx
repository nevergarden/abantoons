package abantoons;

import abantoons.scene.Desktop;

class Abantoons extends hxd.App {
	public static var NULL_TILE : h2d.Tile;

	override function init() {
		this.setScene2D(new Desktop(), true);
	}

	override function onResize() {
		super.onResize();
	}

	function init_global():Void {
		NULL_TILE = h2d.Tile.fromColor(0, 1, 1, 0);
	}
}
