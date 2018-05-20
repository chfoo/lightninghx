package lightninghx;

import haxe.io.Bytes;

/**
    Read-only interface to a Bytes instance.
**/
@:forward(
    length, get, sub, compare,
    getDouble, getFloat, getUInt16, getInt32,
    getString, toString, toHex)
abstract ReadOnlyBytes(Bytes) {
    inline public function new(bytes:Bytes) {
        this = bytes;
    }

    /**
        Return Bytes with a copy of the BytesData.
    **/
    // Don't put `@:to` here because copying is a different operation
    // than type conversion conceptually
    public function toBytes():Bytes {
        var copy = Bytes.alloc(this.length);
        copy.blit(0, this, 0, this.length);
        return copy;
    }
}
