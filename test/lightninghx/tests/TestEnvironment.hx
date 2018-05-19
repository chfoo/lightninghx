package lightninghx.tests;

import haxe.Int64;
import lightninghx.testutil.TempDir;
import sys.FileSystem;
import utest.Assert;


class TestEnvironment {
    public function new() {
    }

    public function testOpen() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);

        Assert.isTrue(FileSystem.exists(dir.dirPath + "/data.mdb"));

        env.close();
        dir.close();
    }

    public function testCopy() {
        var dir = new TempDir();
        var dir2 = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);

        env.copy(dir2.dirPath);
        env.close();

        Assert.isTrue(FileSystem.exists(dir2.dirPath + "/data.mdb"));

        dir.close();
        dir2.close();
    }

    public function testGetStats() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);

        var stats = env.stat();
        var info = env.info();

        Assert.notEquals(0, stats.pageSize);
        Assert.notEquals(0, info.mapSize);

        env.close();
        dir.close();
    }

    public function testSync() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);

        env.sync(true);
        Assert.equals(0, env.readerCheck());

        env.close();
        dir.close();
    }

    public function testFlags() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);

        env.setFlags(EnvironmentFlags.NoSync);
        var flags = env.getFlags();
        Assert.notEquals(0, flags & EnvironmentFlags.NoSync);

        env.close();
        dir.close();
    }

    public function testGetPath() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);

        Assert.equals(dir.dirPath, env.getPath());

        env.close();
        dir.close();
    }

    public function testMapSize() {
        var dir = new TempDir();
        var env = Lightning.environment();
        env.open(dir.dirPath);

        #if int32_size
        var mapSize = 2147483647;
        #else
        var mapSize = Int64.parseString("1099511627776");
        #end

        env.setMapSize(mapSize);
        var info = env.info();
        Assert.equals(mapSize, info.mapSize);
        trace(info);

        env.close();
        dir.close();
    }

    public function testMaxReaders() {
        var env = Lightning.environment();

        env.setMaxReaders(12);
        Assert.equals(12, env.getMaxReaders());

        env.close();
    }

    public function testMaxDBs() {
        var env = Lightning.environment();

        env.setMaxDatabases(10);
        Assert.equals(0, env.readerCheck());

        env.close();
    }

    public function testGetMaxKeySize() {
        var env = Lightning.environment();

        Assert.notEquals(0, env.getMaxKeySize());

        env.close();
    }
}
