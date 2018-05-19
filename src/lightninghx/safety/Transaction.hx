package lightninghx.safety;

import lightninghx.safety.Environment.EnvironmentResourceState as EnvResState;

using lightninghx.safety.SafetyTools;


enum TransactionResourceState {
    Opened;
    Closed;
    Reset;
}

class Transaction implements ITransaction {
    var environment:Environment;

    @:allow(lightninghx.safety.Cursor)
    @:allow(lightninghx.safety.Database)
    var innerTransaction:ITransaction;

    public var resourceState(default, null):TransactionResourceState = Opened;
    public var isReadOnly(default, null):Bool;
    var autoClosingCursors:Array<Cursor>;

    public function new(environment:Environment, innerTransaction:ITransaction,
            isReadOnly:Bool) {
        this.environment = environment;
        this.innerTransaction = innerTransaction;
        this.isReadOnly = isReadOnly;
    }

    function requireEnvironment() {
        environment.resourceState.requireState(EnvResState.Opened);
    }

    public function getEnvironment():IEnvironment {
        return environment;
    }

    public function getID():Int {
        requireEnvironment();
        return innerTransaction.getID();
    }

    public function commit() {
        requireEnvironment();
        resourceState.requireState(Opened);

        innerTransaction.commit();

        resourceState = Closed;
    }

    public function abort() {
        requireEnvironment();
        resourceState.requireState(Opened);

        innerTransaction.abort();

        resourceState = Closed;
    }

    public function reset() {
        requireEnvironment();
        resourceState.requireState(Opened);

        innerTransaction.reset();

        resourceState = Reset;

    }

    public function renew() {
        requireEnvironment();
        resourceState.requireState(Reset);

        innerTransaction.renew();

        resourceState = Opened;
    }


    public function openDatabase(?name:String, ?flags:Flags<DatabaseFlags>):IDatabase {
        requireEnvironment();
        resourceState.requireState(Opened);

        return new Database(
            environment, this, innerTransaction.openDatabase(name, flags)
        );
    }

    public function beginTransaction(?flags:Flags<EnvironmentFlags>):ITransaction {
        requireEnvironment();
        resourceState.requireState(Opened);

        return new Transaction(
            environment,
            innerTransaction.beginTransaction(flags),
            flags.get(EnvironmentFlags.ReadOnly)
        );
    }
}
