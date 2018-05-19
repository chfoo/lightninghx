package lightninghx;

import haxe.io.Bytes;


typedef KeyDataPair = {
    key:Bytes,
    data:Bytes
}

/**
    A handle to navigate and manipulate items.

    A cursor belongs to a transaction and database.

    Since a cursor belongs to a transaction, it is not thread safe.

    Methods may throw exceptions except for `getTransaction()` and
    `getDatabase()`.

    `close()` must be called to release resources held by this instance.
    A cursor will automatically be closed in a write transaction.
**/
interface ICursor {
    /**
        Release resources held by this instance.

        Do not call this method if this cursor belongs to an uncommitted
        transactions.

        This instance must not be used after calling this method except
        for `renew()` in a read-only transaction.
    **/
    function close():Void;

    /**
        Open the cursor again in a read-only transaction.

        @param transaction Read-only transaction.
    **/
    function renew(transaction:ITransaction):Void;

    /**
        Return the associated transaction.
    **/
    function getTransaction():ITransaction;

    /**
        Return the associated database.
    **/
    function getDatabase():IDatabase;

    /**
        Get key-data pair from the database.

        @param operation Where and how to position the cursor.
        @param key Key to search depending on operation.
        @param data Data to search depending on operation.
    **/
    function get(operation:CursorOperation, ?key:Bytes, ?data:Bytes):KeyDataPair;

    /**
        Store key-data pair at the the current position.

        @param key Key of the pair.
        @param data Data of the pair.
        @param flags Cursor options.
    **/
    function put(key:Bytes, data:Bytes, ?flags:Flags<WriteFlags>):Void;

    /**
        Remove  key-data pair at the the current position.

        @param flags Cursor options.
    **/
    function delete(?flags:Flags<WriteFlags>):Void;

    /**
        Return the number of duplicates for the current key.

        This method should only be called for DUPSORT databases.
    **/
    function count():Int;
}
