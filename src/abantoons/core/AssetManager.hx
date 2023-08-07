package abantoons.core;

import abantoons.type.FontsType;

class AssetManager {
	public static final instance:AssetManager = new AssetManager();

	public function new() {}

	public function getFont(color:String):h2d.Font {
		var engine = h3d.Engine.getCurrent();
		var fd:FontsType = {
			atlas: 'font/profont-nayuki/font_${color}_0.png',
			data: 'font/profont-nayuki/font_${color}.fnt',
		};
		@:privateAccess var fnt:h2d.Font = engine.resCache.get(fd);
		if (fnt == null) {
			var atlas = hxd.Res.loader.load(fd.atlas);
			var desc = hxd.Res.loader.load(fd.data);
			var bmp = new hxd.res.BitmapFont(desc.entry);
			@:privateAccess bmp.loader = atlas.loader;
			fnt = bmp.toFont();
			@:privateAccess engine.resCache.set(fd, fnt);
		}
		return fnt;
	}
}