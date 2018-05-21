package lightninghx.safety;

import haxe.io.Bytes;
import lightninghx.safety.SafetyEnvironment.EnvironmentResourceState as EnvResState;
import lightninghx.safety.SafetyTransaction.TransactionResourceState as TxnResState;

using lightninghx.safety.SafetyTools;


enum DatabaseResourceState {
    Opened;
    Closed;
}


class SafetyDatabase implements Database {
    var environment:SafetyEnvironment;
    var transaction:SafetyTransaction;
    var innerDatabase:Database;
    var resourceState:DatabaseResourceState = Opened;

    public function new(environment:SafetyEnvironment,
            transaction:SafetyTransaction, innerDatabase:Database) {
        this.environment = environment;
        this.transaction = transaction;
        this.innerDatabase = innerDatabase;
    }

    function requireEnvironmentAndTransaction() {
        environment.resourceState.requireState(EnvResState.Opened);
        transaction.resourceState.requireState(TxnResState.Opened);
    }

    public function reuse(transaction:Transaction):Database {
        var safetyTransaction = cast(transaction, SafetyTransaction);

        return new SafetyDatabase(
            environment,
            safetyTransaction,
            innerDatabase.reuse(safetyTransaction.innerTransaction)
        );
    }

    public function stat():Statistics {
        requireEnvironmentAndTransaction();
        resourceState.requireState(Opened);

        return innerDatabase.stat();
    }

    public function getFlags():Flags<DatabaseFlags> {
        requireEnvironmentAndTransaction();
        resourceState.requireState(Opened);

        return innerDatabase.getFlags();
    }

    public function close() {
        requireEnvironmentAndTransaction();
        resourceState.requireState(Opened);

        innerDatabase.close();

        resourceState = Closed;
    }

    public function drop(delete:Bool = false) {
        requireEnvironmentAndTransaction();
        resourceState.requireState(Opened);

        innerDatabase.drop(delete);
    }

    public function get(key:Bytes):ReadOnlyBytes {
        requireEnvironmentAndTransaction();
        resourceState.requireState(Opened);

        return innerDatabase.get(key);
    }

    public function put(key:Bytes, data:Bytes, ?flags:Flags<WriteFlags>) {
        requireEnvironmentAndTransaction();
        resourceState.requireState(Opened);

        innerDatabase.put(key, data, flags);
    }

    public function delete(key:Bytes, ?data:Bytes) {
        requireEnvironmentAndTransaction();
        resourceState.requireState(Opened);

        innerDatabase.delete(key, data);
    }

    public function openCursor():Cursor {
        requireEnvironmentAndTransaction();

        return new SafetyCursor(
            environment,
            transaction,
            this,
            innerDatabase.openCursor()
        );
    }

    public function compareKey(keyA:Bytes, keyB:Bytes):Int {
        requireEnvironmentAndTransaction();
        resourceState.requireState(Opened);

        return innerDatabase.compareKey(keyA, keyB);
    }

    public function compareValue(valueA:Bytes, valueB:Bytes):Int {
        requireEnvironmentAndTransaction();
        resourceState.requireState(Opened);

        var isDupSort = innerDatabase.getFlags().get(DatabaseFlags.DupSort);

        if (!isDupSort) {
            throw new Exception.InvalidStateException("Not a dupsort database");
        }

        return innerDatabase.compareValue(valueA, valueB);
    }
}
