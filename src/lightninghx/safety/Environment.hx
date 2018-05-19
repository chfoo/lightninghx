package lightninghx.safety;

import sys.FileSystem;

using lightninghx.safety.SafetyTools;


enum EnvironmentResourceState {
    Created;
    Opened;
    Closed;
}


class Environment implements IEnvironment {
    static var openedPaths = new Map<String,Bool>();

    #if cpp
    static var globalLock = new cpp.vm.Mutex();
    #end

    var innerEnvironment:IEnvironment;
    public var resourceState(default, null):EnvironmentResourceState = Created;
    var realPath:String;

    public function new(innerEnvironment:IEnvironment) {
        this.innerEnvironment = innerEnvironment;
    }

    static function acquireGlobalLock() {
        #if cpp
        globalLock.acquire();
        #end
    }

    static function releaseGlobalLock() {
        #if cpp
        globalLock.release();
        #end
    }

    public function open(path:String, ?flags:Flags<EnvironmentFlags>, ?unixMode:Int) {
        resourceState.requireState(Created);

        realPath = FileSystem.fullPath(path);
        registerOpenedPath(realPath);

        try {
            innerEnvironment.open(path, flags, unixMode);
        } catch (exception:Exception) {
            deregisterOpenedPath(realPath);
            throw exception;
        }

        resourceState = Opened;
    }

    static function registerOpenedPath(path:String) {
        acquireGlobalLock();

        if (openedPaths.exists(path)) {
            releaseGlobalLock();
            throw new Exception.InvalidStateException(
                'Environment already opened $path');
        }

        openedPaths.set(path, true);
        releaseGlobalLock();
    }

    static function deregisterOpenedPath(path:String) {
        var realPath = FileSystem.fullPath(path);

        acquireGlobalLock();
        openedPaths.remove(realPath);
        releaseGlobalLock();
    }

    public function copy(path:String, ?flags:Flags<CopyFlags>) {
        resourceState.requireState(Opened);
        innerEnvironment.copy(path, flags);
    }

    public function stat():Statistics {
        resourceState.requireState(Opened);
        return innerEnvironment.stat();
    }

    public function info():EnvironmentInfo {
        resourceState.requireState(Opened);
        return innerEnvironment.info();
    }

    public function sync(force:Bool = false) {
        resourceState.requireState(Opened);
        innerEnvironment.sync(force);
    }

    public function close() {
        if (resourceState == Opened) {
            innerEnvironment.close();
            deregisterOpenedPath(realPath);
        }

        resourceState = Closed;
    }

    public function setFlags(flags:Flags<EnvironmentFlags>, clear:Bool = false) {
        resourceState.disallowState(Closed);
        innerEnvironment.setFlags(flags, clear);
    }

    public function getFlags():Flags<EnvironmentFlags> {
        resourceState.disallowState(Closed);
        return innerEnvironment.getFlags();
    }

    public function getPath():String {
        resourceState.requireState(Opened);
        return innerEnvironment.getPath();
    }

    public function setMapSize(size:#if int32_size Int #else haxe.Int64 #end) {
        resourceState.disallowState(Closed);
        innerEnvironment.setMapSize(size);
    }

    public function setMaxReaders(size:Int) {
        resourceState.disallowState(Closed);
        innerEnvironment.setMaxReaders(size);
    }

    public function getMaxReaders():Int {
        resourceState.disallowState(Closed);
        return innerEnvironment.getMaxReaders();
    }

    public function setMaxDatabases(count:Int) {
        resourceState.disallowState(Closed);
        innerEnvironment.setMaxDatabases(count);
    }

    public function getMaxKeySize():Int {
        return innerEnvironment.getMaxKeySize();
    }

    public function beginTransaction(?flags:Flags<EnvironmentFlags>):ITransaction {
        resourceState.requireState(Opened);

        return new Transaction(
            this,
            innerEnvironment.beginTransaction(flags),
            flags.get(EnvironmentFlags.ReadOnly)
        );
    }

    public function readerCheck():Int {
        resourceState.disallowState(Closed);
        return innerEnvironment.readerCheck();
    }
}
