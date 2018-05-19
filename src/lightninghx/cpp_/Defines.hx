package lightninghx.cpp_;


@:enum
extern abstract Defines(Int) to Int {
    @:native("MDB_VERSION_MAJOR") var MDB_VERSION_MAJOR:Int;
    @:native("MDB_VERSION_MINOR") var MDB_VERSION_MINOR:Int;
    @:native("MDB_VERSION_PATCH")  var MDB_VERSION_PATCH:Int;
    @:native("MDB_VERINT") var MDB_VERINT:Int;
    @:native("MDB_VERSION_FULL") var MDB_VERSION_FULL:Int;

    @:native("MDB_FIXEDMAP") var MDB_FIXEDMAP:Int;
    @:native("MDB_NOSUBDIR") var MDB_NOSUBDIR:Int;
    @:native("MDB_NOSYNC") var MDB_NOSYNC:Int;
    @:native("MDB_RDONLY") var MDB_RDONLY:Int;
    @:native("MDB_NOMETASYNC") var MDB_NOMETASYNC:Int;
    @:native("MDB_WRITEMAP") var MDB_WRITEMAP:Int;
    @:native("MDB_MAPASYNC") var MDB_MAPASYNC:Int;
    @:native("MDB_NOTLS") var MDB_NOTLS:Int;
    @:native("MDB_NOLOCK") var MDB_NOLOCK:Int;
    @:native("MDB_NORDAHEAD") var MDB_NORDAHEAD:Int;
    @:native("MDB_NOMEMINIT") var MDB_NOMEMINIT:Int;

    @:native("MDB_REVERSEKEY") var MDB_REVERSEKEY:Int;
    @:native("MDB_DUPSORT") var MDB_DUPSORT:Int;
    @:native("MDB_INTEGERKEY") var MDB_INTEGERKEY:Int;
    @:native("MDB_DUPFIXED") var MDB_DUPFIXED:Int;
    @:native("MDB_INTEGERDUP") var MDB_INTEGERDUP:Int;
    @:native("MDB_REVERSEDUP") var MDB_REVERSEDUP:Int;
    @:native("MDB_CREATE") var MDB_CREATE:Int;

    @:native("MDB_NOOVERWRITE") var MDB_NOOVERWRITE:Int;
    @:native("MDB_NODUPDATA") var MDB_NODUPDATA:Int;
    @:native("MDB_CURRENT") var MDB_CURRENT:Int;
    @:native("MDB_RESERVE") var MDB_RESERVE:Int;
    @:native("MDB_APPEND") var MDB_APPEND:Int;
    @:native("MDB_APPENDDUP") var MDB_APPENDDUP:Int;
    @:native("MDB_MULTIPLE") var MDB_MULTIPLE:Int;

    @:native("MDB_CP_COMPACT") var MDB_CP_COMPACT:Int;

    @:native("MDB_SUCCESS") var MDB_SUCCESS:Int;
    @:native("MDB_KEYEXIST") var MDB_KEYEXIST:Int;
    @:native("MDB_NOTFOUND") var MDB_NOTFOUND:Int;
    @:native("MDB_PAGE_NOTFOUND") var MDB_PAGE_NOTFOUND:Int;
    @:native("MDB_CORRUPTED") var MDB_CORRUPTED:Int;
    @:native("MDB_PANIC") var MDB_PANIC:Int;
    @:native("MDB_VERSION_MISMATCH") var MDB_VERSION_MISMATCH:Int;
    @:native("MDB_INVALID") var MDB_INVALID:Int;
    @:native("MDB_MAP_FULL") var MDB_MAP_FULL:Int;
    @:native("MDB_DBS_FULL") var MDB_DBS_FULL:Int;
    @:native("MDB_READERS_FULL") var MDB_READERS_FULL:Int;
    @:native("MDB_TLS_FULL") var MDB_TLS_FULL:Int;
    @:native("MDB_TXN_FULL") var MDB_TXN_FULL:Int;
    @:native("MDB_CURSOR_FULL") var MDB_CURSOR_FULL:Int;
    @:native("MDB_PAGE_FULL") var MDB_PAGE_FULL:Int;
    @:native("MDB_MAP_RESIZED") var MDB_MAP_RESIZED:Int;
    @:native("MDB_INCOMPATIBLE") var MDB_INCOMPATIBLE:Int;
    @:native("MDB_BAD_RSLOT") var MDB_BAD_RSLOT:Int;
    @:native("MDB_BAD_TXN") var MDB_BAD_TXN:Int;
    @:native("MDB_BAD_VALSIZE") var MDB_BAD_VALSIZE:Int;
    @:native("MDB_BAD_DBI") var MDB_BAD_DBI:Int;
    @:native("MDB_LAST_ERRCODE") var MDB_LAST_ERRCODE:Int;
}


@:native("::::cpp::Struct< ::MDB_cursor_op, ::cpp::EnumHandler>")
extern class MDBCursorOpImpl {
}


@:enum
extern abstract MDBCursorOp(MDBCursorOpImpl) {
    @:native("MDB_FIRST") var MDB_FIRST;
    @:native("MDB_FIRST_DUP") var MDB_FIRST_DUP;
    @:native("MDB_GET_BOTH") var MDB_GET_BOTH;
    @:native("MDB_GET_BOTH_RANGE") var MDB_GET_BOTH_RANGE;
    @:native("MDB_GET_CURRENT") var MDB_GET_CURRENT;
    @:native("MDB_GET_MULTIPLE") var MDB_GET_MULTIPLE;
    @:native("MDB_LAST") var MDB_LAST;
    @:native("MDB_LAST_DUP") var MDB_LAST_DUP;
    @:native("MDB_NEXT") var MDB_NEXT;
    @:native("MDB_NEXT_DUP") var MDB_NEXT_DUP;
    @:native("MDB_NEXT_MULTIPLE") var MDB_NEXT_MULTIPLE;
    @:native("MDB_NEXT_NODUP") var MDB_NEXT_NODUP;
    @:native("MDB_PREV") var MDB_PREV;
    @:native("MDB_PREV_DUP") var MDB_PREV_DUP;
    @:native("MDB_PREV_NODUP") var MDB_PREV_NODUP;
    @:native("MDB_SET") var MDB_SET;
    @:native("MDB_SET_KEY") var MDB_SET_KEY;
    @:native("MDB_SET_RANGE") var MDB_SET_RANGE;
    @:native("MDB_PREV_MULTIPLE") var MDB_PREV_MULTIPLE;
}
