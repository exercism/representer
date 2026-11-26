using System;
using System.Linq;

class BirdCount {
    private int[] birdsPerDay;

    public BirdCount(int[] birdsPerDay) {
        this.birdsPerDay = birdsPerDay;
    }

    public static int[] LastWeek() {
        int[] lastWeekBirds = { 0, 2, 5, 3, 7, 8, 4 };

        return lastWeekBirds;
    }

    public int Today() {
        var todayBirds = birdsPerDay.Last();

        return todayBirds;
    }

    public void IncrementTodaysCount() {
        birdsPerDay[^1]++;
    }

    public bool HasDayWithoutBirds() {
        var hasDayWithoutBirds = birdsPerDay.Contains(0);

        return hasDayWithoutBirds;
    }

    public int CountForFirstDays(int numberOfDays) {
        var countForFirstNumberOfDays = 0;
        for (var day = 0; day < numberOfDays; day++) {
            countForFirstNumberOfDays += birdsPerDay[day];
        }
        
        return countForFirstNumberOfDays;
    }

    public int BusyDays() {
        var busyDays = birdsPerDay.Count(birds => birds >= 5);

        return busyDays;
    }
}