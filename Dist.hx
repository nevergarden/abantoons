package;

import haxe.Exception;
import haxe.ds.GenericStack;
import sys.FileSystem;
import sys.io.File;

class Dist {
	static function copyDist() {
		new RecursiveCopyUtil("dist", "bin");
	}

	static function main() {
		copyDist();
	}
}

class RecursiveCopyUtil {
	private var later:GenericStack<String> = new GenericStack<String>();
	private var baseSrcPrefix:String;
	private var baseDestPrefix:String;
	private var currentPrefix:String;

	public function new(src:String, dest:String) {
		if (!FileSystem.isDirectory(dest)) {
			try {
				FileSystem.createDirectory(dest);
			} catch (e:Exception) {
				throw new Exception("Destination should be directory.");
			}
		}

		this.baseSrcPrefix = src;
		this.baseDestPrefix = dest;
		this.currentPrefix = "/";

		if (FileSystem.isDirectory(src)) {
			copyDir(src);
			while (!later.isEmpty()) {
				this.currentPrefix = later.pop();
				copyDir(this.baseSrcPrefix + this.currentPrefix);
			}
		} else {
			File.copy(src, dest + "/" + src);
		}
	}

	private function copyDir(dir:String) {
		var current = FileSystem.readDirectory(dir);
		for (each in current) {
			if (FileSystem.isDirectory(this.baseSrcPrefix + this.currentPrefix + "/" + each)) {
				later.add(this.currentPrefix + each + "/");
				FileSystem.createDirectory(this.baseDestPrefix + this.currentPrefix + each);
			} else {
				File.copy(this.baseSrcPrefix + this.currentPrefix + each, this.baseDestPrefix + this.currentPrefix + each);
			}
		}
	}
}
