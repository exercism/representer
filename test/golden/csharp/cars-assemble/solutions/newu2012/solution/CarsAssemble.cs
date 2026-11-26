using System;

static class AssemblyLine {
    public static double SuccessRate(int speed) {
        var successRatePercents = speed switch {
            0 => 0,
            >= 1 and <= 4 => 100,
            >= 5 and <= 8 => 90,
            9 => 80,
            10 => 77,
            _ => 0
        };
        var successRate = successRatePercents / 100d;

        return successRate;
    }

    public static double ProductionRatePerHour(int speed) {
        const int carsForSpeedPerHour = 221;
        var productionRatePerHour = carsForSpeedPerHour * speed * SuccessRate(speed);

        return productionRatePerHour;
    }

    public static int WorkingItemsPerMinute(int speed) {
        const int minutesInHour = 60;
        var workingItemsPerMinute = (int)ProductionRatePerHour(speed) / minutesInHour;

        return workingItemsPerMinute;
    }
}