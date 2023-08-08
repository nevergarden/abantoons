package abantoons.view;

import abantoons.type.Rectangle;
import h2d.Tile;
import h2d.TileGroup;

enum PlatformType {
	Dirt1;
	Dirt2;
	Dirt3;
}

typedef PlatformCoord = {
	var x:Int;
	var y:Int;
}

class PlatformView extends h2d.Object {
	private static var tilesMap : Map<PlatformType, Tile>;
	private final platforms : TileGroup;
	private var selectedPlatforms : TileGroup;

	private var platformsMap : Map<Int, Map<Int, Tile>>;
	private var selectedPlatformsMap : Map<Int, Map<Int, Tile>>;

	public function new(?parent) {
		initMap();
		super(parent);
		this.platforms = new TileGroup(this);
		this.selectedPlatforms = new TileGroup(this);
		this.platformsMap = new Map<Int, Map<Int, Tile>>();
		this.selectedPlatformsMap = new Map<Int, Map<Int, Tile>>();
	}

	private function initMap() : Void {
		if(tilesMap != null) 
			return;

		tilesMap = [
			Dirt1 => hxd.Res.platform.dirt_1.toTile(),
			Dirt2 => hxd.Res.platform.dirt_2.toTile(),
			Dirt3 => hxd.Res.platform.dirt_3.toTile(),
		];
	}

	public function addTileToGroup(x:Int, y:Int, type:PlatformType, ?tileGroup:Map<Int, Map<Int, Tile>>=null) {
		try {
			if(tileGroup == null)
				tileGroup = this.platformsMap;
			var ymap = tileGroup.get(x);
			if(ymap == null) {
				ymap = new Map<Int, Tile>();
				tileGroup.set(x, ymap);
			}
			ymap.set(y, tilesMap.get(type));
		} catch(e:haxe.Exception) {
			trace("adding tile should've never failed.");
		}
	}

	public function removeTileFromGroup(x:Int, y:Int, ?tileGroup:Map<Int, Map<Int, Tile>>=null):Tile {
		try {
			if(tileGroup == null)
				tileGroup = this.platformsMap;
			var tile = tileGroup.get(x).get(y);
			tileGroup.get(x).set(y, null);
			return tile;
		} catch(e:haxe.Exception) {
			return null;
		}
	}

	public function render() {
		platformMapToTileGroup(this.platforms, this.platformsMap);
		platformMapToTileGroup(this.selectedPlatforms, this.selectedPlatformsMap);
	}

	private function platformMapToTileGroup(tileGroup:TileGroup, tileMap:Map<Int, Map<Int, Tile>>) {
		tileGroup.clear();
		for(x=>ym in tileMap) {
			if(ym != null) {
				for(y=>tile in ym) {
					if(tile != null) {
						tileGroup.add(x*100, y*100, tile);
					}
				}
			}
		}
		// this.platforms.invalidate();
	}

	public function selectPlatforms(rect:Rectangle) {
		this.selectedPlatformsMap.clear();
		for(x in rect.x...rect.w+rect.x) {
			var ymap = new Map<Int, Tile>();
			for(y in rect.y...rect.h+rect.y) {
				var t = removeTileFromGroup(x, y);
				if(t != null) {
					ymap.set(y, t);
				}
			}
			selectedPlatformsMap.set(x, ymap);
		}
		render();
	}
}