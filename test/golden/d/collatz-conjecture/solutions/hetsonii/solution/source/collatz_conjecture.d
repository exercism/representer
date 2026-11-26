module collatz_conjecture;

int steps(int a)
{
int cnt=0;

if (a<=0)
{
    throw new Exception("msg");
}
else if(a==1)
{
    return 0;
}
else
{

while(a != 1)
{
if (a % 2 == 0) {
        a = a / 2;
      } else {
        a = 3 * a + 1;
      }
cnt+=1;
}
}
return cnt;

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
