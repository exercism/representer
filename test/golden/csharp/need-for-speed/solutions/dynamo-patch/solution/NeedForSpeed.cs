using System;

class RemoteControlCar
{
    public int speed;
    public int batteryDrain;
    private int battery = 100;
    private int distance;
 

    public RemoteControlCar(int speed, int batteryDrain) {
        this.speed = speed;
        this.batteryDrain = batteryDrain;
    }

    public bool BatteryDrained() => this.battery < this.batteryDrain;
    

    public int DistanceDriven() => this.distance;

    public void Drive()
    {
        if (!this.BatteryDrained()) {
            this.battery -= this.batteryDrain;
            this.distance += this.speed;
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

    public RaceTrack (int distance) {
        this.distance = distance;
    }

    public bool TryFinishTrack(RemoteControlCar car)
    {
        do
        {
            car.Drive();
        } while (!car.BatteryDrained());

        return car.DistanceDriven() >= distance;
    }
}
