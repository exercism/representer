public class ExperimentalRemoteControlCar implements RemoteControlCar{
    int distanceTravelled = 0;
    public void drive() {
        distanceTravelled += 21;
    }

    public int getDistanceTravelled() {
        return distanceTravelled;
    }
}
