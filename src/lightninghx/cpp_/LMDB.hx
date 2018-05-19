package lightninghx.cpp_;


@:structAccess @:include("lmdb.h")
@:native("MDB_env") extern class MDB_env {
}


@:structAccess @:include("lmdb.h")
@:native("MDB_txn") extern class MDB_txn {
}


@:structAccess @:include("lmdb.h")
@:native("MDB_cursor") extern class MDB_cursor {
}


@:structAccess @:include("lmdb.h")
@:native("MDB_val") extern class MDB_val {
    var mv_size:Int;
    var mv_data:Dynamic;
}


@:structAccess @:include("lmdb.h")
@:native("MDB_stat") extern class MDB_stat {
    var ms_psize:Int;
    var ms_depth:Int;
    var ms_branch_pages:Int;
	var ms_leaf_pages:Int;
	var ms_overflow_pages:Int;
	var ms_entries:Int;
}


@:structAccess @:include("lmdb.h")
@:native("MDB_envinfo") extern class MDB_envinfo {
    var me_mapaddr:Dynamic;
	var me_mapsize:Int;
	var me_last_pgno:Int;
	var me_last_txnid:Int;
	var me_maxreaders:Int;
	var me_numreaders:Int;
}


typedef Environment = cpp.Pointer<MDB_env>;
typedef Transaction = cpp.Pointer<MDB_txn>;
typedef Database = Int;
typedef Cursor = cpp.Pointer<MDB_cursor>;
typedef MDBValue = cpp.Pointer<MDB_val>;
typedef Stat = cpp.Pointer<MDB_stat>;
typedef EnvInfo = cpp.Pointer<MDB_envinfo>;


@:keep
@:include("lmdbwrapper.h")
@:buildXml("<include name='${this_dir}/../../native/cpp/build.xml'/>")
// this_dir is "out/cpp/"
extern class LMDB {
    @:native("lmdbwrapper::version")
    static function version(error:Int):String;

    @:native("lmdbwrapper::strerror")
    static function strerror(error:Int):String;

    @:native("lmdbwrapper::env_create")
    static function envCreate():Environment;

    @:native("lmdbwrapper::env_open")
    static function envOpen(env:Environment, path:String, flags:Int, mode:Int):Void;

    @:native("lmdbwrapper::env_copy")
    static function envCopy(env:Environment, path:String):Void;

    @:native("lmdbwrapper::env_copy2")
    static function envCopy2(env:Environment, path:String, flags:Int):Void;

    @:native("lmdbwrapper::env_stat")
    static function envStat(env:Environment):Stat;

    @:native("lmdbwrapper::env_info")
    static function envInfo(env:Environment):EnvInfo;

    @:native("lmdbwrapper::env_sync")
    static function envSync(env:Environment, force:Int):Void;

    @:native("lmdbwrapper::env_close")
    static function envClose(env:Environment):Void;

    @:native("lmdbwrapper::env_set_flags")
    static function envSetFlags(env:Environment, flags:Int, onoff:Int):Void;

    @:native("lmdbwrapper::env_get_flags")
    static function envGetFlags(env:Environment):Int;

    @:native("lmdbwrapper::env_get_path")
    static function envGetPath(env:Environment):String;

    @:native("lmdbwrapper::env_set_mapsize")
    static function envSetMapSize(env:Environment, size:#if x32 Int #else haxe.Int64 #end):Void;

    @:native("lmdbwrapper::env_set_maxreaders")
    static function envSetMaxReaders(env:Environment, readers:Int):Void;

    @:native("lmdbwrapper::env_get_maxreaders")
    static function envGetMaxReaders(env:Environment):Int;

    @:native("lmdbwrapper::env_set_maxdbs")
    static function envSetMaxDBs(env:Environment, dbs:Int):Void;

    @:native("lmdbwrapper::env_get_maxkeysize")
    static function envGetMaxKeySize(env:Environment):Int;

    @:native("lmdbwrapper::txn_begin")
    static function txnBegin(env:Environment, parent:Transaction, flags:Int):Transaction;

    @:native("lmdbwrapper::txn_env")
    static function txnEnv(txn:Transaction):Environment;

    @:native("lmdbwrapper::txn_id")
    static function txnId(txn:Transaction):Int;

    @:native("lmdbwrapper::txn_commit")
    static function txnCommit(txn:Transaction):Void;

    @:native("lmdbwrapper::txn_abort")
    static function txnAbort(txn:Transaction):Void;

    @:native("lmdbwrapper::txn_reset")
    static function txnReset(txn:Transaction):Void;

    @:native("lmdbwrapper::txn_renew")
    static function txnRenew(txn:Transaction):Void;

    @:native("lmdbwrapper::dbi_open")
    static function dbiOpen(txn:Transaction, name:String, flags:Int):Database;

    @:native("lmdbwrapper::stat")
    static function stat(txn:Transaction, dbi:Database):Stat;

    @:native("lmdbwrapper::dbi_flags")
    static function dbiFlags(txn:Transaction, dbi:Database):Int;

    @:native("lmdbwrapper::dbi_close")
    static function dbiClose(env:Environment, dbi:Database):Void;

    @:native("lmdbwrapper::drop")
    static function drop(txn:Transaction, dbi:Database, del:Int):Void;

    @:native("lmdbwrapper::get")
    static function get(txn:Transaction, dbi:Database, key:MDBValue):MDBValue;

    @:native("lmdbwrapper::put")
    static function put(txn:Transaction, dbi:Database, key:MDBValue, data:MDBValue, flags:Int):Void;

    @:native("lmdbwrapper::del")
    static function del(txn:Transaction, dbi:Database, key:MDBValue, data:MDBValue):Void;

    @:native("lmdbwrapper::cursor_open")
    static function cursorOpen(txn:Transaction, dbi:Database):Cursor;

    @:native("lmdbwrapper::cursor_close")
    static function cursorClose(cursor:Cursor):Void;

    @:native("lmdbwrapper::cursor_renew")
    static function cursorRenew(txn:Transaction, cursor:Cursor):Void;

    @:native("lmdbwrapper::cursor_txn")
    static function cursorTxn(cursor:Cursor):Transaction;

    @:native("lmdbwrapper::cursor_dbi")
    static function cursorDbi(cursor:Cursor):Database;

    @:native("lmdbwrapper::cursor_get")
    static function cursorGet(cursor:Cursor, key:MDBValue, data:MDBValue, cursorOp:Any):Void;

    @:native("lmdbwrapper::cursor_put")
    static function cursorPut(cursor:Cursor, key:MDBValue, value:MDBValue, flags:Int):MDBValue;

    @:native("lmdbwrapper::cursor_del")
    static function cursorDel(cursor:Cursor, flags:Int):Void;

    @:native("lmdbwrapper::cursor_count")
    static function cursorCount(cursor:Cursor):Int;

    @:native("lmdbwrapper::cmp")
    static function cmp(txn:Transaction, dbi:Database, a:MDBValue, b:MDBValue):Int;

    @:native("lmdbwrapper::dcmp")
    static function dcmp(txn:Transaction, dbi:Database, a:MDBValue, b:MDBValue):Int;

    @:native("lmdbwrapper::reader_check")
    static function readerCheck(env:Environment):Int;

    @:native("lmdbwrapper::new_mdbvalue")
    static function newMDBValue():MDBValue;
}
