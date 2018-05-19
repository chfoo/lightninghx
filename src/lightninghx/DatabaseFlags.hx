package lightninghx;


/**
    Database options.
**/
@:enum
abstract DatabaseFlags(Int) to Int {
    @:to
    public inline function toFlags():Flags<DatabaseFlags> {
        return Flags.fromInt(this);
    }

    /**
        Compare the keys in reverse order.
    **/
    var ReverseKey = 0x02;

    /**
        Allow duplicate keys.

        Each key has multiple data items which are also sorted.
    **/
    var DupSort = 0x04;

    /**
        Treat the keys as native integers rather than sort by string comparison.
    **/
    var IntegerKey = 0x08;

    /**
        Data items are all the same size in a DUPSORT database.

        This allows optimizations.
    **/
    var DupFixed = 0x10;

    /**
        Treat the data items as integers too in a DUPSORT database.
    **/
    var IntegerDup = 0x20;

    /**
        Sort the data items in reverse in a DUPSORT database.
    **/
    var ReverseDup = 0x40;

    /**
        Create the named database if the named database does not exist.
    **/
    var Create = 0x40000;
}
