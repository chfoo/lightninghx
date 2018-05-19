package lightninghx.tests;

import haxe.io.Bytes;
import lightninghx.testutil.TempDir;
import utest.Assert;


class TestDatabase {
    public function new() {
    }

    public function testReuse() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);

        var transaction = env.beginTransaction();
        var database = transaction.openDatabase();
        database.put(Bytes.ofString("key"), Bytes.ofString("1"));
        transaction.commit();

        transaction = env.beginTransaction();
        database = database.reuse(transaction);
        var result = database.get(Bytes.ofString("key"));

        Assert.equals("1", result.toString());

        transaction.abort();
        env.close();
        dir.close();
    }

    public function testGetStats() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);

        var transaction = env.beginTransaction();
        var database = transaction.openDatabase();
        var stats = database.stat();

        Assert.notEquals(0, stats.pageSize);

        transaction.abort();
        env.close();
        dir.close();
    }

    public function testOpenClose() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.setMaxDatabases(1);
        env.open(dir.dirPath);
        var transaction = env.beginTransaction();

        var flags = new Flags() | DatabaseFlags.DupSort | DatabaseFlags.Create;
        var database = transaction.openDatabase("abc", flags);
        database.close();

        Assert.equals(0, env.readerCheck());

        transaction.abort();
        env.close();
        dir.close();
    }

    public function testGetFlags() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);
        var transaction = env.beginTransaction();

        var flags = new Flags() | DatabaseFlags.DupSort | DatabaseFlags.ReverseKey;
        var database = transaction.openDatabase(null, flags);

        Assert.isTrue(database.getFlags().get(DatabaseFlags.DupSort));
        Assert.isTrue(database.getFlags().get(DatabaseFlags.ReverseKey));

        transaction.abort();
        env.close();
        dir.close();
    }

    public function testDrop() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);
        var transaction = env.beginTransaction();

        var database = transaction.openDatabase();
        database.drop();

        Assert.equals(0, env.readerCheck());

        transaction.abort();
        env.close();
        dir.close();
    }

    public function testGetNonExistent() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);
        var transaction = env.beginTransaction();

        var database = transaction.openDatabase();
        Assert.raises(
            database.get.bind(Bytes.ofString("no-exist")),
            Exception.NotFoundException
        );

        transaction.abort();
        env.close();
        dir.close();
    }

    public function testPutAndGet() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);
        var transaction = env.beginTransaction();

        var database = transaction.openDatabase();
        database.put(Bytes.ofString("my-key"), Bytes.ofString("my-data"));

        var result = database.get(Bytes.ofString("my-key"));
        Assert.equals("my-data", result.toString());

        transaction.abort();
        env.close();
        dir.close();
    }

    public function testPutAndDelete() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);
        var transaction = env.beginTransaction();

        var database = transaction.openDatabase();
        database.put(Bytes.ofString("my-key"), Bytes.ofString("my-data"));
        database.delete(Bytes.ofString("my-key"));
        Assert.raises(
            database.get.bind(Bytes.ofString("my-key")),
            Exception.NotFoundException
        );

        transaction.abort();
        env.close();
        dir.close();
    }

    public function testCompare() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);
        var transaction = env.beginTransaction();

        var database = transaction.openDatabase(DatabaseFlags.DupSort);

        Assert.equals(
            -1,
            database.compareKey(Bytes.ofString("a"), Bytes.ofString("b"))
        );
        Assert.equals(
            0,
            database.compareKey(Bytes.ofString("b"), Bytes.ofString("b"))
        );
        Assert.equals(
            1,
            database.compareKey(Bytes.ofString("c"), Bytes.ofString("b"))
        );

        Assert.equals(
            -1,
            database.compareValue(Bytes.ofString("a"), Bytes.ofString("b"))
        );
        Assert.equals(
            0,
            database.compareValue(Bytes.ofString("b"), Bytes.ofString("b"))
        );
        Assert.equals(
            1,
            database.compareValue(Bytes.ofString("c"), Bytes.ofString("b"))
        );

        transaction.abort();
        env.close();
        dir.close();
    }
}
