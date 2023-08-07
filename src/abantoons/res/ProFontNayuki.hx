package abantoons.res;

import abantoons.core.AssetManager;

class ProFontNayuki {
	public static function get(color:String):h2d.Font {
		return AssetManager.instance.getFont(color);
	}
}