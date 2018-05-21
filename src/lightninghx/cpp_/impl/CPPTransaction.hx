package lightninghx.cpp_.impl;

using lightninghx.cpp_.impl.ImplTools;


class CPPTransaction implements Transaction {
    var env:LMDB.Environment;

    @:allow(lightninghx.cpp_.impl.CPPCursor)
    @:allow(lightninghx.cpp_.impl.CPPDatabase)
    var txn:LMDB.Transaction;

    @:allow(lightninghx.cpp_.impl.CPPCursor)
    @:allow(lightninghx.cpp_.impl.CPPEnvironment)
    function new(env:LMDB.Environment, txn:LMDB.Transaction) {
        this.env = env;
        this.txn = txn;
    }

    public function getEnvironment():Environment {
        return new CPPEnvironment(LMDB.txnEnv(txn));
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

    public function openDatabase(?name:String, ?flags:Flags<DatabaseFlags>):Database {
        flags = flags != null ? flags : new Flags<DatabaseFlags>();
        var mdbDbi = LMDB.dbiOpen.bind(txn, name, flags).withErrorHandler();

        return new CPPDatabase(env, txn, mdbDbi);
    }

    public function beginTransaction(?flags:Flags<EnvironmentFlags>):Transaction {
        flags = flags != null ? flags : new Flags<EnvironmentFlags>();
        var mdbTxn = LMDB.txnBegin.bind(env, txn, flags).withErrorHandler();

        return new CPPTransaction(env, mdbTxn);
    }
}
