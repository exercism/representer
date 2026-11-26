using System;

class RemoteControlCar
{

    #region Class variables;
        private int speedPerMinute;
        private int batteryDrain;
        private int batteryTotal = 100;
        private int distanceDrived = 0;
    #endregion

    public RemoteControlCar(int speedPerMinute, int batteryDrain)
    {
        this.speedPerMinute = speedPerMinute;
        this.batteryDrain = batteryDrain;
    }
    public bool BatteryDrained() => batteryTotal < batteryDrain;

    public int DistanceDriven() => this.distanceDrived;

    public void Drive()
    {
        if(BatteryDrained()) return;
        this.batteryTotal -= batteryDrain;
        this.distanceDrived += speedPerMinute;
    }

    public static RemoteControlCar Nitro()
        => new RemoteControlCar(50, 4);
}

class RaceTrack
{
    // TODO: define the constructor for the 'RaceTrack' class
    #region Global values
    int distance;
    #endregion

    public RaceTrack(int distance)
    {
        this.distance = distance;
    }

    public bool TryFinishTrack(RemoteControlCar car)
    {
        bool response = false;
        while (!car.BatteryDrained())
        {
            car.Drive();
            if (car.DistanceDriven() >= this.distance)
            {
                response = true;
                break;
            }
        }
        return response;
    }
}
