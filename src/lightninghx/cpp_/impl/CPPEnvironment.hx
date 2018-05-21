package lightninghx.cpp_.impl;

using lightninghx.cpp_.impl.ImplTools;


class CPPEnvironment implements Environment {
    var env:LMDB.Environment;

    @:allow(lightninghx.cpp_.impl.CPPTransaction)
    function new(env:LMDB.Environment) {
        this.env = env;
    }

    public static function create() {
        return new CPPEnvironment(LMDB.envCreate.bind().withErrorHandler());
    }

    public function open(path:String, ?flags:Flags<EnvironmentFlags>, ?unixMode:Int) {
        if (flags == null) {
            flags = new Flags<EnvironmentFlags>();
        }

        if (unixMode == null) {
            unixMode = 0x01B0; // Octal 660
        }

        LMDB.envOpen.bind(env, path, flags, unixMode).withErrorHandler();
    }

    public function copy(path:String, ?flags:Flags<CopyFlags>) {
        if (flags != null) {
            LMDB.envCopy2.bind(env, path, flags).withErrorHandler();
        } else {
            LMDB.envCopy.bind(env, path).withErrorHandler();
        }
    }

    public function stat():Statistics {
        var mdbStat = LMDB.envStat.bind(env).withErrorHandler();

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

    public function info():EnvironmentInfo {
        var mdbInfo = LMDB.envInfo.bind(env).withErrorHandler();

        var info = {
            mapSize: mdbInfo.value.me_mapsize,
            lastPageNumber: mdbInfo.value.me_last_pgno,
            lastTransactionID: mdbInfo.value.me_last_txnid,
            maxReaders: mdbInfo.value.me_maxreaders,
            numReaders: mdbInfo.value.me_numreaders
        };

        mdbInfo.destroy();

        return info;
    }

    public function sync(force:Bool = false) {
        LMDB.envSync.bind(env, force ? 1 : 0).withErrorHandler();
    }

    public function close() {
        LMDB.envClose(env);
    }

    public function setFlags(flags:Flags<EnvironmentFlags>, clear:Bool = false) {
        if (clear) {
            LMDB.envSetFlags.bind(env, flags, 0).withErrorHandler();
        } else {
            LMDB.envSetFlags.bind(env, flags, 1).withErrorHandler();
        }
    }

    public function getFlags():Flags<EnvironmentFlags> {
        return Flags.fromInt(
            LMDB.envGetFlags.bind(env).withErrorHandler()
        );
    }

    public function getPath():String {
        return LMDB.envGetPath.bind(env).withErrorHandler();
    }

    public function setMapSize(size:#if int32_size Int #else haxe.Int64 #end) {
        LMDB.envSetMapSize.bind(env, size).withErrorHandler();
    }

    public function setMaxReaders(count:Int) {
        LMDB.envSetMaxReaders.bind(env, count).withErrorHandler();
    }

    public function getMaxReaders():Int {
        return LMDB.envGetMaxReaders.bind(env).withErrorHandler();
    }

    public function setMaxDatabases(count:Int) {
        LMDB.envSetMaxDBs.bind(env, count).withErrorHandler();
    }

    public function getMaxKeySize():Int {
        return LMDB.envGetMaxKeySize(env);
    }

    public function beginTransaction(?flags:Flags<EnvironmentFlags>):Transaction {
        flags = flags != null ? flags : new Flags<EnvironmentFlags>();
        var mdbTxn = LMDB.txnBegin.bind(env, null, flags).withErrorHandler();

        return new CPPTransaction(env, mdbTxn);
    }

    public function readerCheck():Int {
        return LMDB.readerCheck.bind(env).withErrorHandler();
    }
}
