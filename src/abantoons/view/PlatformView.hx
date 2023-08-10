package abantoons.view;

import abantoons.type.Rectangle;
import h2d.Tile;
import h2d.TileGroup;

enum PlatformType {
	Dirt1;
	Dirt2;
	Dirt3;
	Stone1;
}

typedef PlatformCoord = {
	var x:Int;
	var y:Int;
}

class PlatformView extends h2d.Object {
	public static final TILE_SIZE : Int = 100;

	private static var tilesMap : Map<PlatformType, Tile>;
	private final platforms : TileGroup;
	private var selectedPlatforms : TileGroup;

	private var platformsMap : Map<Int, Map<Int, PlatformType>>;
	private var selectedPlatformsMap : Map<Int, Map<Int, PlatformType>>;

	public function new(?parent) {
		initMap();
		super(parent);
		this.platforms = new TileGroup(this);
		this.selectedPlatforms = new TileGroup(this);
		this.platformsMap = new Map<Int, Map<Int, PlatformType>>();
		this.selectedPlatformsMap = new Map<Int, Map<Int, PlatformType>>();
	}

	private function initMap() : Void {
		if(tilesMap != null) 
			return;

		tilesMap = [
			Dirt1 => hxd.Res.platform.dirt_1.toTile(),
			Dirt2 => hxd.Res.platform.dirt_2.toTile(),
			Dirt3 => hxd.Res.platform.dirt_3.toTile(),
			Stone1 => hxd.Res.platform.stone_1.toTile(),
		];
	}

	public function addTileTypeToGroup(x:Int, y:Int, type:PlatformType, ?tileGroup:Map<Int, Map<Int, PlatformType>>=null) {
		try {
			if(tileGroup == null)
				tileGroup = this.platformsMap;
			var ymap = tileGroup.get(x);
			if(ymap == null) {
				ymap = new Map<Int, PlatformType>();
				tileGroup.set(x, ymap);
			}
			ymap.set(y, type);
		} catch(e:haxe.Exception) {
			trace("adding tile should've never failed.");
		}
	}

	public function addTileToGroup(x:Int, y:Int, tile:PlatformType, ?tileGroup:Map<Int, Map<Int, PlatformType>>=null) {
		try {
			if(tileGroup == null)
				tileGroup = this.platformsMap;
			var ymap = tileGroup.get(x);
			if(ymap == null) {
				ymap = new Map<Int, PlatformType>();
				tileGroup.set(x, ymap);
			}
			ymap.set(y, tile);
		} catch(e:haxe.Exception) {
			trace("adding tile should've never failed.");
		}
	}

	public function removeTileFromGroup(x:Int, y:Int, ?tileGroup:Map<Int, Map<Int, PlatformType>>=null):PlatformType {
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

	private function platformMapToTileGroup(tileGroup:TileGroup, tileMap:Map<Int, Map<Int, PlatformType>>) {
		tileGroup.clear();
		for(x=>ym in tileMap) {
			if(ym != null) {
				for(y=>tile in ym) {
					if(tile != null) {
						tileGroup.add(x*100, y*100, tilesMap.get(tile));
					}
				}
			}
		}
	}

	public function selectPlatforms(rect:Rectangle) {
		this.selectedPlatformsMap.clear();
		for(x in rect.x...rect.w+rect.x) {
			var ymap = new Map<Int, PlatformType>();
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

	public function pasteSelectedPlatforms(diffX:Int, diffY:Int) {
		for(x=>ymap in this.selectedPlatformsMap) {
			for(y=>tile in ymap) {
				addTileToGroup(x+diffX, y+diffY, tile, this.platformsMap);
			}
		}
		this.selectedPlatformsMap.clear();
		render();
	}

	public function moveSelected(diffX:Int, diffY:Int) {
		this.selectedPlatforms.x += TILE_SIZE*diffX;
		this.selectedPlatforms.y += TILE_SIZE*diffY;
	}

	public function resetSelected() {
		this.selectedPlatforms.x = 0;
		this.selectedPlatforms.y = 0;
	}
}