package lightninghx;


/**
    A handle to the memory mapped environment.

    An environment's methods are thread-safe except for those noted.
    The methods may throw an `Exception` except for `close()`.

    `close()` must be called to release resources held by this instance.
**/
interface IEnvironment {
    /**
        Open the environment.

        Setting various options, such as the page size, must be done before
        opening the environment.

        Once the environment is opened, it cannot be opened again (from
        within this process) until it is closed. Share this environment with
        threads instead.

        @param path Directory name (or filename if appropriate flags is given).
        @param flags Options for the memory map.
        @param unixMode UNIX permissions such as 0o660.
    **/
    function open(path:String, ?flags:Flags<EnvironmentFlags>, ?unixMode:Int):Void;

    /**
        Copy the environment to another directory.

        Because this operation is a long-lived read-only transaction,
        the file can grow when there are write transactions.

        @param path Directory name.
        @param flags Copy options.
    **/
    function copy(path:String, ?flags:Flags<CopyFlags>):Void;

    /**
        Return statistics about the environment.
    **/
    function stat():Statistics;

    /**
        Return information about the environment.
    **/
    function info():EnvironmentInfo;

    /**
        Flush the data buffers to disk (fsync).

        Sync is called automatically during transaction commit unless
        disabled by option.

        @param force Whether to block until the OS has finished fsync.
    **/
    function sync(force:Bool = false):Void;

    /**
        Release resources held by this instance.

        This method is not thread safe. This instance must not be used after
        calling this method.
    **/
    function close():Void;

    /**
        Set additional options to those given in `open()`.

        This method is not thread safe.

        @param flags Environment options.
        @param clear Whether to remove the options.
    **/
    function setFlags(flags:Flags<EnvironmentFlags>, clear:Bool = false):Void;

    /**
        Return the environment options.
    **/
    function getFlags():Flags<EnvironmentFlags>;

    /**
        Return the path given in `open()`.
    **/
    function getPath():String;

    /**
        Set the maximum size of the database.

        This value is 10 MB by default and will throw exceptions if the
        database grows beyond that. The size should be very large and should
        be a multiple of the OS page size. This value is persisted after the
        first write transaction.

        For details, please see the C documentation for
        the `mdb_env_set_mapsize()` function.

        @param size Size in bytes.
    **/
    function setMapSize(size:#if int32_size Int #else haxe.Int64 #end):Void;

    /**
        Set the maximum number of read transactions.

        This method can only be called by the first process to open
        the environment.
    **/
    function setMaxReaders(size:Int):Void;

    /**
        Return the maximum number of read transactions.
    **/
    function getMaxReaders():Int;

    /**
        Set the maximum number of named databases.

        If other databases besides the unnamed default is required, set
        this to the number needed. Performance may be low for large numbers.
    **/
    function setMaxDatabases(count:Int):Void;

    /**
        Return the maximum size of the key.

        Default is 511 and can be changed by recompiling LMDB.
    **/
    function getMaxKeySize():Int;

    /**
        Returns a new Transaction.

        @param flags Transaction options.
    **/
    function beginTransaction(?flags:Flags<EnvironmentFlags>):ITransaction;

    /**
        Clear stale entires in the reader lock table.

        Returns the number of stale entries removed.
    **/
    function readerCheck():Int;
}
