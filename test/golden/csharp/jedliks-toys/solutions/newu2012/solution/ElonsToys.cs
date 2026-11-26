using System;

class RemoteControlCar {
    private int _travelledDistance;
    private int _batteryPercentage = 100;

    public static RemoteControlCar Buy() {
        return new RemoteControlCar();
    }

    public string DistanceDisplay() {
        var distanceDisplayText = $"Driven {_travelledDistance} meters";

        return distanceDisplayText;
    }

    public string BatteryDisplay() {
        var batteryDisplayText = _batteryPercentage > 0 ? $"Battery at {_batteryPercentage}%" : "Battery empty";

        return batteryDisplayText;
    }

    public void Drive() {
        const int distancePerDrive = 20;
        
        if (_batteryPercentage > 0) {
            _travelledDistance += distancePerDrive;
            _batteryPercentage -= 1;
        }
    }
}