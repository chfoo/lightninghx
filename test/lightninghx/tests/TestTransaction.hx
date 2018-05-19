package lightninghx.tests;

import lightninghx.testutil.TempDir;
import utest.Assert;


class TestTransaction {
    public function new() {
    }

    public function testGetters() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);

        var transaction = env.beginTransaction();

        var env2 = transaction.getEnvironment();
        var id = transaction.getID();

        Assert.notNull(env2);
        Assert.notEquals(0, id);

        env.close();
        dir.close();
    }

    public function testCommit() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);

        var transaction = env.beginTransaction();
        transaction.commit();
        Assert.equals(0, env.readerCheck());

        env.close();
        dir.close();
    }

    public function testAbort() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);

        var transaction = env.beginTransaction();
        transaction.abort();
        Assert.equals(0, env.readerCheck());

        env.close();
        dir.close();
    }

    public function testReset() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);

        var transaction = env.beginTransaction(EnvironmentFlags.ReadOnly);
        transaction.reset();
        transaction.renew();
        Assert.equals(0, env.readerCheck());

        env.close();
        dir.close();
    }
}
