package abantoons.view;

import h2d.TileGroup;

class PlatformView extends h2d.Object {
	private static var UID : Int = 0;
	private final platforms : Map<Int, TileGroup> = new Map<Int, TileGroup>();

	public function new(?parent) {
		super(parent);
	}

	public function addTileGroup(tileGroup:TileGroup) {
		this.platforms.set(UID++, tileGroup);
		this.addChild(tileGroup);
	}
}