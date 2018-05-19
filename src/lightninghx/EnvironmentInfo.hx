package lightninghx;

/**
    Information about the environment.

    * mapSize: Size of the data memory map.
    * lastPageNumber: ID of the last used page.
    * lastTransactionID: ID of the last committed transaction.
    * maxReaders: Maximum reader slots in the environment.
    * numReaders: Max reader slots used in the environment.
**/
typedef EnvironmentInfo = {
    mapSize:Int,
    lastPageNumber:Int,
    lastTransactionID:Int,
    maxReaders:Int,
    numReaders:Int
};
