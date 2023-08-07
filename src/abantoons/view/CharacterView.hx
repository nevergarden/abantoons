package abantoons.view;

import abantoons.animation.SpriteSheetUtil;
import abantoons.animation.JSONAtlasParser;

class CharacterView extends h2d.Object {
	private final anim : h2d.Anim;
	private final animations: Map<String, Array<h2d.Tile>>;

	public function new(sheetRes:hxd.res.Image, jsonRes:hxd.res.Resource, ?parent:h2d.Object) {
		super(parent);
		var jsonAtlas = JSONAtlasParser.parseAtlas(jsonRes.entry.getText());
		var tiles : Array<h2d.Tile> = SpriteSheetUtil.sliceJSONAtlas(sheetRes.toTile(), jsonAtlas);
		
		this.animations = SpriteSheetUtil.metaAnimations(tiles, jsonAtlas);
		this.anim = new h2d.Anim([Abantoons.NULL_TILE], 15, this);
		switchAnimation("idle");
	}

	public function switchAnimation(name:String) {
		if(animations.exists(name)) {
			this.anim.play(this.animations.get(name));
		}
	}
}