module darts;
import std.math;


int score(double x, double y)
{
    bool outside_circle(double x, double y, int radius)
    {
        return radius < (sqrt(pow(x, 2) + pow(y, 2)));
    } 
    if (outside_circle(x, y, 10))
    {
        return 0;
    }
    else if (outside_circle(x, y, 5))
    {
        return 1;
    }
    else if (outside_circle(x, y, 1))
    {
        return 5;
    }
    else
    {
        return 10;
    }
}

unittest
{
    immutable int allTestsEnabled = 1;

    // Missed target
    assert(score(-9, 9) == 0);

    static if (allTestsEnabled)
    {
        // On the outer circle
        assert(score(0, 10) == 1);

        // On the middle circle
        assert(score(-5, 0) == 5);

        // On the inner circle
        assert(score(0, -1) == 10);

        // Exactly on centre
        assert(score(0, 0) == 10);

        // Near the centre
        assert(score(-0.1, -0.1) == 10);

        // Just within the inner circle
        assert(score(0.7, 0.7) == 10);

        // Just outside the inner circle
        assert(score(0.8, -0.8) == 5);

        // Just within the middle circle
        assert(score(-3.5, 3.5) == 5);

        // Just outside the middle circle
        assert(score(-3.6, -3.6) == 1);

        // Just within the outer circle
        assert(score(-7.0, 7.0) == 1);

        // Just outside the outer circle
        assert(score(7.1, -7.1) == 0);

        // Asymmetric position between the inner and middle circles
        assert(score(0.5, -4) == 5);
    }
}
