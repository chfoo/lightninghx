package lightninghx;

/**
    Modes to position or query a cursor during a `get` operation.
**/
enum CursorOperation {
    /**
        Move to the first key-data item in the database.
    **/
    First;

    /**
        DUPSORT: Move to the first data item of the current key.
    **/
    FirstDup;

    /**
        DUPSORT: Move to the given key-data pair.
    **/
    GetBoth;

    /**
        DUPSORT: Move to the given key and to the nearest data item.
    **/
    GetBothRange;

    /**
        Return the current key-data pair.
    **/
    GetCurrent;

    /**
        DUPFIXED: Return the current key and a page of the key's data items.
    **/
    GetMultiple;

    /**
        Move to the last key-data item in the database.
    **/
    Last;

    /**
        DUPSORT: Move to last data item of current key.
    **/
    LastDup;

    /**
        Move to the next data item.
    **/
    Next;

    /**
        DUPSORT: Move to the next data item of the current key.
    **/
    NextDup;

    /**
        DUPFIXED: Return the key and the next page of that key's data items.
    **/
    NextMultiple;

    /**
        Move to the next key and that key's first data item.
    **/
    NextNoDup;

    /**
        Move to the previous data item.
    **/
    Prev;

    /**
        DUPSORT: Move to the previous data item of the current key.
    **/
    PrevDup;

    /**
        Move to the previous key and that key's last data item.
    **/
    PrevNoDup;

    /**
        Move to given key-data pair.
    **/
    Set;

    /**
        Move to given key and return the key-data pair.
    **/
    SetKey;

    /**
        Move to the given key or the first key greater than the given key.
    **/
    SetRange;

    /**
        DUPFIXED: Move to the previous page and
        return the current key and a page of the key's data items.
    **/
    PrevMultiple;
}
