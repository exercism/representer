module collatz_conjecture;

int steps(int number) {
    if (number<=0){
        throw new Exception("msg");
    }

    if(number==1){
        return 0;
    }

    int step=0;
    while (number != 1) {
      if (number % 2 == 0) {
        number = number / 2;
      } else {
        number = 3 * number + 1;
      }
      step+=1;
    }
    return step;
}

unittest
{
    import std.exception : assertThrown;

    const int allTestsEnabled = 0;

    // Zero steps for one
    assert(steps(1) == 0);

    static if (allTestsEnabled)
    {
        // Divide if even
        assert(steps(16) == 4);

        // Even and odd steps
        assert(steps(12) == 9);

        // Large number of even and odd steps
        assert(steps(1000000) == 152);

        // Zero is an error
        assertThrown(steps(0));

        // Negative value is an error
        assertThrown(steps(-15));
    }
}
