package lightninghx;


/**
    Write options.
**/
@:enum
abstract WriteFlags(Int) to Int {
    @:to
    public inline function toFlags():Flags<WriteFlags> {
        return Flags.fromInt(this);
    }

    /**
        * put: Don't write if key exists.
    **/
    var NoOverwrite = 0x10;

    /**
        * put: Don't write if key-data pair exists.
        * cursor delete: Remove duplicates.
    **/
    var NoDupData = 0x20;

    /**
        * put: Overwrite current key-data pair.
    **/
    var Current = 0x40;

    /**
        * put: Reserve space for data and return a pointer to the space.

        Don't use this in Haxe.
    **/
    var Reserve = 0x10000;

    /**
        Data is being appended, don't split full pages.
    **/
    var Append = 0x20000;

    /**
        Duplicate data is being appended, don't split full pages.
    **/
    var AppendDup = 0x40000;

    /**
        Store multiple data items in one call. Only for MDB_DUPFIXED.
    **/
    var Multiple = 0x80000;
}
