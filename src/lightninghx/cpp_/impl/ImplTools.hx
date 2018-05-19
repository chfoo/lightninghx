package lightninghx.cpp_.impl;

import haxe.io.Bytes;


class ImplTools {
    public static function withErrorHandler<R>(func:Void->R):R {
        try {
            return func();
        } catch (exception:Int) {
            throwError(exception);
            throw "Shouldn't reach here";
        }
    }

    public static function throwError(errorCode:Int) {
        var message = LMDB.strerror(errorCode);

        switch (errorCode) {
            case Defines.MDB_KEYEXIST:
                throw new Exception.KeyExistException(errorCode, message);
            case Defines.MDB_NOTFOUND:
                throw new Exception.NotFoundException(errorCode, message);
            default:
                throw new Exception(errorCode, message);
        }
    }

    public static function setBytes(mdbVal:LMDB.MDBValue, source:Bytes) {
        mdbVal.value.mv_size = source.length;
        mdbVal.value.mv_data = cpp.NativeArray.address(source.getData(), 0).raw;
    }

    public static function getBytes(mdbVal:LMDB.MDBValue):Bytes {
        var length = mdbVal.value.mv_size;
        var dataPointer:cpp.Pointer<cpp.Void> = cpp.Pointer.fromRaw(mdbVal.value.mv_data);
        var arrayPointer:cpp.Pointer<cpp.UInt8> = dataPointer.reinterpret();
        var bytes = Bytes.ofData(arrayPointer.toUnmanagedArray(length));

        return bytes;
    }

    public static function cursorOpToNativeEnum(cursorOp:CursorOperation):Defines.MDBCursorOp {
        switch (cursorOp) {
            case First:
                return Defines.MDBCursorOp.MDB_FIRST;
            case FirstDup:
                return Defines.MDBCursorOp.MDB_FIRST_DUP;
            case GetBoth:
                return Defines.MDBCursorOp.MDB_GET_BOTH;
            case GetBothRange:
                return Defines.MDBCursorOp.MDB_GET_BOTH_RANGE;
            case GetCurrent:
                return Defines.MDBCursorOp.MDB_GET_CURRENT;
            case GetMultiple:
                return Defines.MDBCursorOp.MDB_GET_MULTIPLE;
            case Last:
                return Defines.MDBCursorOp.MDB_LAST;
            case LastDup:
                return Defines.MDBCursorOp.MDB_LAST_DUP;
            case Next:
                return Defines.MDBCursorOp.MDB_NEXT;
            case NextDup:
                return Defines.MDBCursorOp.MDB_NEXT_DUP;
            case NextMultiple:
                return Defines.MDBCursorOp.MDB_NEXT_MULTIPLE;
            case NextNoDup:
                return Defines.MDBCursorOp.MDB_NEXT_NODUP;
            case Prev:
                return Defines.MDBCursorOp.MDB_PREV;
            case PrevDup:
                return Defines.MDBCursorOp.MDB_PREV_DUP;
            case PrevNoDup:
                return Defines.MDBCursorOp.MDB_PREV_NODUP;
            case Set:
                return Defines.MDBCursorOp.MDB_SET;
            case SetKey:
                return Defines.MDBCursorOp.MDB_SET_KEY;
            case SetRange:
                return Defines.MDBCursorOp.MDB_SET_RANGE;
            case PrevMultiple:
                return Defines.MDBCursorOp.MDB_PREV_MULTIPLE;
        }
    }
}
