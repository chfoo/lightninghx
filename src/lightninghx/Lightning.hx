package lightninghx;


/**
    Native extern binding and wrapper library of LMDB.

    Library's entry point for users.
**/
class Lightning {
    /**
        Return a new environment.
    **/
    public static function environment(safety:Bool = true):IEnvironment {
        var envImpl;
        #if cpp
        envImpl = lightninghx.cpp_.impl.Environment.create();
        #else
        #error "Not supported on this target";
        #end

        if (safety) {
            return new lightninghx.safety.Environment(envImpl);
        } else {
            return envImpl;
        }
    }
}
