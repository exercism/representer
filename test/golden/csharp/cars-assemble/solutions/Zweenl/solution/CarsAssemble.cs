using System;

static class AssemblyLine
{
    public static double SuccessRate(int speed)
    {
        if (speed == 0) {
            return 0;
        }

        if (speed < 5) {
            return 1;
        }

        if (speed < 9) {
            return 0.9;
        }

        if (speed == 9) {
            return 0.8;
        }
        
        if (speed == 10) {
            return 0.77;
        }
    
        return 0;
    }
    
    public static double ProductionRatePerHour(int speed)
    {
        var totalProduction = speed * 221;
        var successRate = SuccessRate(speed);
        return totalProduction * successRate;
    }

    public static int WorkingItemsPerMinute(int speed)
    {
        var successPerHour = ProductionRatePerHour(speed);
        return (int)(successPerHour / 60);
    }
}
