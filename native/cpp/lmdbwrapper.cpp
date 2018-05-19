#include "lmdbwrapper.h"

#pragma GCC diagnostic push
#pragma GCC diagnostic error "-Wall"
#pragma GCC diagnostic error "-Wextra"

namespace lmdbwrapper {
    void throw_if_error(int error_code) {
        if (error_code != 0) {
            hx::Throw(error_code);
        }
    }

    String version() {
        return String(mdb_version(NULL, NULL, NULL));
    }

    String strerror(int err) {
        return String(mdb_strerror(err));
    }

    Environment env_create() {
        MDB_env *env;
        throw_if_error(mdb_env_create(&env));

        return Environment(env);
    }

    void env_open(Environment env, String path, unsigned int flags, mdb_mode_t mode) {
        throw_if_error(mdb_env_open(env.ptr, path.c_str(), flags, mode));
    }

    void env_copy(Environment env, String path) {
        throw_if_error(mdb_env_copy(env.ptr, path.c_str()));
    }

    void env_copy2(Environment env, String path, unsigned int flags) {
        throw_if_error(mdb_env_copy2(env.ptr, path.c_str(), flags));
    }

    Stat env_stat(Environment env) {
        MDB_stat * stat = new MDB_stat();
        int result = mdb_env_stat(env.ptr, stat);

        if (result != 0) {
            delete stat;
        }

        throw_if_error(result);

        return Stat(stat);
    }

    EnvInfo env_info(Environment env) {
        MDB_envinfo * info = new MDB_envinfo();
        int result = mdb_env_info(env.ptr, info);

        if (result != 0) {
            delete info;
        }

        throw_if_error(result);

        return EnvInfo(info);
    }

    void env_sync(Environment env, int force) {
        throw_if_error(mdb_env_sync(env.ptr, force));
    }

    void env_close(Environment env) {
        mdb_env_close(env.ptr);
    }

    void env_set_flags(Environment env, unsigned int flags, int onoff) {
        throw_if_error(mdb_env_set_flags(env.ptr, flags, onoff));
    }

    unsigned int env_get_flags(Environment env) {
        unsigned int flags;
        throw_if_error(mdb_env_get_flags(env.ptr, &flags));

        return flags;
    }

    String env_get_path(Environment env) {
        const char * path;
        throw_if_error(mdb_env_get_path(env.ptr, &path));

        return String(path);
    }

    void env_set_mapsize(Environment env, ::cpp::Int64 size) {
        throw_if_error(mdb_env_set_mapsize(env.ptr, size));
    }

    void env_set_maxreaders(Environment env, unsigned int readers) {
        throw_if_error(mdb_env_set_maxreaders(env.ptr, readers));
    }

    unsigned int env_get_maxreaders(Environment env) {
        unsigned int readers;
        throw_if_error(mdb_env_get_maxreaders(env.ptr, &readers));

        return readers;
    }

    void env_set_maxdbs(Environment env, MDB_dbi dbs) {
        throw_if_error(mdb_env_set_maxdbs(env.ptr, dbs));
    }

    int env_get_maxkeysize(Environment env) {
        return mdb_env_get_maxkeysize(env.ptr);
    }

    Transaction txn_begin(Environment env, Transaction parent, unsigned int flags) {
        MDB_txn * txn;
        throw_if_error(mdb_txn_begin(env.ptr, parent, flags, &txn));

        return Transaction(txn);
    }

    Environment txn_env(Transaction txn) {
        return Environment(mdb_txn_env(txn.ptr));
    }

    int txn_id(Transaction txn) {
        return mdb_txn_id(txn.ptr);
    }

    void txn_commit(Transaction txn) {
        throw_if_error(mdb_txn_commit(txn.ptr));
    }

    void txn_abort(Transaction txn) {
        mdb_txn_abort(txn.ptr);
    }

    void txn_reset(Transaction txn) {
        mdb_txn_reset(txn.ptr);
    }

