package lightninghx;

/**
    Environment options.
**/
@:enum
abstract EnvironmentFlags(Int) to Int {
    @:to
    public inline function toFlags():Flags<EnvironmentFlags> {
        return Flags.fromInt(this);
    }

    /**
        mmap at a fixed address (experimental).

        This is not useful in Haxe.
    **/
    var FixedMap = 0x01;

    /**
        Don't use a directory, but use a filename prefix instead.
    **/
    var NoSubDir = 0x4000;

    /**
        Don't call fsync after commit.
    **/
    var NoSync = 0x10000;

    /**
        Open as read-only.
    **/
    var ReadOnly = 0x20000;

    /**
        Don't call fsync (metadata), but fdatasync, after commit.
    **/
    var NoMetaSync = 0x40000;

    /**
        Avoid malloc to get pages and write directly to the memory map.

        This favors performance over safety. It is possible for buggy
        code to overwrite wrong pages and corrupt the database.

        Do not mix this option with other processes.
    **/
    var WriteMap = 0x80000;

    /**
        Don't wait for fsync when `WriteMap` is specified.
    **/
    var MapAsync = 0x100000;

    /**
        Don't associate reader lock slots to threads.

        This option associates readers to transactions instead of threads.
        Read-only transactions can be shared by threads and multiple read-only
        transactions can be held by a thread.
    **/
    var NoTLS = 0x200000;

    /**
        Don't use locking.

        The caller will need to manage concurrency themselves.
    **/
    var NoLock = 0x400000;

    /**
        Don't read additional data around the current data if supported by OS.

        This option disables optimization for sequential data access and
        may improve performance of random data access.
    **/
    var NoReadAhead = 0x800000;

    /**
        Don't clear unused memory to zeros before writing to disk.

        This favors performance over protecting data leaks. This has no effect
        when `WriteMap` is specified.
    **/
    var NoMemInit = 0x1000000;
}
