class Lasagna
{
    // Returns the expected cooking time in the oven, which is 40 minutes.
    public int ExpectedMinutesInOven()
    {
        return 40;
    }

    // Returns the remaining time in the oven based on the expected time.
    public int RemainingMinutesInOven(int actualMinutesInOven)
    {
        return ExpectedMinutesInOven() - actualMinutesInOven;
    }

    // Returns the preparation time based on the number of layers.
    public int PreparationTimeInMinutes(int numberOfLayers)
    {
        return numberOfLayers * 2;
    }

    // Returns the total elapsed time (preparation time + actual minutes in the oven).
    public int ElapsedTimeInMinutes(int numberOfLayers, int actualMinutesInOven)
    {
        return PreparationTimeInMinutes(numberOfLayers) + actualMinutesInOven;
    }
}
