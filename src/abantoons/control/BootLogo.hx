package abantoons.control;

import h2d.RenderContext;

class BootLogo extends h2d.Object {
	var logo : h2d.Bitmap;
	var text : h2d.Text;
	var time : Float = 0;
	var end : Bool = false;
	var bootTime : Float;

	var baseText : String = "Loading";
	var addedText : String = "";
	
	public function new(?bootTime:Float = 2, ?parent:h2d.Object) {
		super(parent);
		this.bootTime = bootTime;

		var logoTile = hxd.Res.desktop.os_logo.toTile();
		logoTile.scaleToSize(100, 100);
		logoTile.dx = (logoTile.width / -2);
		logoTile.dy = (logoTile.height / -2);
		this.logo = new h2d.Bitmap(logoTile, this);
		this.text = new h2d.Text(hxd.res.DefaultFont.get(), this);
		this.text.text = baseText;
		this.text.syncPos();
		this.text.x = -this.text.textWidth/2;
		this.text.y += 100;
	}

	override function sync(ctx:RenderContext) {
		super.sync(ctx);
		var dt = hxd.Timer.dt;
		this.logo.rotate(dt);
		if(end)
			return;
		time += dt;
		if(time > this.bootTime/3) {
			time = 0;
			addedText += ".";
			this.text.text = '${baseText}${addedText}';
			if(addedText.length > 3) {
				this.end = true;
				onDone();
			}
		}
	}

	public dynamic function onDone() {}
}