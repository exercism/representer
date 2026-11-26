using System;
using System.Linq;

class BirdCount
{
    private int[] birdsPerDay;

    public BirdCount(int[] birdsPerDay)
    {
        this.birdsPerDay = birdsPerDay;
    }

    public static int[] LastWeek()
    {
        return new int[] {0, 2, 5, 3, 7, 8, 4};
    }

    public int Today()
    {
        return birdsPerDay.Last();
    }

    public void IncrementTodaysCount()
    {
        birdsPerDay = birdsPerDay.Select((x, i) => i == birdsPerDay.Count() - 1 ? x + 1 : x).ToArray();
    }

    public bool HasDayWithoutBirds()
    {
        return birdsPerDay.Any(el => el == 0);
    }

    public int CountForFirstDays(int numberOfDays)
    {
        return birdsPerDay.Select((x, i) => i  < numberOfDays ? x : 0).Sum();
    }

    public int BusyDays()
    {
        return birdsPerDay.Where(x => x >= 5).Select(x => 1).Sum();
    }
}
