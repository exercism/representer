module darts;

/*
- If the dart lands outside the target, player earns no points (0 points).
- If the dart lands in the outer circle of the target, player earns 1 point.
- If the dart lands in the middle circle of the target, player earns 5 points.
- If the dart lands in the inner circle of the target, player earns 10 points.

The outer circle has a radius of 10 units (this is equivalent to the total radius for the entire target), the middle circle a radius of 5 units, and the inner circle a radius of 1.
Of course, they are all centered at the same point (that is, the circles are [concentric][] defined by the coordinates (0, 0).

Write a function that given a point in the target (defined by its [Cartesian coordinates][cartesian-coordinates] `x` and `y`, where `x` and `y` are [real][real-numbers]), returns the correct amount earned by a dart landing at that point.


*/

struct CircleScore
{
    real radiusSq;
    int score;
    this(real radius, int score)
    {
        this.score = score;
        this.radiusSq = radius * radius;
    }

    bool isHit(real posSq)
    {
        return posSq <= radiusSq;
    }
}

// The circles, from inner to outer.
CircleScore[] concentric = [
    CircleScore(1, 10),
    CircleScore(5, 5),
    CircleScore(10, 1)
];

int score(real x, real y)
{
    auto hitSq = (x * x + y * y);

    foreach (cc; concentric)
    {
        if (cc.isHit(hitSq))
        {
            return cc.score;
        }
    }
    return 0;
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
