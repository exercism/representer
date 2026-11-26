public class RemoteControlCar
{
    private enum SpeedUnits
    {
        MetersPerSecond,
        CentimetersPerSecond
    }
    private record struct Speed(decimal Amount, SpeedUnits SpeedUnits)
    {
        public override string ToString() => $"{Amount} {(SpeedUnits == SpeedUnits.MetersPerSecond ? "meters" : "centimeters")} per second";
    }
    public class CarTelemetry
    {
        private readonly RemoteControlCar _outerCar;
        internal CarTelemetry(RemoteControlCar outerCar) => _outerCar = outerCar;
        public void Calibrate() { }
        public bool SelfTest() => true;
        public void ShowSponsor(string sponsorName) => _outerCar.SetSponsor(sponsorName);
        public void SetSpeed(decimal amount, string unitsString) => _outerCar.SetSpeed(new Speed(amount, unitsString == "cps" ? SpeedUnits.CentimetersPerSecond : SpeedUnits.MetersPerSecond));
    }
    public string CurrentSponsor { get; private set; }
    public CarTelemetry Telemetry { get; private set; }
    private Speed _currentSpeed;
    public RemoteControlCar() => Telemetry = new CarTelemetry(this);
    public string GetSpeed() => _currentSpeed.ToString();
    private void SetSponsor(string sponsorName) => CurrentSponsor = sponsorName;
    private void SetSpeed(Speed speed) => _currentSpeed = speed;
}