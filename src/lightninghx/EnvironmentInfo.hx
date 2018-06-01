package lightninghx;

/**
    Information about the environment.

    - mapSize: Size of the data memory map.
    - lastPageNumber: ID of the last used page.
    - lastTransactionID: ID of the last committed transaction.
    - maxReaders: Maximum reader slots in the environment.
    - numReaders: Max reader slots used in the environment.
**/
typedef EnvironmentInfo = {
    mapSize:#if int32_size Int #else haxe.Int64 #end,
    lastPageNumber:#if int32_size Int #else haxe.Int64 #end,
    lastTransactionID:#if int32_size Int #else haxe.Int64 #end,
    maxReaders:Int,
    numReaders:Int
};
