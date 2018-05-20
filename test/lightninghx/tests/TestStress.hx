package lightninghx.tests;

import haxe.io.Bytes;
import lightninghx.testutil.BytesGen;
import lightninghx.testutil.TempDir;
import utest.Assert;


class TestStress {
    public function new() {
    }

    public function testStress() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.setMapSize(999999999);
        env.open(dir.dirPath, EnvironmentFlags.NoSync);
        var session = new Session(env);
        var differences = 0;

        for (seed in 0...100) {
            var expectedPairs = session.putPairs(seed);
            var resultPairs = session.getPairs(seed);

            differences += checkPairs(expectedPairs, resultPairs);

            if (seed % 2 == 0) {
                session.deletePairs(seed);
            }
        }

        Assert.equals(0, differences);

        dir.close();
    }

    function checkPairs(expectedPairs:Array<Pair>, resultPairs:Array<Pair>):Int {
        var expectedMap = new Map<String,String>();
        var differences = 0;

        for (pair in expectedPairs) {
            expectedMap.set(pair.key.toHex(), pair.data.toHex());
        }

        for (pair in resultPairs) {
            var expectedData = expectedMap.get(pair.key.toHex());

            if (expectedData == null) {
                trace('unknown key ${pair.key.toHex()}');
                differences += 1;
            }

            if (expectedData != pair.data.toHex()) {
                trace('key has different data ${pair.key.toHex()}');
                differences += 1;
            }
        }

        return differences;
    }
}

private typedef Pair = {
    key:Bytes,
    data:Bytes
};

private class Session {
    var environment:IEnvironment;
    var database:IDatabase;

    public function new(environment:IEnvironment) {
        this.environment = environment;

        var transaction = environment.beginTransaction();
        database = transaction.openDatabase();
        transaction.abort();
    }

    public function putPairs(seed:Int):Array<Pair> {
        var transaction = environment.beginTransaction();
        var database = database.reuse(transaction);

        var amount = (seed & 0xffffff) % 100;
        seed = deriveSeed(seed);

        var pairs = [];

        for (dummy in 0...amount) {
            var pair = derivePair(seed);
            seed = deriveSeed(seed);
            pairs.push(pair);
            database.put(pair.key, pair.data);
        }

        transaction.commit();

        return pairs;
    }

    public function getPairs(seed:Int):Array<Pair> {
        var transaction = environment.beginTransaction(EnvironmentFlags.ReadOnly);
        var database = database.reuse(transaction);

        var amount = (seed & 0xffffff) % 100;
        seed = deriveSeed(seed);

        var pairs = [];

        for (dummy in 0...amount) {
            var pair = derivePair(seed);
            seed = deriveSeed(seed);
            var data = database.get(pair.key);
            pairs.push({ key: pair.key, data: data });
        }

        transaction.abort();

        return pairs;
    }

    public function deletePairs(seed:Int) {
        var transaction = environment.beginTransaction();
        var database = database.reuse(transaction);

        var amount = (seed & 0xffffff) % 100;
        seed = deriveSeed(seed);
        var keysSeen = [];

        for (dummy in 0...amount) {
            var pair = derivePair(seed);
            seed = deriveSeed(seed);

            if (keysSeen.indexOf(pair.key.toHex()) < 0) {
                database.delete(pair.key);
                keysSeen.push(pair.key.toHex());
            }
        }

        transaction.commit();
    }

    inline public static function deriveSeed(seed:Int):Int {
        // Galois LFSR
        if (seed == 0) {
            seed = 1;
        }

        var lsb = seed & 1;
        seed >>= 1;

        if (lsb == 1) {
            seed ^= (1 << 31) | (1 << 21) | (1 << 1) | 1; // taps 32, 22, 2, 1
        }
        return seed;
    }

    public static function derivePair(seed):Pair {
        var keyLength;
        if (seed & 0xff < 200) {
            keyLength = (seed & 0xffffff) % 15 + 1;
        } else {
            keyLength = (seed & 0xffffff) % 510 + 1;
        }
        seed = deriveSeed(seed);
        var keySeed = seed;
        seed = deriveSeed(seed);
        var dataLength;
        if (seed & 0xff < 150) {
            dataLength = (seed & 0xffffff) % 256;
        } else if (seed & 0xff < 200) {
            dataLength = (seed & 0xffffff) % 1024;
        } else if (seed & 0xff < 250) {
            dataLength = (seed & 0xffffff) % 4096;
        } else {
            dataLength = (seed & 0xffffff) % 0xffff;
        }
        seed = deriveSeed(seed);
        var dataSeed = seed;

        var key = BytesGen.generateBytes(keyLength, keySeed);
        var data = BytesGen.generateBytes(dataLength, dataSeed);

        // trace('pair ${key.length} ${data.length}');

        return { key: key, data: data };
    }
}
