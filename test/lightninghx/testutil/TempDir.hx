package lightninghx.testutil;

import haxe.crypto.Sha1;
import haxe.io.Path;
import sys.FileSystem;


class TempDir {
    static var tempDirEnvVars = ["TEMP", "TMPDIR", "TEMPDIR", "TMP"];

    public var dirPath(default, null):String;
    var closed = false;

    public function new() {
        this.dirPath = Path.join([
            getTempDir(),
            Sha1.encode(
                Std.string(Std.random(0xffffff))
                + Std.string(Std.random(0xffffff))
                + Std.string(Std.random(0xffffff))
                + Std.string(Sys.time())
            ).substr(0, 16)
        ]);

        FileSystem.createDirectory(this.dirPath);
        trace('Temp dir $dirPath');
    }

    public static function getTempDir():String {
        var path:String = null;

        for (name in tempDirEnvVars) {
            path = Sys.getEnv(name);

            if (path != null) {
                break;
            }
        }

        if (path == null || path == "") {
            path = "/tmp/";
        }

        return Path.addTrailingSlash(path);
    }

    public function close() {
        if (!closed) {
            closed = true;

            deleteDirectories(dirPath);
            trace('Delete $dirPath');
            FileSystem.deleteDirectory(dirPath);
        }
    }

    static function deleteDirectories(path:String) {
        for (name in FileSystem.readDirectory(path)) {
            var subPath = Path.join([path, name]);

            if (FileSystem.isDirectory(subPath)) {
                deleteDirectories(subPath);
                trace('Delete $subPath');
                FileSystem.deleteDirectory(subPath);
            } else {
                trace('Delete $subPath');
                FileSystem.deleteFile(subPath);
            }
        }
    }
}
