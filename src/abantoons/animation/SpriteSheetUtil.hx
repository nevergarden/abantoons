package abantoons.animation;

import abantoons.animation.JSONAtlas.FrameRect;

class SpriteSheetUtil {
	/*
		Slices a texture tile based on given atlas json return all frames
		as tiles.
	 */
	public static function sliceJSONAtlas(texture:h2d.Tile, json:JSONAtlas):Array<h2d.Tile> {
		var frames = new Array<h2d.Tile>();
		var frame:FrameRect;
		for (i in json.frames) {
			frame = i.frame;
			frames.push(texture.sub(frame.x, frame.y, frame.w, frame.h));
		}
		return frames;
	}

	/*
		Extracts map of tag name -> tile frames.
	 */
	public static function metaAnimations(tiles:Array<h2d.Tile>, json:JSONAtlas):Map<String, Array<h2d.Tile>> {
		var map = new Map<String, Array<h2d.Tile>>();

		for (tag in json.meta.frameTags) {
			var frames = tiles.slice(tag.from, tag.to + 1);
			map.set(tag.name, frames);
		}

		return map;
	}
}
