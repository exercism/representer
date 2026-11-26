using System;

class RemoteControlCar
{
    private int _speed;
    private int _batteryDrain;
    private int _distanceDriven;
    private int _battery;

    public int speed => _speed;
    public int drainRate => _batteryDrain;
    public int battery => _battery;
    
    public RemoteControlCar(int speed, int drain)
    {
        _speed = speed;
        _batteryDrain = drain;
        _distanceDriven = 0;
        _battery = 100;
    }
    
    public bool BatteryDrained()
    {
        return _battery < _batteryDrain;
    }

    public int DistanceDriven()
    {
        return _distanceDriven;
    }

    public void Drive()
    {
        if (!BatteryDrained())
        {
            _distanceDriven += _speed;
            _battery -= _batteryDrain;   
        }
    }

    public static RemoteControlCar Nitro()
    {
        return new RemoteControlCar(50, 4);
    }
}

class RaceTrack
{
    private int _distance;
    
    public RaceTrack(int distance)
    {
        _distance = distance;
    }

    public bool TryFinishTrack(RemoteControlCar car)
    {
        return car.battery >= ((double)_distance/car.speed) * car.drainRate;
    }
}
