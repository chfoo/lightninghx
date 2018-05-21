package lightninghx.cpp_.impl;

import haxe.io.Bytes;
import lightninghx.Cursor.KeyDataPair;

using lightninghx.cpp_.impl.ImplTools;


class CPPCursor implements Cursor {
    var env:LMDB.Environment;
    var txn:LMDB.Transaction;
    var dbi:LMDB.Database;
    var cursor:LMDB.Cursor;

    @:allow(lightninghx.cpp_.impl.CPPDatabase)
    function new(env:LMDB.Environment, txn:LMDB.Transaction, dbi:LMDB.Database,
            cursor:LMDB.Cursor) {
        this.env = env;
        this.txn = txn;
        this.dbi = dbi;
        this.cursor = cursor;
    }

    public function close() {
        LMDB.cursorClose(cursor);
    }

    public function renew(transaction:Transaction) {
        var transactionImpl = cast(transaction, CPPTransaction);
        txn = transactionImpl.txn;
        LMDB.cursorRenew.bind(txn, cursor).withErrorHandler();
    }

    public function getTransaction():Transaction {
        return new CPPTransaction(env, txn);
    }

    public function getDatabase():Database {
        return new CPPDatabase(env, txn, dbi);
    }

    public function get(operation:CursorOperation, ?key:Bytes, ?data:Bytes):KeyDataPair {
        var keyMDBValue = LMDB.newMDBValue();
        var dataMDBValue = LMDB.newMDBValue();

        if (key != null) {
            keyMDBValue.setBytes(key);
        }
        if (data != null) {
            dataMDBValue.setBytes(data);
        }

        try {
            LMDB.cursorGet(cursor, keyMDBValue, dataMDBValue,
                operation.cursorOpToNativeEnum());
        } catch (exception:Int) {
            keyMDBValue.destroy();
            dataMDBValue.destroy();
            ImplTools.throwError(exception);
        }

        var keyBytes = keyMDBValue.getBytes();
        var dataBytes = dataMDBValue.getBytes();

        keyMDBValue.destroy();
        dataMDBValue.destroy();

        return {
            key: new ReadOnlyBytes(keyBytes),
            data: new ReadOnlyBytes(dataBytes)
        };
    }

    public function put(key:Bytes, data:Bytes, ?flags:Flags<WriteFlags>) {
        flags = flags != null ? flags : new Flags<WriteFlags>();

        var keyMDBValue = LMDB.newMDBValue();
        var dataMDBValue = LMDB.newMDBValue();

        keyMDBValue.setBytes(key);
        dataMDBValue.setBytes(data);

        try {
            LMDB.cursorPut(cursor, keyMDBValue, dataMDBValue, flags);
        } catch (exception:Int) {
            keyMDBValue.destroy();
            dataMDBValue.destroy();
            ImplTools.throwError(exception);
        }

        keyMDBValue.destroy();
        dataMDBValue.destroy();
    }

    public function delete(?flags:Flags<WriteFlags>) {
        flags = flags != null ? flags : new Flags<WriteFlags>();

        LMDB.cursorDel.bind(cursor, flags).withErrorHandler();
    }

    public function count():Int {
        return LMDB.cursorCount.bind(cursor).withErrorHandler();
    }
}
