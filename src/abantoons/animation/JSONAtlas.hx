package abantoons.animation;

enum abstract JSONFrameDirection(String) {
	var Forward = "forward";
	var Backward = "backward";
	var PingPong = "pingpong";
}

typedef FrameSize = {
	var w:Int;
	var h:Int;
}

typedef FrameRect = {
	var x:Int;
	var y:Int;
	var w:Int;
	var h:Int;
}

typedef JSONAtlasFrame = {
	var filename:String;
	var frame:FrameRect;
	var rotated:Bool;
	var trimmed:Bool;
	var spriteSourceSize:FrameRect;
	var sourceSize:FrameSize;
	var duration:Int;
}

typedef JSONFrameTags = {
	var name:String;
	var from:Int;
	var to:Int;
	var direction:JSONFrameDirection;
}

typedef JSONAtlasMeta = {
	var app:String;
	var version:String;
	var image:String;
	var format:String;
	var size:FrameSize;
	var scale:Int;
	var frameTags:Array<JSONFrameTags>;
}

typedef JSONAtlas = {
	var frames:Array<JSONAtlasFrame>;
	var meta:JSONAtlasMeta;
}
