package abantoons.scene;

import h2d.Bitmap;
import abantoons.type.Rectangle;
import h2d.Layers;
import h2d.RenderContext;
import hxd.Key;
import abantoons.control.BootLogo;
import abantoons.core.Keyboard;
import abantoons.core.Mouse;
import abantoons.view.CharacterView;
import abantoons.view.PlatformView;

enum SelectionState {
	Deselect;
	Selecting;
	Selected;
	Moving;
	EndMove;
}

class Desktop extends h2d.Scene {
	var time:Float = 0;
	var background:Layers;
	var overlay:Layers;

	var cursorBmp:h2d.Bitmap;
	var drawGraphic:h2d.Graphics;
	var character:CharacterView;
	var speed:Float = 5;

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
		this.camera.clipViewport = true;
		var logo = new BootLogo(3, this);
		logo.x = Abantoons.WIDTH / 2;
		logo.y = Abantoons.HEIGHT / 2 - 50;
		selectBloopSound = hxd.Res.sfx.bloop_noise;
		logo.onDone = function() {
			this.removeChild(logo);
			loadDesktop();
		}
	}

	var cursorTile:h2d.Tile;
	var cursorMoveTile:h2d.Tile;

	var platform : PlatformView;

	var bg : h2d.Bitmap;

	private function loadDesktop() {
		var bgTile = hxd.Res.platform.background.toTile();
		bgTile = bgTile.center();
		bg = new Bitmap(bgTile, this.background);
		cursorTile = hxd.Res.ui.under_cursor.toTile();
		cursorMoveTile = hxd.Res.ui.move_cursor.toTile();
		this.cursorBmp = new h2d.Bitmap(cursorTile, this.overlay);
		this.drawGraphic = new h2d.Graphics(this.overlay);

		Mouse.addEventListener(mouseUIHandler);
		Keyboard.addEventListener(playerMovementHandler);
		character = new CharacterView(hxd.Res.character.meek.idle_png, hxd.Res.character.meek.idle_json, this);
		character.x = Abantoons.WIDTH / 2;
		character.y = Abantoons.HEIGHT / 2;

		camera.follow = character;
		camera.anchorX = 0.5;
		camera.anchorY = 0.5;

		platform = new PlatformView(this.background);
		platform.addTileTypeToGroup(0,0, Dirt1);
		platform.addTileTypeToGroup(1,0, Dirt1);
		platform.addTileTypeToGroup(2,0, Dirt1);
		platform.addTileTypeToGroup(3,0, Dirt1);
		platform.addTileTypeToGroup(0,1, Dirt2);
		platform.addTileTypeToGroup(1,1, Dirt2);
		platform.addTileTypeToGroup(2,1, Dirt2);
		platform.addTileTypeToGroup(3,1, Dirt2);
		platform.addTileTypeToGroup(0,2, Dirt3);
		platform.addTileTypeToGroup(1,2, Dirt3);
		platform.addTileTypeToGroup(2,2, Dirt3);
		platform.addTileTypeToGroup(3,2, Dirt3);
		platform.addTileTypeToGroup(4,0, Stone1);
		platform.addTileTypeToGroup(4,1, Stone1);
		platform.addTileTypeToGroup(4,2, Stone1);

		platform.render();
	}

	var startPosX:Int = 0;
	var startPosY:Int = 0;
	var wX:Int = 1;
	var wY:Int = 1;

	var selectedBounds : Rectangle;
	var selectionState(default,set) : SelectionState = Deselect;

	function set_selectionState(value:SelectionState) : SelectionState {
		// trace(selectionState);
		if(value == selectionState && value != Selected)
			return selectionState;

		switch(value) {
			case Deselect:
				this.drawGraphic.x = 0;
				this.drawGraphic.y = 0;
				this.drawGraphic.clear();
				this.platform.pasteSelectedPlatforms(lastDiffX, lastDiffY);
				this.platform.render();
				this.platform.resetSelected();
				this.lastDiffX = 0;
				this.lastDiffY = 0;
				this.cursorBmp.tile = this.cursorTile;
				this.selectedBounds = null;
			case Selecting:
				
			case Selected:
				if(isCursorInSelection()) {
					this.cursorBmp.tile = this.cursorMoveTile;
				}
				else {
					this.cursorBmp.tile = this.cursorTile;
				}
			case Moving:
			case EndMove:
		}
		return selectionState = value;
	}

	function mouseUIHandler(e:MouseEventType):Void {
		switch (e) {
			case Push(button):
				if(button == 0) {
					if(selectionState == Selected && isCursorInSelection()) {
						this.selectionState = Moving;
						this.startPosX = Math.floor(this.screenXToViewport(abantoons.core.Mouse.posX) / PlatformView.TILE_SIZE);
						this.startPosY = Math.floor(this.screenYToViewport(abantoons.core.Mouse.posY) / PlatformView.TILE_SIZE);
						this.wX = 0;
						this.wY = 0;
					} else {
						if(!isCursorInSelection())
							selectionState = Deselect;

						selectionState = Selecting;
						this.cursorBmp.visible = false;
						this.startPosX = Math.floor(this.screenXToViewport(abantoons.core.Mouse.posX) / PlatformView.TILE_SIZE);
						this.startPosY = Math.floor(this.screenYToViewport(abantoons.core.Mouse.posY) / PlatformView.TILE_SIZE);
						this.wX = 0;
						this.wY = 0;
						this.drawRect(Math.floor(this.startPosX), Math.floor(this.startPosY), this.wX, this.wY);
					}
				}
				if(button == 1) {
					selectionState = Deselect;
					this.cursorBmp.visible = true;
					this.selectedBounds = null;
					this.drawGraphic.clear();
				}
			case Move:
				this.cursorBmp.x = Math.floor(this.screenXToViewport(abantoons.core.Mouse.posX) / PlatformView.TILE_SIZE) * PlatformView.TILE_SIZE;
				this.cursorBmp.y = Math.floor(this.screenYToViewport(abantoons.core.Mouse.posY) / PlatformView.TILE_SIZE) * PlatformView.TILE_SIZE;
				if (selectionState == Selecting) {
					var px = this.cursorBmp.x;
					var py = this.cursorBmp.y;
					var nwX:Int = Math.floor((px - this.startPosX*PlatformView.TILE_SIZE) / PlatformView.TILE_SIZE);
					var nwY:Int = Math.floor((py - this.startPosY*PlatformView.TILE_SIZE) / PlatformView.TILE_SIZE);
					if (nwX != this.wX || nwY != this.wY) {
						this.wX = nwX;
						this.wY = nwY;
						this.drawRect(this.startPosX, this.startPosY, this.wX, this.wY);
					}
				} else if(selectionState == Moving) {
					var px = this.cursorBmp.x;
					var py = this.cursorBmp.y;
					var nwX:Int = Math.floor((px - this.startPosX*PlatformView.TILE_SIZE) / PlatformView.TILE_SIZE);
					var nwY:Int = Math.floor((py - this.startPosY*PlatformView.TILE_SIZE) / PlatformView.TILE_SIZE);
					if (nwX != this.wX || nwY != this.wY) {
						moveDiff(nwX - this.wX, nwY - this.wY);
						this.wX = nwX;
						this.wY = nwY;
					}
				}
			case Release(button):
				if(button == 0) {
					if(selectionState == Selecting) {
						platform.selectPlatforms(selectedBounds);
						this.selectionState = Selected;
						this.cursorBmp.visible = true;
					} else {
						this.selectionState = Deselect;
						this.cursorBmp.visible = true;
					}
				}
		}
	}

	inline function pointCheck(px:Int, py:Int, r:Rectangle):Bool {
		if(px >= r.x && px <= (r.x + r.w - 1) && py >= r.y && py <= (r.y+r.h-1)) {
			return true;
		}
		return false;
	}

	function isCursorInSelection():Bool {
		if(this.cursorBmp == null || selectedBounds == null)
			return false;

		return pointCheck(Std.int(this.cursorBmp.x/PlatformView.TILE_SIZE), Std.int(this.cursorBmp.y/PlatformView.TILE_SIZE), selectedBounds);
	}

	var playerMovementFlag:Int = 0;

	function playerMovementHandler(e:KeyboardEventType) {
		switch (e) {
			case KeyDown(keyCode):
				switch (keyCode) {
					case Key.W: playerMovementFlag |= 1;
					case Key.A: playerMovementFlag |= 2;
					case Key.D: playerMovementFlag |= 4;
					case Key.S: playerMovementFlag |= 8;
					default:
				}
			case KeyUp(keyCode):
				switch (keyCode) {
					case Key.W: playerMovementFlag &= ~1;
					case Key.A: playerMovementFlag &= ~2;
					case Key.D: playerMovementFlag &= ~4;
					case Key.S: playerMovementFlag &= ~8;
				}
			case AllUp:
				playerMovementFlag = 0;
		}
	}

	function movePlayer() {
		if (character == null)
			return;
		var h = 0;
		if ((playerMovementFlag & 2) != 0) {
			h -= 1;
		}
		if ((playerMovementFlag & 4) != 0) {
			h += 1;
		}

		var v = 0;
		if ((playerMovementFlag & 1) != 0) {
			v -= 1;
		}
		if ((playerMovementFlag & 8) != 0) {
			v += 1;
		}

		var added = Math.abs(v) + Math.abs(h) + 1;
		var normalizedV = (v / (added));
		var normalizedH = (h / (added));
		character.x += normalizedH * speed;
		character.y += normalizedV * speed;
	}

	function drawRect(fromX:Int, fromY:Int, wc:Int, hc:Int) {
		this.drawGraphic.clear();
		this.drawGraphic.beginFill(0x00c3ff, 0.1);
		var x:Int = 0, y:Int = 0, w:Int = 0, h:Int = 0;

		if (wc <= 0) {
			x = (fromX + wc) * PlatformView.TILE_SIZE;
			w = Std.int((Math.abs(wc) + 1) * PlatformView.TILE_SIZE);
		} else {
			x = fromX * PlatformView.TILE_SIZE;
			w = (wc + 1) * PlatformView.TILE_SIZE;
		}
		if (hc <= 0) {
			y = (fromY + hc) * PlatformView.TILE_SIZE;
			h = Std.int((Math.abs(hc) + 1) * PlatformView.TILE_SIZE);
		} else {
			y = fromY * PlatformView.TILE_SIZE;
			h = (hc + 1) * PlatformView.TILE_SIZE;
		}
		this.drawGraphic.drawRect(x, y, w, h);
		this.drawGraphic.endFill();
		selectedBounds = {
			x: Std.int(x/PlatformView.TILE_SIZE),
			y: Std.int(y/PlatformView.TILE_SIZE),
			w: Std.int(w/PlatformView.TILE_SIZE),
			h: Std.int(h/PlatformView.TILE_SIZE)
		};
		this.soundChannel = this.selectBloopSound.play(false, (Math.abs(wc * hc) + 2) / 3);
	}

	var lastDiffX = 0;
	var lastDiffY = 0;
	function moveDiff(x:Int, y:Int) : Void {
		this.drawGraphic.x += (x*PlatformView.TILE_SIZE);
		this.drawGraphic.y += (y*PlatformView.TILE_SIZE);

		this.selectedBounds.x += x;
		this.selectedBounds.y += y;

		this.platform.moveSelected(x, y);

		lastDiffX += x;
		lastDiffY += y;
	}

	override function sync(ctx:RenderContext) {
		if(cursorBmp != null) {
			if(selectionState == Selected)
				selectionState = Selected;
		}
		if(bg != null) {
			bg.x = character.x;
			bg.y = character.y;
		}
		super.sync(ctx);
		
		movePlayer();
	}

	function change_resolution() {
		this.scaleMode = LetterBox(Abantoons.WIDTH, Abantoons.HEIGHT);
	}
}
