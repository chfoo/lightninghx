package lightninghx.tests;

import haxe.io.Bytes;
import lightninghx.testutil.TempDir;
import utest.Assert;


class TestCursor {
    public function new() {
    }

    public function testCursorOpenClose() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);
        var transaction = env.beginTransaction();
        var database = transaction.openDatabase();

        var cursor = database.openCursor();
        cursor.close();

        Assert.equals(0, env.readerCheck());

        transaction.abort();
        env.close();
        dir.close();
    }

    public function testCursorRenew() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);
        var transaction = env.beginTransaction(EnvironmentFlags.ReadOnly);
        var database = transaction.openDatabase();

        var cursor = database.openCursor();
        transaction.abort();

        transaction = env.beginTransaction(EnvironmentFlags.ReadOnly);
        database = transaction.openDatabase();

        cursor.renew(transaction);

        Assert.equals(0, env.readerCheck());

        env.close();
        dir.close();
    }

    public function testCursorGetters() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);
        var transaction = env.beginTransaction();
        var database = transaction.openDatabase();

        var cursor = database.openCursor();
        var resultTransaction = cursor.getTransaction();
        var resultDatabase = cursor.getDatabase();

        Assert.notNull(resultTransaction);
        Assert.notNull(resultDatabase);

        transaction.abort();
        env.close();
        dir.close();
    }

    public function testCursorGet() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);
        var transaction = env.beginTransaction();
        var database = transaction.openDatabase();

        database.put(Bytes.ofString("key-a"), Bytes.ofString("data-a"));
        database.put(Bytes.ofString("key-b"), Bytes.ofString("data-b"));

        var cursor = database.openCursor();

        var result = cursor.get(CursorOperation.First);
        Assert.equals("key-a", result.key.toString());
        Assert.equals("data-a", result.data.toString());

        result = cursor.get(CursorOperation.Next);
        Assert.equals("key-b", result.key.toString());
        Assert.equals("data-b", result.data.toString());

        transaction.abort();
        env.close();
        dir.close();
    }

    public function testCursorPut() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);
        var transaction = env.beginTransaction();
        var database = transaction.openDatabase();

        database.put(Bytes.ofString("key-a"), Bytes.ofString("data-a"));

        var cursor = database.openCursor();

        cursor.get(CursorOperation.First);
        cursor.put(Bytes.ofString("key-a"), Bytes.ofString("data-a-1"));

        var result = cursor.get(CursorOperation.GetCurrent);
        Assert.equals("key-a", result.key.toString());
        Assert.equals("data-a-1", result.data.toString());

        transaction.abort();
        env.close();
        dir.close();
    }

    public function testCursorDelete() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);
        var transaction = env.beginTransaction();
        var database = transaction.openDatabase();

        database.put(Bytes.ofString("key-a"), Bytes.ofString("data-a"));

        var cursor = database.openCursor();

        cursor.get(CursorOperation.First);
        cursor.delete();

        Assert.raises(
            cursor.get.bind(CursorOperation.First),
            Exception.NotFoundException
        );

        transaction.abort();
        env.close();
        dir.close();
    }

    public function testCursorCount() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);
        var transaction = env.beginTransaction();
        var database = transaction.openDatabase(DatabaseFlags.DupSort);

        database.put(Bytes.ofString("key-a"), Bytes.ofString("data-a"));
        database.put(Bytes.ofString("key-a"), Bytes.ofString("data-b"));

        var cursor = database.openCursor();

        cursor.get(CursorOperation.First);
        Assert.equals(2, cursor.count());

        transaction.abort();
        env.close();
        dir.close();
    }
}