    void txn_renew(Transaction txn) {
        throw_if_error(mdb_txn_renew(txn.ptr));
    }

    Database dbi_open(Transaction txn, String name, unsigned int flags) {
        MDB_dbi dbi;
        throw_if_error(mdb_dbi_open(txn.ptr, name.c_str(), flags, &dbi));

        return dbi;
    }

    Stat stat(Transaction txn, Database dbi) {
        MDB_stat * stat = new MDB_stat();
        int result = mdb_stat(txn.ptr, dbi, stat);

        if (result != 0) {
            delete stat;
        }

        throw_if_error(result);

        return Stat(stat);
    }

    unsigned int dbi_flags(Transaction txn, Database dbi) {
        unsigned int flags;

        throw_if_error(mdb_dbi_flags(txn.ptr, dbi, &flags));

        return flags;
    }

    void dbi_close(Environment env, Database dbi) {
        mdb_dbi_close(env.ptr, dbi);
    }

    void drop(Transaction txn, Database dbi, int del) {
        throw_if_error(mdb_drop(txn.ptr, dbi, del));
    }

    MDBValue get(Transaction txn, Database dbi, MDBValue key) {
        MDB_val * data = new MDB_val();
        throw_if_error(mdb_get(txn.ptr, dbi, key.ptr, data));

        return MDBValue(data);
    }

    void put(Transaction txn, Database dbi, MDBValue key, MDBValue data, unsigned int flags) {
        throw_if_error(mdb_put(txn.ptr, dbi, key.ptr, data.ptr, flags));
    }

    void del(Transaction txn, Database dbi, MDBValue key, MDBValue data) {
        throw_if_error(mdb_del(txn.ptr, dbi, key.ptr, data.ptr));
    }

    Cursor cursor_open(Transaction txn, Database dbi) {
        MDB_cursor * cursor;
        throw_if_error(mdb_cursor_open(txn.ptr, dbi, &cursor));
        return Cursor(cursor);
    }

    void cursor_close(Cursor cursor) {
        mdb_cursor_close(cursor.ptr);
    }

    void cursor_renew(Transaction txn, Cursor cursor) {
        throw_if_error(mdb_cursor_renew(txn.ptr, cursor.ptr));
    }

    Transaction cursor_txn(Cursor cursor) {
        return Transaction(mdb_cursor_txn(cursor.ptr));
    }

    Database cursor_dbi(Cursor cursor) {
        return mdb_cursor_dbi(cursor.ptr);
    }

    void cursor_get(Cursor cursor, MDBValue key, MDBValue data, MDB_cursor_op op) {
        throw_if_error(mdb_cursor_get(cursor.ptr, key.ptr, data.ptr, op));
    }

    void cursor_put(Cursor cursor, MDBValue key, MDBValue data, unsigned int flags) {
        throw_if_error(mdb_cursor_put(cursor.ptr, key.ptr, data.ptr, flags));
    }

    void cursor_del(Cursor cursor, unsigned int flags) {
        throw_if_error(mdb_cursor_del(cursor.ptr, flags));
    }

    int cursor_count(Cursor cursor) {
        size_t count;

        throw_if_error(mdb_cursor_count(cursor.ptr, &count));

        return count;
    }

    int cmp(Transaction txn, Database dbi, MDBValue a, MDBValue b) {
        return mdb_cmp(txn.ptr, dbi, a.ptr, b.ptr);
    }

    int dcmp(Transaction txn, Database dbi, MDBValue a, MDBValue b) {
        return mdb_dcmp(txn.ptr, dbi, a.ptr, b.ptr);
    }

    int reader_check(Environment env) {
        int dead;

        throw_if_error(mdb_reader_check(env.ptr, &dead));

        return dead;
    }

    MDBValue new_mdbvalue() {
        MDB_val * val = new MDB_val();
        return MDBValue(val);
    }
}

#pragma GCC diagnostic pop
