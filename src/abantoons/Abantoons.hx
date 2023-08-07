package abantoons;

import abantoons.scene.Desktop;

class Abantoons extends hxd.App {
	override function init() {
		this.setScene2D(new Desktop(), true);
	}

	override function onResize() {
		super.onResize();
	}
}
