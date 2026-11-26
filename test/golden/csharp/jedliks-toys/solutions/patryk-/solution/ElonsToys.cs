using System;

class RemoteControlCar
{
    private int metersDriven = 0;
    private int batteryLevel = 100;


    public static RemoteControlCar Buy() => new RemoteControlCar();

    public string DistanceDisplay() => $"Driven {this.metersDriven} meters";
    public string BatteryDisplay() => this.batteryLevel > 0 ? $"Battery at {this.batteryLevel}%" : "Battery empty";

    public void Drive()
    {
        if (this.batteryLevel > 0)
        {
            this.metersDriven += 20;
            this.batteryLevel -= 1;
        }
    }
}
