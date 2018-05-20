package lightninghx.testutil;

import haxe.crypto.Sha1;
import haxe.io.Bytes;


class BytesGen {
    public static function generateBytes(length:Int, seed:Int = 0):Bytes {
        var hash = Sha1.make(Bytes.ofString(Std.string(seed)));

        var data = Bytes.alloc(length);

        for (index in 0...length) {
            data.set(index, hash.get(index % hash.length));
        }

        return data;
    }
}
