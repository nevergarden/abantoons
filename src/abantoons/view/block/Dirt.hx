package abantoons.view.block;

enum DirtType {
	Dirt1;
	Dirt2;
	Dirt3;
}

class Dirt extends h2d.TileGroup {
	public static var dirt1:h2d.Tile;
	public static var dirt2:h2d.Tile;
	public static var dirt3:h2d.Tile;
	private static var init:Bool = false;

	private var type:DirtType;
	private var dTile:h2d.Tile;

	public static function initialize():Void {
		dirt1 = hxd.Res.platform.dirt_1.toTile();
		dirt2 = hxd.Res.platform.dirt_2.toTile();
		dirt3 = hxd.Res.platform.dirt_3.toTile();
	}

	public function new(type:DirtType, ?parent:h2d.Object) {
		if(!init) {
			initialize();
			init = true;
		}

		this.type = type;
		switch (type) {
			case Dirt1:
				this.dTile = dirt1;
			case Dirt2:
				this.dTile = dirt2;
			case Dirt3:
				this.dTile = dirt3;
		}

		super(dTile, parent);
	}

	public function addSnapped(x:Int, y:Int) {
		add(x*100, y*100, dTile);
	}
}