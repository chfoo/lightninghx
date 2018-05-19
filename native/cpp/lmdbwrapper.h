#pragma once

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <lmdb.h>

namespace lmdbwrapper {
    typedef cpp::Pointer<MDB_env> Environment;
    typedef cpp::Pointer<MDB_txn> Transaction;
    typedef unsigned int Database;
    typedef cpp::Pointer<MDB_cursor> Cursor;
    typedef cpp::Pointer<MDB_val> MDBValue;
    typedef cpp::Pointer<MDB_stat> Stat;
    typedef cpp::Pointer<MDB_envinfo> EnvInfo;

    static void throw_if_error(int error_code);

    extern String version();
    extern String strerror(int err);
    extern Environment env_create();
    extern void env_open(Environment env, String path, unsigned int flags, mdb_mode_t mode);
    extern void env_copy(Environment env, String path);
    extern void env_copy2(Environment env, String path, unsigned int flags);
    extern Stat env_stat(Environment env);
    extern EnvInfo env_info(Environment env);
    extern void env_sync(Environment env, int force);
    extern void env_close(Environment env);
    extern void env_set_flags(Environment env, unsigned int flags, int onoff);
    extern unsigned int env_get_flags(Environment env);
    extern String env_get_path(Environment env);
    extern void env_set_mapsize(Environment env, ::cpp::Int64 size);
    extern void env_set_maxreaders(Environment env, unsigned int readers);
    extern unsigned int env_get_maxreaders(Environment env);
    extern void env_set_maxdbs(Environment env, MDB_dbi dbs);
    extern int env_get_maxkeysize(Environment env);
    extern Transaction txn_begin(Environment env, Transaction parent, unsigned int flags);
    extern Environment txn_env(Transaction txn);
    extern int txn_id(Transaction txn);
    extern void txn_commit(Transaction txn);
    extern void txn_abort(Transaction txn);
    extern void txn_reset(Transaction txn);
    extern void txn_renew(Transaction txn);
    extern Database dbi_open(Transaction txn, String name, unsigned int flags);
    extern Stat stat(Transaction txn, Database dbi);
    extern unsigned int dbi_flags(Transaction txn, Database dbi);
    extern void dbi_close(Environment env, Database dbi);
    extern void drop(Transaction txn, Database dbi, int del);
    extern MDBValue get(Transaction txn, Database dbi, MDBValue key);
    extern void put(Transaction txn, Database dbi, MDBValue key, MDBValue data, unsigned int flags);
    extern void del(Transaction txn, Database dbi, MDBValue key, MDBValue data);
    extern Cursor cursor_open(Transaction txn, Database dbi);
    extern void cursor_close(Cursor cursor);
    extern void cursor_renew(Transaction txn, Cursor cursor);
    extern Transaction cursor_txn(Cursor cursor);
    extern Database cursor_dbi(Cursor cursor);
    extern void cursor_get(Cursor cursor, MDBValue key, MDBValue data, MDB_cursor_op op);
    extern void cursor_put(Cursor cursor, MDBValue key, MDBValue data, unsigned int flags);
    extern void cursor_del(Cursor cursor, unsigned int flags);
    extern int cursor_count(Cursor cursor);
    extern int cmp(Transaction txn, Database dbi, MDBValue a, MDBValue b);
    extern int dcmp(Transaction txn, Database dbi, MDBValue a, MDBValue b);
    extern int reader_check(Environment env);

    extern MDBValue new_mdbvalue();
}
