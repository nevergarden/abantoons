package abantoons.view;

import abantoons.type.Point;
import abantoons.view.interf.AnimCharacter;
import abantoons.animation.SpriteSheetUtil;
import abantoons.animation.JSONAtlasParser;

class CharacterView extends h2d.Object implements AnimCharacter {
	private final anim : h2d.Anim;
	private final animations: Map<String, Array<h2d.Tile>>;

	public function new(sheetRes:hxd.res.Image, jsonRes:hxd.res.Resource, ?origin:Point, ?parent:h2d.Object) {
		super(parent);
		var jsonAtlas = JSONAtlasParser.parseAtlas(jsonRes.entry.getText());
		var tiles : Array<h2d.Tile> = SpriteSheetUtil.sliceJSONAtlas(sheetRes.toTile(), jsonAtlas);
		var originTiles : Array<h2d.Tile> = [];
		for(tile in tiles) {
			if(origin == null) {
				tile = tile.center();
				originTiles.push(tile);
			} else {
				tile.dx -= origin.x;
				tile.dy -= origin.y;
				originTiles.push(tile);
			}
		}
		
		this.animations = SpriteSheetUtil.metaAnimations(originTiles, jsonAtlas);
		this.anim = new h2d.Anim([Abantoons.NULL_TILE], 30, this);
		switchAnimation("idle");
	}

	public function switchAnimation(name:String) {
		if(animations.exists(name)) {
			this.anim.play(this.animations.get(name));
		}
	}
}