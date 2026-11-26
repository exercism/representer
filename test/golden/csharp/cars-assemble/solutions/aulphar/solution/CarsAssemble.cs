using System;

static class AssemblyLine
{
    public static double SuccessRate(int speed)
    {
if (speed == 0)
            {
                return 0.0;
            }
            else if (speed >= 1 && speed <= 4)
            {
                return 100 / 100;
            }
            else if (speed >= 5 && speed <= 8)
            {
                return 0.9;
            }
            else if (speed == 9)
            {
                return 0.8;
            }
            else if (speed == 10)
            {
                return 0.77;
            }

           

        
        throw new NotImplementedException("Please implement the (static) AssemblyLine.SuccessRate() method");
    }
    
    public static double ProductionRatePerHour(int speed)
    {
        double rate = (speed * 221) * SuccessRate(speed);
        return rate;

        
        throw new NotImplementedException("Please implement the (static) AssemblyLine.ProductionRatePerHour() method");
    }

     public static int WorkingItemsPerMinute(int speed)
        {
            int x = Convert.ToInt32(ProductionRatePerHour(speed)) / 60;
            return x;
        throw new NotImplementedException("Please implement the (static) AssemblyLine.WorkingItemsPerMinute() method");
    }
}
