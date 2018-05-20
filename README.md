lightninghx
===========

LightningHx is a native extern binding and wrapper library of Lightning Memory-Mapped Database (LMDB) for Haxe.

For an introduction to LMDB, please [see this document](https://github.com/LMDB/lmdb/blob/LMDB_0.9.22/libraries/liblmdb/intro.doc).

The library currently supports LMDB 0.9.22 and the CPP target. All [methods](https://github.com/LMDB/lmdb/blob/LMDB_0.9.22/libraries/liblmdb/lmdb.h), except for methods involving file descriptors and function pointers, are implemented.


Usage Notes
-----------

It is possible to segfault the program or corrupt your database if calls are done with invalid state. However by default, this library will track additional state to prevent them from happening. Safety checking can be disabled if needed.

The largest value of `Int` is 2147483647. The largest value of `Int64` that is safe across all targets is 9007199254740991. The consequence is that data items must not exceed 2147483647 bytes. If using the compile flag to use `Int` for the map size, it must not exceed 2147483647 bytes as well.

Since it is possible that the binding may have bugs across hxcpp versions, compilers, or platforms, please check and test that calls and flags are working as intended before using the binding in production.


Getting Started
---------------

Install the library using:

        haxelib install lightninghx

Alternatively, you may download it manually using git. Be sure to initialize the submodules. Then install it so that the build process knows where the sources are: `haxelib dev lightninghx [directory path name]`.


### Fruit database example

In the following example, we will be storing names of fruits to colors of fruits. First, create an environment:

```haxe
var environment = Lightning.environment();
environment.open("example_fruit_db/");
```

Then, start a transaction and get the database which we'll be using:

```haxe
var transaction = environment.beginTransaction();
var database = transaction.openDatabase();
```

Add some key-data pairs and persist the changes by committing the transaction:

```haxe
database.put(Bytes.ofString("apple"), Bytes.ofString("red"));
database.put(Bytes.ofString("banana"), Bytes.ofString("yellow"));

transaction.commit();
```

Next, we'll read some key-data pairs from the database. Start a read-only transaction and associate it with the database:

```haxe
transaction = environment.beginTransaction(EnvironmentFlags.ReadOnly);
database = database.reuse(transaction);
```

Get the color of an apple, finish the transaction, and output the result:

```haxe
var appleColor = database.get(Bytes.ofString("apple")).toString();

transaction.reset();

trace('The color of an apple is $appleColor.');
```

It should output `The color of an apple is red.`

Note that read-only transactions don't need to be closed with `commit()` or `abort()`. We still need to tell LMDB that the transaction is finished and can discard our read-only view of the database with `reset()`.

We'll start the transaction again, read another key-data pair and then finally close the transaction:

```haxe
transaction.renew();

var bananaColor = database.get(Bytes.ofString("banana")).toString();

transaction.abort();

trace('The color of a banana is $bananaColor.');
```

It should output `The color of a banana is yellow.`

Finally, close the environment. Databases usually don't need to be closed since they do not hold resources themselves.

```haxe
environment.close();
```

### Duplicate fruit database

In the previous example, we made a grievous mistake of assuming all apples are red. The following example will show how to add key-data pairs where one key has many data items.

First, open the environment:

```haxe
var environment = Lightning.environment();
environment.open("example_dup_fruit_db/");
```

Now we start a transaction and open the database with the DUPSORT option:

```haxe
var transaction = environment.beginTransaction();
var database = transaction.openDatabase(DatabaseFlags.DupSort);
```

Insert our apples and commit:

```
database.put(Bytes.ofString("apple"), Bytes.ofString("red"));
database.put(Bytes.ofString("apple"), Bytes.ofString("green"));
database.put(Bytes.ofString("apple"), Bytes.ofString("yellow"));
database.put(Bytes.ofString("banana"), Bytes.ofString("yellow"));

transaction.commit();
```

To get the key-data pairs for "apple", we'll use a cursor to retrieve our apple colors:

```haxe
transaction = environment.beginTransaction(EnvironmentFlags.ReadOnly);
database = database.reuse(transaction);

var appleColors = [];
var cursor = database.openCursor();
```

First, we position the cursor on to the "apple" key and get the first duplicate data item:

```haxe
var pair = cursor.get(CursorOperation.SetKey, Bytes.ofString("apple"));
appleColors.push(pair.data.toString());
```

We'll navigate the cursor and stop once there are no more "apple" data items:

```haxe
while (true) {
    try {
        pair = cursor.get(CursorOperation.NextDup);
    } catch (exception:NotFoundException) {
        break;
    }

    appleColors.push(pair.data.toString());
}

transaction.abort();
```

Output our result and close the environment:

```haxe
trace('The colors of an apple are ${appleColors.join(", ")}.');

environment.close();
```

It should output `The colors of an apple are green, red, yellow.`


Compiler flags
--------------

By default, `Int64` is used for the map size type. This may overflow the native `size_t` parameter. You can force this library to use `Int` by specifying the `-D int32_size` flags.


Developing
----------

Unfortunately, there is no good documentation on native externs and foreign function bindings in Haxe. If you are unfamiliar with them, see [issue in hxcpp guide](https://github.com/snowkit/hxcpp-guide/issues/1), [SQLite hxcpp bindings](https://github.com/HaxeFoundation/hxcpp/blob/master/src/hx/libs/sqlite/Sqlite.cpp), and [hxcpp native tests](https://github.com/HaxeFoundation/hxcpp/tree/master/test/native) to get started.


Running tests
-------------

To run the tests:

        haxelib install test.hxml
        haxe text.hxml
        ./out/cpp/TestAll-debug
