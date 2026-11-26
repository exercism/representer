using System;

class RemoteControlCar
{
    private int speed;
    private int batteryDrain;
    private int drivenMeters;
    private int batteryLife = 100;
    private bool batteryEmpty = false;
    
    public RemoteControlCar(int speed, int batteryDrain)
    {
        this.speed = speed;
        this.batteryDrain = batteryDrain;
    }

    public bool BatteryDrained()
    {
        if (batteryLife <= 0 || batteryLife - batteryDrain < 0)
        {
            return true;
        } 
        else
        {
            return false;
        }
    }

    public int DistanceDriven()
    {
        return drivenMeters;
    }

    public void Drive()
    {
        if (batteryLife - batteryDrain >= 0)
        {
            drivenMeters = drivenMeters + speed;
            batteryLife = batteryLife - batteryDrain;
            Console.WriteLine(batteryLife);
        }
    }

    public static RemoteControlCar Nitro()
    {
        return new RemoteControlCar(50, 4);
    }
}

class RaceTrack
{
    private int distance;
    
    public RaceTrack(int distance)
    {
        this.distance = distance;
    }

    public bool TryFinishTrack(RemoteControlCar car)
    {
        while (!car.BatteryDrained())
        {
            car.Drive();
        }
        return (car.DistanceDriven() >= distance);
    }
}
