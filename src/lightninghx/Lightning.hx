package lightninghx;


/**
    Native extern binding and wrapper library of LMDB.

    Library's entry point for users.
**/
class Lightning {
    /**
        Return a new environment.
    **/
    public static function environment(safety:Bool = true):Environment {
        var envImpl:Environment = null;
        #if cpp
        envImpl = lightninghx.cpp_.impl.CPPEnvironment.create();
        #elseif !(dont_compile_time_error)
        #error
        #end

        if (envImpl == null) {
            throw "Not implemented for current platform";
        }

        if (safety) {
            return new lightninghx.safety.SafetyEnvironment(envImpl);
        } else {
            return envImpl;
        }
    }
}
