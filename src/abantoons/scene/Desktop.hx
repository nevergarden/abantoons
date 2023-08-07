package abantoons.scene;

import abantoons.control.BootLogo;
import h2d.RenderContext;

class Desktop extends h2d.Scene {
	var time : Float = 0;
	public function new() {
		super();
		this.change_resolution();

		// Start
		this.start();
	}

	private function start() {
		var logo = new BootLogo(3, this);
		logo.x = 800 / 2;
		logo.y = 600 / 2 - 50;
		logo.onDone = function() {
			this.removeChild(logo);
			loadDesktop();
		}
	}

	private function loadDesktop() {

	}

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
	}

	function change_resolution() {
		this.scaleMode = LetterBox(800, 600);
	}
}