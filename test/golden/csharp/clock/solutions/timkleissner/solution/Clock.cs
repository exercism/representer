using System;

public class Clock
{
    private int hours;
    private int minutes;
    private readonly string outputFormat = "{0:00}";
    
    public Clock(int hours, int minutes)
    {
        if(minutes >= 60 || minutes <= 60){
            hours += minutes / 60;
            minutes = minutes % 60;
        }
        if(minutes < 0){
            minutes = 60 + minutes;
            hours -= 1;
        }
            
        if(hours >= 24 || hours <= -24)
            hours = hours % 24;
        if(hours < 0)
            hours = 24 + hours;
    
        this.hours = hours;
        this.minutes = minutes;
    }

    public Clock Add(int minutesToAdd) => new Clock(this.hours, this.minutes + minutesToAdd);
    public Clock Subtract(int minutesToSubtract) => new Clock(this.hours, this.minutes - minutesToSubtract);
    
    public override string ToString() =>
        $"{string.Format(outputFormat, hours)}:{string.Format(outputFormat, minutes)}";
    
    public override bool Equals(object checkClock){
        Clock otherClock = (Clock) checkClock;
        if((this.hours == otherClock.hours) && (this.minutes == otherClock.minutes))
            return true;
        return false;
    }
}
