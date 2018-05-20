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
        var envImpl:IEnvironment = null;
        #if cpp
        envImpl = lightninghx.cpp_.impl.Environment.create();
        #elseif !(dont_compile_time_error)
        #error
        #end

        if (envImpl == null) {
            throw "Not implemented for current platform";
        }

        if (safety) {
            return new lightninghx.safety.Environment(envImpl);
        } else {
            return envImpl;
        }
    }
}
