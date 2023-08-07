package;

import abantoons.Abantoons;

class Main {
	public static var gameInstance(default, null) : Abantoons;

	static function main() {
		#if hl
		hxd.Res.initPak();
		#else
		hxd.Res.initEmbed();
		#end
		gameInstance = new Abantoons();
	}
}