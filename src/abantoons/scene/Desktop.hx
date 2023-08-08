package abantoons.scene;

import h2d.Layers;
import abantoons.core.Mouse;
import abantoons.view.block.Dirt;
import abantoons.view.PlatformView;
import abantoons.view.CharacterView;
import abantoons.control.BootLogo;
import h2d.RenderContext;

class Desktop extends h2d.Scene {
	var time : Float = 0;
	var background : Layers;
	var overlay : Layers;

	var cursorBmp : h2d.Bitmap;
	var drawGraphic : h2d.Graphics;

	private var selectBloopSound:hxd.res.Sound;
	private var soundChannel:hxd.snd.Channel;

	public function new() {
		super();
		this.change_resolution();

		this.background = new Layers(this);
		this.overlay = new Layers(this);

		// Start
		this.start();
	}

	private function start() {
		var logo = new BootLogo(3, this);
		logo.x = 800 / 2;
		logo.y = 600 / 2 - 50;
		selectBloopSound = hxd.Res.sfx.bloop_noise;
		logo.onDone = function() {
			this.removeChild(logo);
			loadDesktop();
		}
	}

	private function loadDesktop() {
		var cursorTile : h2d.Tile = hxd.Res.ui.under_cursor.toTile();
		this.cursorBmp = new h2d.Bitmap(cursorTile, this.overlay);
		this.drawGraphic = new h2d.Graphics(this.overlay);

		Mouse.addEventListener(mouseUIHandler);
		var ch = new CharacterView(hxd.Res.character.yum.yum_png, hxd.Res.character.yum.yum_json, this);
		ch.x = 800/2;
		ch.y = 600/2;

		var platform = new PlatformView(this.background);
		var d = new Dirt(Dirt1);
		d.addSnapped(0, 0);
		d.addSnapped(1, 0);
		d.addSnapped(2, 0);
		d.addSnapped(3, 0);
		var d2 = new Dirt(Dirt2);
		d2.addSnapped(0, 1);
		d2.addSnapped(1, 1);
		d2.addSnapped(2, 1);
		d2.addSnapped(3, 1);
		var d3 = new Dirt(Dirt3);
		d3.addSnapped(0, 2);
		d3.addSnapped(1, 2);
		d3.addSnapped(2, 2);
		d3.addSnapped(3, 2);

		platform.addTileGroup(d);
		platform.addTileGroup(d2);
		platform.addTileGroup(d3);

		platform.x = 2*100;
		platform.y = 3*100;
	}

	var isPushing : Bool = false;
	var startPosX : Int = 0;
	var startPosY : Int = 0;
	var wX : Int = 1;
	var wY : Int = 1;

	function mouseUIHandler(e:MouseEventType) : Void {
		switch (e) {
			case Push:
				this.isPushing = true;
				this.cursorBmp.visible = false;
				this.startPosX = Math.floor(this.screenXToViewport(abantoons.core.Mouse.posX)/100)*100;
				this.startPosY = Math.floor(this.screenYToViewport(abantoons.core.Mouse.posY)/100)*100;
				this.wX = 0;
				this.wY = 0;
				this.drawRect(Math.floor(this.startPosX/100), Math.floor(this.startPosY/100), this.wX, this.wY);
			case Move:
				this.cursorBmp.x = Math.floor(this.screenXToViewport(abantoons.core.Mouse.posX)/100)*100;
				this.cursorBmp.y = Math.floor(this.screenYToViewport(abantoons.core.Mouse.posY)/100)*100;
				if(isPushing) {
					var px = this.cursorBmp.x;
					var py = this.cursorBmp.y;
					var nwX : Int = Math.floor((px - this.startPosX)/100);
					var nwY : Int = Math.floor((py - this.startPosY)/100);
					if(nwX != this.wX || nwY != this.wY) {
						this.wX = nwX;
						this.wY = nwY;
						this.drawRect(Math.floor(this.startPosX/100), Math.floor(this.startPosY/100), this.wX, this.wY);
					}
				}
			case Release:
				isPushing = false;
				this.cursorBmp.visible = true;
		}
	}

	function drawRect(fromX:Int, fromY:Int, wc:Int, hc:Int) {
		this.drawGraphic.clear();
		this.drawGraphic.beginFill(0xff8000, 0.5);
		var x,y,w,h : Int = 0;

		if(wc <= 0) {
			x = (fromX+wc)*100;
			w = (Math.abs(wc)+1)*100;
		} else {
			x = fromX*100;
			w = (wc+1)*100;
		}
		if(hc <= 0) {
			y = (fromY+hc)*100;
			h = Std.int((Math.abs(hc)+1)*100);
		} else {
			y = fromY*100;
			h = (hc+1)*100;
		}
		this.drawGraphic.drawRect(x,y,w,h);
		this.drawGraphic.endFill();
		this.soundChannel = this.selectBloopSound.play(false, (Math.abs(wc*hc)+2)/3);
	}

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
	}

	function change_resolution() {
		this.scaleMode = LetterBox(800, 600);
	}
}