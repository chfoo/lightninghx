package lightninghx;


/**
    Bitwise flag collection
**/
abstract Flags<T:Int>(Int) to Int {
    inline public function new() {
        this = 0;
    }

    /**
        Set flags to given integer.
    **/
    inline function setInt(flags:Int) {
        this = flags;
    }

    /**
        Create new Flags from given integer.
    **/
    @:from
    inline public static function fromInt<T:Int>(flags:Int):Flags<T> {
        var obj = new Flags<T>();
        obj.setInt(flags);
        return obj;
    }

    /**
        Get whether a bit is set.
    **/
    inline public function get(flag:T):Bool {
        return this & flag != 0;
    }

    /**
        Set a bit.
    **/
    inline public function set(flag:T, value:Bool = true) {
        if (value) {
            this |= flag;
        } else {
            this &= ~flag;
        }
    }

    /**
        Unset a bit.
    **/
    inline public function clear(flag) {
        set(flag, false);
    }

    @:op(A | B)
    inline public function add(rhs:T):Flags<T> {
        return Flags.fromInt(this | rhs);
    }
}
