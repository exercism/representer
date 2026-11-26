sealed class RemoteControlCar
{
    public static RemoteControlCar Buy() => new();

    private int _distanceDriven;
    public string DistanceDisplay() => $"Driven {_distanceDriven} meters";

    public float _battery = 1f;
    public string BatteryDisplay() => _battery < 0.0001f 
        ? "Battery empty" 
        : $"Battery at {_battery:p0}".Replace(" %", "%");

    public void Drive()
    {
        if(_battery < 0.01f) return;
        _distanceDriven += 20;
        _battery -= 0.01f;
    }
}
