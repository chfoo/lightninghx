package lightninghx;


/**
    Native extern binding and wrapper library of LMDB.

    Library's entry point for users.
**/
class Lightning {
    /**
        Return a new environment.
    **/
    public static function environment():IEnvironment {
        #if cpp
        return lightninghx.cpp_.impl.Environment.create();
        #else
        #error "Not supported on this target";
        #end
    }
}
