package lightninghx.safety;

import lightninghx.safety.SafetyEnvironment.EnvironmentResourceState as EnvResState;

using lightninghx.safety.SafetyTools;


enum TransactionResourceState {
    Opened;
    Closed;
    Reset;
}

class SafetyTransaction implements Transaction {
    var environment:SafetyEnvironment;

    @:allow(lightninghx.safety.SafetyCursor)
    @:allow(lightninghx.safety.SafetyDatabase)
    var innerTransaction:Transaction;

    public var resourceState(default, null):TransactionResourceState = Opened;
    public var isReadOnly(default, null):Bool;
    var autoClosingCursors:Array<Cursor>;

    public function new(environment:SafetyEnvironment,
            innerTransaction:Transaction, isReadOnly:Bool) {
        this.environment = environment;
        this.innerTransaction = innerTransaction;
        this.isReadOnly = isReadOnly;
    }

    function requireEnvironment() {
        environment.resourceState.requireState(EnvResState.Opened);
    }

    public function getEnvironment():Environment {
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


    public function openDatabase(?name:String, ?flags:Flags<DatabaseFlags>):Database {
        requireEnvironment();
        resourceState.requireState(Opened);

        return new SafetyDatabase(
            environment, this, innerTransaction.openDatabase(name, flags)
        );
    }

    public function beginTransaction(?flags:Flags<EnvironmentFlags>):Transaction {
        requireEnvironment();
        resourceState.requireState(Opened);

        return new SafetyTransaction(
            environment,
            innerTransaction.beginTransaction(flags),
            flags.get(EnvironmentFlags.ReadOnly)
        );
    }
}
