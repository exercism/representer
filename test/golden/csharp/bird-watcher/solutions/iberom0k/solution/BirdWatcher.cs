class BirdCount
{
    private int[] birdsPerDay;

    public BirdCount(int[] birdsPerDay)
    {
        this.birdsPerDay = birdsPerDay;
    }

    public static int[] LastWeek() => new int[] {0, 2, 5, 3, 7, 8, 4};

    public int Today() => birdsPerDay[birdsPerDay.Count() - 1];

    public void IncrementTodaysCount() => birdsPerDay[birdsPerDay.Count() - 1] += 1;

    public bool HasDayWithoutBirds() => birdsPerDay.Contains(0);

    public int CountForFirstDays(int numberOfDays)
    {
        int birdSum = 0;
        for (int i = 0; i < numberOfDays; i++)
        {
            birdSum += birdsPerDay[i];
        }
        return birdSum;
    }

    public int BusyDays()
    {
        int busyDays = 0;
        foreach (int birds in birdsPerDay)
        {
            if (birds >= 5) { busyDays ++; }
        }
        return busyDays;
    }
}
