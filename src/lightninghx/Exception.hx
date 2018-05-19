package lightninghx;

/**
    General LMDB error.
**/
class Exception {
    /**
        Numerical error code.
    **/
    public var code(default, null):Int;

    /**
        Human readable error message.
    **/
    public var message(default, null):String;

    public function new(code:Int, message:String) {
        this.code = code;
        this.message = message;
    }

    public function toString() {
        var name = Type.getClassName(Type.getClass(this));
        return '[$name: $code: $message]';
    }
}

/**
    A key or key-data pair already exists in the database.
**/
class KeyExistException extends Exception {
}


/**
    A key or key-data pair does not exist in the database.
**/
class NotFoundException extends Exception {
}


/**
    Method called on instance with invalid state.

    This exception will be thrown for instances that help avoid
    segmentation faults or other programming errors.
**/
class InvalidStateException extends Exception {
    public function new(message:String) {
        super(-1, message);
    }
}
