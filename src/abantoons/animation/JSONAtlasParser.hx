package abantoons.animation;

import haxe.format.JsonParser;

class JSONAtlasParser {
	public static function parseAtlas(data:String):JSONAtlas {
		var atlas:JSONAtlas = JsonParser.parse(data);
		return atlas;
	}
}
