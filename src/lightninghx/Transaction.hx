package lightninghx;

/**
    A handle to read and write data in the environment.

    Transactions should not be kept open for long times. Read-only long-lived
    transactions hold on to old data if there is new writes. Write long-lived
    transactions block other write transactions.

    A transaction cannot be shared among threads. A thread can only have
    a single transaction at a time. A transaction belongs to a single
    environment. Read-only transactions may be made thread-safe with an
    appropriate environment option.

    Methods may throw an exception excluding `getEnvironment()` and `getID()`.

    To release resources held by this instance, one of `commit()`, `abort()`,
    or `reset()` must be called.
**/
interface Transaction {
    /**
        Return the associated environment.
    **/
    function getEnvironment():Environment;

    /**
        Return an associated identifier.
    **/
    function getID():Int;

    /**
        Persist the changes and close the transaction.

        Any cursors in a write transaction is automatically closed.

        This instance may not be used after calling this method.
    **/
    function commit():Void;

    /**
        Undo the changes and close the transaction.

        Any cursors in a write transaction is automatically closed.

        This instance may not be used after calling this method.
    **/
    function abort():Void;

    /**
        Abort the read-only transaction, but do not release resources.

        This method reduces overhead of creating a new read-only transaction
        and releases read locks. To start a new read-only transaction
        with this instance, call `renew()`.
    **/
    function reset():Void;

    /**
        Start a new read-only transaction.

        This method can only be called when `reset()` has been called.
    **/
    function renew():Void;

    /**
        Open a database for reading or writing data.

        Generally, databases are opened once in the first transaction and the
        databases are reused subsequent transactions. To make use of this
        pattern, see `Database`.

        @param name Name of the database if a named database is required.
        @param flags Database options.
    **/
    function openDatabase(?name:String, ?flags:Flags<DatabaseFlags>):Database;

    /**
        Start a nested transaction.

        This instance may not be used until the nested transaction is closed.
    **/
    function beginTransaction(?flags:Flags<EnvironmentFlags>):Transaction;
}
