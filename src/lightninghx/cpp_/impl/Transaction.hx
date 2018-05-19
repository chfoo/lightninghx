package lightninghx.cpp_.impl;

using lightninghx.cpp_.impl.ImplTools;


class Transaction implements ITransaction {
    var env:LMDB.Environment;

    @:allow(lightninghx.cpp_.impl.Cursor)
    @:allow(lightninghx.cpp_.impl.Database)
    var txn:LMDB.Transaction;

    @:allow(lightninghx.cpp_.impl.Cursor)
    @:allow(lightninghx.cpp_.impl.Environment)
    function new(env:LMDB.Environment, txn:LMDB.Transaction) {
        this.env = env;
        this.txn = txn;
    }

    public function getEnvironment():IEnvironment {
        return new Environment(LMDB.txnEnv(txn));
    }

    public function getID():Int {
        return LMDB.txnId(txn);
    }

    public function commit() {
        LMDB.txnCommit.bind(txn).withErrorHandler();
    }

    public function abort() {
        LMDB.txnAbort.bind(txn).withErrorHandler();
    }

    public function reset() {
        LMDB.txnReset.bind(txn).withErrorHandler();
    }

    public function renew() {
        LMDB.txnRenew.bind(txn).withErrorHandler();
    }

    public function openDatabase(?name:String, ?flags:Flags<DatabaseFlags>):IDatabase {
        flags = flags != null ? flags : new Flags<DatabaseFlags>();
        var mdbDbi = LMDB.dbiOpen.bind(txn, name, flags).withErrorHandler();

        return new Database(env, txn, mdbDbi);
    }

    public function beginTransaction(?flags:Flags<EnvironmentFlags>):ITransaction {
        flags = flags != null ? flags : new Flags<EnvironmentFlags>();
        var mdbTxn = LMDB.txnBegin.bind(env, txn, flags).withErrorHandler();

        return new Transaction(env, mdbTxn);
    }
}
