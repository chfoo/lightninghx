package lightninghx.safety;

import haxe.io.Bytes;
import lightninghx.safety.Environment.EnvironmentResourceState as EnvResState;
import lightninghx.safety.Transaction.TransactionResourceState as TxnResState;

using lightninghx.safety.SafetyTools;


enum DatabaseResourceState {
    Opened;
    Closed;
}


class Database implements IDatabase {
    var environment:Environment;
    var transaction:Transaction;
    var innerDatabase:IDatabase;
    var resourceState:DatabaseResourceState = Opened;

    public function new(environment:Environment, transaction:Transaction,
            innerDatabase:IDatabase) {
        this.environment = environment;
        this.transaction = transaction;
        this.innerDatabase = innerDatabase;
    }

    function requireEnvironmentAndTransaction() {
        environment.resourceState.requireState(EnvResState.Opened);
        transaction.resourceState.requireState(TxnResState.Opened);
    }

    public function reuse(transaction:ITransaction):IDatabase {
        var safetyTransaction = cast(transaction, Transaction);

        return new Database(
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

    public function get(key:Bytes):Bytes {
        requireEnvironmentAndTransaction();
        resourceState.requireState(Opened);

        var data = innerDatabase.get(key);
        var copy = Bytes.alloc(data.length);
        copy.blit(0, data, 0, data.length);

        return copy;
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

    public function openCursor():ICursor {
        requireEnvironmentAndTransaction();

        return new Cursor(
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
