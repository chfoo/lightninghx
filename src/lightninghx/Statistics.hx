package lightninghx;


/**
    Statistics for a database.

    - pageSize: Size of a database page.
    - depth: Depth of b-tree.
    - branchPages: Number of (internal) non-leaf pages.
    - leafPages: Number of leaf pages.
    - overflowPages: Number of overflow pages.
    - entires: Number of data items.
**/
typedef Statistics = {
    pageSize:Int,
    depth:Int,
    branchPages:Int,
    leafPages:Int,
    overflowPages:Int,
    entries:Int
};
