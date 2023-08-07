package tool;

#if sys
import sys.io.File;
#end

class ProFontFntGen {
	#if sys

	public static function main() {
		gen("res/font/profont-nayuki/font.fnt");
	}

	public static function gen(path:String):String {
		var charList : Array<String> = [" ", "!", '"', "#", "$", "%", "&", "'", "(", ")", 
			"*", "+", ",", "-", ".", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
			":", ";", "<", "=", ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I",
			"J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y",
			"Z", "[", "\\", "]", "^", "_", "`", "a", "b", "c", "d", "e", "f", "g", "h", "i",
			"j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y",
			"z", "{", "|", "}", "~"
		];

		var data : String = 'info font="ProFont Nayuki" size=12 bold=0 italic=0 charset="" unicode=0 stretchH=100 smooth=1 aa=1 padding=0,0,0,0 spacing=1,1 outline=0\n';
		data += 'common lineHeight=22 base=26 scaleW=256 scaleH=128 pages=1 packed=0 alphaChnl=0 redChnl=4 greenChnl=4 blueChnl=4\n';
		data += 'page id=0 file="font_0.png"\n';
		data += 'chars count=${charList.length}\n';
		var cx = 0;
		for(each in charList) {
			data += 'char id=${each.charCodeAt(0)}   x=${cx}   y=0    width=12     height=22     xoffset=0    yoffset=0    xadvance=12     page=0  chnl=15\n';
			cx+=12;
		}

		var f = File.write(path, false);
		f.writeString(data);
		f.flush();
		f.close();
		return data;
	}
	#end
}