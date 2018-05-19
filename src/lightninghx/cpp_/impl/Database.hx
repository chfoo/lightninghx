package lightninghx.cpp_.impl;

import haxe.io.Bytes;

using lightninghx.cpp_.impl.ImplTools;


class Database implements IDatabase {
    var env:LMDB.Environment;
    var txn:LMDB.Transaction;
    var dbi:LMDB.Database;

    @:allow(lightninghx.cpp_.impl.Transaction)
    @:allow(lightninghx.cpp_.impl.Cursor)
    function new(env:LMDB.Environment, txn:LMDB.Transaction, dbi:LMDB.Database) {
        this.env = env;
        this.txn = txn;
        this.dbi = dbi;
    }

    public function reuse(transaction:ITransaction):IDatabase {
        var transactionImpl = cast(transaction, Transaction);
        return new Database(env, transactionImpl.txn, dbi);
    }

    public function stat():Statistics {
        var mdbStat = LMDB.stat.bind(txn, dbi).withErrorHandler();

        var stat = {
            pageSize: mdbStat.value.ms_psize,
            depth: mdbStat.value.ms_depth,
            branchPages:mdbStat.value.ms_branch_pages,
            leafPages:mdbStat.value.ms_leaf_pages,
            overflowPages:mdbStat.value.ms_overflow_pages,
            entries:mdbStat.value.ms_entries
        };

        mdbStat.destroy();

        return stat;
    }

    public function getFlags():Flags<DatabaseFlags> {
        return Flags.fromInt(
            LMDB.dbiFlags.bind(txn, dbi).withErrorHandler()
        );
    }

    public function close() {
        LMDB.dbiClose(env, dbi);
    }

    public function drop(delete:Bool = false) {
        LMDB.drop.bind(txn, dbi, delete ? 1 : 0).withErrorHandler();
    }

    public function get(key:Bytes):Bytes {
        var keyMDBValue = LMDB.newMDBValue();
        keyMDBValue.setBytes(key);

        var dataMDBValue = null;

        try {
            dataMDBValue = LMDB.get(txn, dbi, keyMDBValue);
        } catch (exception:Int) {
            keyMDBValue.destroy();
            ImplTools.throwError(exception);
        }

        var dataBytes = dataMDBValue.getBytes();

        keyMDBValue.destroy();
        dataMDBValue.destroy();

        return dataBytes;
    }

    public function put(key:Bytes, data:Bytes, ?flags:Flags<WriteFlags>) {
        flags = flags != null ? flags : new Flags<WriteFlags>();

        var keyMDBValue = LMDB.newMDBValue();
        var dataMDBValue = LMDB.newMDBValue();

        keyMDBValue.setBytes(key);
        dataMDBValue.setBytes(data);

        try {
            LMDB.put(txn, dbi, keyMDBValue, dataMDBValue, flags);
        } catch (exception:Int) {
            keyMDBValue.destroy();
            dataMDBValue.destroy();
            ImplTools.throwError(exception);
        }

        keyMDBValue.destroy();
        dataMDBValue.destroy();
    }

    public function delete(key:Bytes, ?data:Bytes) {
        var keyMDBValue = LMDB.newMDBValue();
        var dataMDBValue = LMDB.newMDBValue();

        keyMDBValue.setBytes(key);

        if (data != null) {
            dataMDBValue.setBytes(data);
        }

        try {
            LMDB.del(txn, dbi, keyMDBValue, dataMDBValue);
        } catch (exception:Int) {
            keyMDBValue.destroy();
            dataMDBValue.destroy();
            ImplTools.throwError(exception);
        }

        keyMDBValue.destroy();
        dataMDBValue.destroy();
    }

    public function openCursor():ICursor {
        var mdbCursor = LMDB.cursorOpen(txn, dbi);

        return new Cursor(env, txn, dbi, mdbCursor);
    }

    public function compareKey(keyA:Bytes, keyB:Bytes):Int {
        var mdbValueA = LMDB.newMDBValue();
        var mdbValueB = LMDB.newMDBValue();

        mdbValueA.setBytes(keyA);
        mdbValueB.setBytes(keyB);

        var result = LMDB.cmp(txn, dbi, mdbValueA, mdbValueB);

        mdbValueA.destroy();
        mdbValueB.destroy();

        return result;
    }

    public function compareValue(valueA:Bytes, valueB:Bytes):Int {
        var mdbValueA = LMDB.newMDBValue();
        var mdbValueB = LMDB.newMDBValue();

        mdbValueA.setBytes(valueA);
        mdbValueB.setBytes(valueB);

        var result = LMDB.dcmp(txn, dbi, mdbValueA, mdbValueB);

        mdbValueA.destroy();
        mdbValueB.destroy();

        return result;
    }
}
