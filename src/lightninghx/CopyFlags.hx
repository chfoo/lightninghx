package lightninghx;


/**
    Copy options.
**/
@:enum
abstract CopyFlags(Int) to Int {
    @:to
    public inline function toFlags():Flags<CopyFlags> {
        return Flags.fromInt(this);
    }

    /**
        Don't copy free space and renumber all pages sequentially.

        This is slower.
    **/
    var Compact = 0x01;
}
