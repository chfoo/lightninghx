package lightninghx.safety;

import haxe.io.Bytes;
import lightninghx.Cursor.KeyDataPair;
import lightninghx.safety.SafetyEnvironment.EnvironmentResourceState as EnvResState;
import lightninghx.safety.SafetyTransaction.TransactionResourceState as TxnResState;

using lightninghx.safety.SafetyTools;


enum CursorResourceState {
    Opened;
    Closed;
}


class SafetyCursor implements Cursor {
    var environment:SafetyEnvironment;
    var transaction:SafetyTransaction;
    var database:SafetyDatabase;
    var innerCursor:Cursor;
    var resourceState:CursorResourceState = Opened;

    public function new(environment:SafetyEnvironment,
            transaction:SafetyTransaction, database:SafetyDatabase,
            innerCursor:Cursor) {
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

    public function renew(transaction:Transaction) {
        requireEnvironment();
        resourceState.requireState(Opened);

        var safetyTransaction = cast(transaction, SafetyTransaction);

        this.transaction = safetyTransaction;
        innerCursor.renew(safetyTransaction.innerTransaction);

        resourceState = Opened;
    }

    public function getTransaction():Transaction {
        return transaction;
    }

    public function getDatabase():Database {
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
