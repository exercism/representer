using System;

static class AssemblyLine
{
    public static double SuccessRate(int speed)
    {
        double successRate = 0;
        if(speed == 0) {
            return successRate = 0;
        } else if(speed == 1 || speed == 2 || speed == 3 || speed == 4) {
            return successRate = 1;
        } else if(speed == 5 || speed == 6 || speed == 7 || speed == 8) {
            return successRate = .9;
        } else if (speed == 9) {
            return successRate = .8;
        } else {
            return successRate = .77;
        }
        
    }
    
    public static double ProductionRatePerHour(int speed)
    {
        int prodSpeed = 221;
        int productionAmountPerSpeed = prodSpeed * speed;
        double successRate = 0;
        if(speed == 0) {
            successRate = 0;
            return 0;
        } else if(speed == 1 || speed == 2 || speed == 3 || speed == 4) {
            successRate = 1;
            return productionAmountPerSpeed * successRate;
        } else if(speed == 5 || speed == 6 || speed == 7 || speed == 8) {
            successRate = .9;
            return productionAmountPerSpeed * successRate;
        } else if (speed == 9) {
            successRate = .8;
            return productionAmountPerSpeed * successRate;
        } else {
            successRate = .77;
            return productionAmountPerSpeed * successRate;
        }
           
    }

     public static int WorkingItemsPerMinute(int speed)
    {
         float productionAmountPerSecond = 221 / 60f; 
         double successRate = 0;
         if(speed == 0) {
             return 0;
         } else if(speed == 1 || speed == 2 || speed == 3 || speed == 4) {
             successRate = 1;
             double result = (productionAmountPerSecond * speed) * successRate;
             int answer = (int)result; 
             return answer; 
         } else if (speed == 5 || speed == 6 || speed == 7 || speed == 8) {
             successRate = .9;
             double result = (productionAmountPerSecond * speed) * successRate;
             int answer = (int)result; 
             return answer;
         } else if (speed == 9) {
             successRate = .8;
             double result = (productionAmountPerSecond * speed) * successRate;
             int answer = (int)result; 
             return answer;
         } else {
             successRate = .77;
             double result = (productionAmountPerSecond * speed) * successRate;
             int answer = (int)result; 
             return answer;
         }
         
    }
}
