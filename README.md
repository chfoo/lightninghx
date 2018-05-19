lightninghx
===========

LightningHx is a native extern binding and wrapper library of Lightning Memory-Mapped Database (LMDB) for Haxe.

The library currently supports LMDB 0.9.22 and the CPP target. All methods, except for methods involving file descriptors and function pointers, are implemented.

Note: It is possible to segfault the program or corrupt your database if calls are done with invalid state. For an introduction to LMDB, please [see this document](https://github.com/LMDB/lmdb/blob/LMDB_0.9.22/libraries/liblmdb/lmdb.h). Since it is possible that the binding may have bugs across hxcpp versions, compilers, or platforms, please check and test that calls and flags are working as intended before using the binding in production.


Getting Started
---------------

TODO


Developing
----------

Unfortunately, there is no good documentation on native externs and foreign function bindings in Haxe. If you are unfamiliar with them, see [issue in hxcpp guide](https://github.com/snowkit/hxcpp-guide/issues/1), [SQLite hxcpp bindings](https://github.com/HaxeFoundation/hxcpp/blob/master/src/hx/libs/sqlite/Sqlite.cpp), and [hxcpp native tests](https://github.com/HaxeFoundation/hxcpp/tree/master/test/native) to get started.


Running tests
-------------

To run the tests:

        haxelib install hxcpp
        haxelib install test.hxml
        haxe text.hxml
