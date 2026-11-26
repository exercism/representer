using System;

class RemoteControlCar {
    // TODO: define the constructor for the 'RemoteControlCar' class
    public int speed;
    public int batteryDrain;

    public int distanceDriven;
    public int currentBattery = 100;

    public RemoteControlCar(int speed, int batteryDrain) {
        this.speed = speed;
        this.batteryDrain = batteryDrain;
    }

    public bool BatteryDrained() {
        var batteryDrained = currentBattery - batteryDrain < 0;

        return batteryDrained;
    }

    public int DistanceDriven() {
        return distanceDriven;
    }

    public void Drive() {
        if (!BatteryDrained()) {
            distanceDriven += speed;
            currentBattery -= batteryDrain;
            Console.WriteLine(speed);
        }
    }

    public static RemoteControlCar Nitro() {
        return new RemoteControlCar(50, 4);
    }
}

class RaceTrack {
    // TODO: define the constructor for the 'RaceTrack' class
    private int distance;

    public RaceTrack(int distance) {
        this.distance = distance;
    }

    public bool TryFinishTrack(RemoteControlCar car) {
        var canFinishTrack = true;

        while (distance > car.distanceDriven) {
            if (car.BatteryDrained()) {
                canFinishTrack = false;
                break;
            }

            car.Drive();
        }

        return canFinishTrack;
    }
}