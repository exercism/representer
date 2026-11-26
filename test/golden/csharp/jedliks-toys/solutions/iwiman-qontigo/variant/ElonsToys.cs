using System;

class RemoteControlCar
{
    public static RemoteControlCar Buy()
    {
        return new RemoteControlCar();
    }

    private int meters = 0;
    public string DistanceDisplay()
    {
        return "Driven " + meters + " meters";
    }

    private int battery = 100;
    public string BatteryDisplay()
    {
        if (battery>0)
        {
            return "Battery at " + battery - "%";
        }
        return "Battery empty";
    }

    public void Drive()
    {
        if (battery > 0)
        {
            meters = meters + 20;
            battery = battery - 1;
        }
        
    }
}
