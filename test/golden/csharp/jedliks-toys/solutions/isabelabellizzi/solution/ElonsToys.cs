using System;

class RemoteControlCar
{
    private int distanceDriven = 0;
    private int battery = 100;
    
    public static RemoteControlCar Buy() => new RemoteControlCar();

    public string DistanceDisplay() => $"Driven {this.distanceDriven} meters";

    public string BatteryDisplay() => (this.battery > 0) ? $"Battery at {this.battery}%" : "Battery empty";

    public void Drive()
    {
        if (this.battery > 0)
        {
            this.distanceDriven += 20;
            this.battery -= 1;
        }
    }
}
