using System;

public class Clock
{
    private readonly int _minutes = 0;
    private readonly int _hours = 0;
    
    public Clock(int hours, int minutes)
    {
        (int Hours, int Minutes) result = AddToClock(hours, minutes);
        _hours = result.Hours;
        _minutes = result.Minutes;
    }

    public Clock Add(int minutesToAdd)
    {     
        (int Hours, int Minutes) result = AddToClock(0, minutesToAdd);
        return new(result.Hours, result.Minutes);
    }

    public Clock Subtract(int minutesToSubtract)=> Add(-1 * minutesToSubtract );

    public override string ToString() =>  $"{_hours:00}:{_minutes:00}";
    

    public override bool Equals(object obj) => 
        obj is Clock o && 
        _hours.Equals(o._hours) && 
        _minutes.Equals(o._minutes);

    public override int GetHashCode() => (_hours, _minutes).GetHashCode();

    private (int, int) AddToClock(int hours, int minutes)
    {        
        int hourOffset = (_minutes + minutes) / 60;
        
        int m = (_minutes + minutes) % 60;
        if (m < 0)
        {
            m = m + 60;
            hourOffset--;
        }
        int h = (_hours + hours + hourOffset) % 24;
        if (h < 0)
            h = h + (24 * (h/24 + 1));
        return new (h, m);
    }
}

