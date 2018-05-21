package lightninghx;

import haxe.io.Bytes;


/**
    A handle to key-value data table.

    A database belongs to a transaction, however, the database is usually
    reused among transactions. To use this pattern in an object-oriented
    manner, call the `reuse()` method.

    The database can be shared among threads but the methods are not
    thread-safe except for `reuse()`.

    Methods may throw an exception excluding `close()`, `reuse()` and the
    comparison functions.
**/

interface Database {
    /**
        Return new instance associated with the given transaction.

        This method is used to share and reuse databases without releasing
        the underlying database resource and handle.

        @param transaction Any other transaction.
    **/
    function reuse(transaction:Transaction):Database;

    /**
        Return statistics about the database.
    **/
    function stat():Statistics;

    /**
        Return the database options.
    **/
    function getFlags():Flags<DatabaseFlags>;

    /**
        Release resources held by this instance.

        Calling this method is usually unnecessary.

        Do not call this method if there is any open cursors or uncommitted
        transactions.

        This method is not thread safe. This instance must not be used after
        calling this method.
    **/
    function close():Void;

    /**
        Empty or delete the database.

        This method will delete all the keys. If `delete` is true, then
        the database itself will be deleted and closed.

        @param delete Whether to delete and close the database.
    **/
    function drop(delete:Bool = false):Void;

    /**
        Return data for the given key.

        The data returned is a reference to the memory map and must not
        be modified.

        @param key Key used to search.
    **/
    function get(key:Bytes):ReadOnlyBytes;

    /**
        Store the key-data pair.

        @param key Key of the pair.
        @param data Data of the pair.
        @param flags Write options.

        The default behavior is to replace the existing pair if it exists.
    **/
    function put(key:Bytes, data:Bytes, ?flags:Flags<WriteFlags>):Void;

    /**
        Remove items.

        @param key Key to search.
        @param data Data to search if DUPSORT.

        If there is no matching item, an exception is thrown.
    **/
    function delete(key:Bytes, ?data:Bytes):Void;

    /**
        Open a new cursor.
    **/
    function openCursor():Cursor;

    /**
        Return the ordering between two keys.
    **/
    function compareKey(keyA:Bytes, keyB:Bytes):Int;

    /**
        Return the ordering between two values in a DUPSORT database.
    **/
    function compareValue(valueA:Bytes, valueB:Bytes):Int;
}
