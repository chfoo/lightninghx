package lightninghx.safety;

import haxe.io.Bytes;
import lightninghx.ICursor.KeyDataPair;
import lightninghx.safety.Environment.EnvironmentResourceState as EnvResState;
import lightninghx.safety.Transaction.TransactionResourceState as TxnResState;

using lightninghx.safety.SafetyTools;


enum CursorResourceState {
    Opened;
    Closed;
}


class Cursor implements ICursor {
    var environment:Environment;
    var transaction:Transaction;
    var database:Database;
    var innerCursor:ICursor;
    var resourceState:CursorResourceState = Opened;

    public function new(environment:Environment, transaction:Transaction,
            database:Database, innerCursor:ICursor) {
        this.environment = environment;
        this.transaction = transaction;
        this.database = database;
        this.innerCursor = innerCursor;
    }

    function requireEnvironment() {
        environment.resourceState.requireState(EnvResState.Opened);
    }

    function requireTransaction() {
        transaction.resourceState.requireState(TxnResState.Opened);
    }

    public function close() {
        requireEnvironment();

        if (!transaction.isReadOnly) {
            requireTransaction();
        }

        resourceState.requireState(Opened);

        innerCursor.close();
    }

    public function renew(transaction:ITransaction) {
        requireEnvironment();
        resourceState.requireState(Opened);

        var safetyTransaction = cast(transaction, Transaction);

        this.transaction = safetyTransaction;
        innerCursor.renew(safetyTransaction.innerTransaction);

        resourceState = Opened;
    }

    public function getTransaction():ITransaction {
        return transaction;
    }

    public function getDatabase():IDatabase {
        return database;
    }

    public function get(operation:CursorOperation, ?key:Bytes, ?data:Bytes):KeyDataPair {
        requireEnvironment();
        requireTransaction();
        resourceState.requireState(Opened);

        return innerCursor.get(operation, key, data);
    }

    public function put(key:Bytes, data:Bytes, ?flags:Flags<WriteFlags>) {
        requireEnvironment();
        requireTransaction();
        resourceState.requireState(Opened);

        innerCursor.put(key, data, flags);
    }

    public function delete(?flags:Flags<WriteFlags>) {
        requireEnvironment();
        requireTransaction();
        resourceState.requireState(Opened);

        innerCursor.delete(flags);
    }

    public function count():Int {
        requireEnvironment();
        requireTransaction();
        resourceState.requireState(Opened);

        return innerCursor.count();
    }
}
