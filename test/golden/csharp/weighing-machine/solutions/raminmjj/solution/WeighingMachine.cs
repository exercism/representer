using System;

class WeighingMachine
{
    private readonly int _precision;
    private double _weight;
    public WeighingMachine(int precision){
        _precision = precision;
    }
    
    public int Precision{
        get{ return _precision;} 
    }

    public double Weight{
        get{ return _weight;}
        set{
             if(value<0)
               throw new ArgumentOutOfRangeException();
             _weight = value;
           }
    }
    
    public string DisplayWeight{
        get{ return $"{(this.Weight - this.TareAdjustment).ToString($"f{Precision}")} kg";}
    }
    
    public double TareAdjustment{get;set;} = 5;
}
