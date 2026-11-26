module eliuds_eggs;

pure int eggCount(immutable int number)
{
    int eggs;
    size_t totalBits = uint.sizeof * 8;

    for (size_t i = 0; i < totalBits; i++) {
        bool bitSet = (number & (1 << i)) != 0;
        if (bitSet)
            eggs++;
    }
    return eggs;
    
}

unittest
{
    immutable int allTestsEnabled = 0;

    // 0 eggs
    //assert(eggCount(0) == 0);
    assert(eggCount(2_000_000_000) == 14);

    static if (allTestsEnabled)
    {
        // 1 egg
        assert(eggCount(16) == 1);

        // 4 eggs
        assert(eggCount(89) == 4);

        // 13 eggs
        assert(eggCount(2_000_000_000) == 13);
    }

}
