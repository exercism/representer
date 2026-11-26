namespace RedRemoteControlCarTeam
{
    public class RemoteControlCar
    {
        public RemoteControlCar(Motor motor, Chassis chassis, Telemetry telemetry, RunningGear runningGear)
        {
            
        }
    }
    
    public class RunningGear
    {
        public RunningGear()
        {

        }
    }
    
    public class Telemetry
    {
        public Telemetry()
        {

        }
    }
    
    public class Chassis
    {
        public Chassis()
        {

        }
    }
    
    public class Motor
    {
        public Motor()
        {

        }
    }
}


namespace BlueRemoteControlCarTeam
{
    public class RemoteControlCar
    {
        public RemoteControlCar(Motor motor, Chassis chassis, Telemetry telemetry)
        {
            
        }
        
    }

    public class RunningGear
    {
        public RunningGear()
        {

        }
    }
    
    public class Telemetry
    {
        public Telemetry()
        {

        }
    }
    
    public class Chassis
    {
        public Chassis()
        {

        }
    }
    
    public class Motor
    {
        public Motor()
        {

        }
    }
}

namespace Combined
{
    using Red = RedRemoteControlCarTeam;
    using Blue = BlueRemoteControlCarTeam;
    
    public class CarBuilder
    {
        public static Red.RemoteControlCar BuildRed()
        {
            return new Red.RemoteControlCar(
                new Red.Motor(),
                new Red.Chassis(),
                new Red.Telemetry(),
                new Red.RunningGear()
            );
        }
    
        public static Blue.RemoteControlCar BuildBlue()
        {
            return new Blue.RemoteControlCar(
                new Blue.Motor(),
                new Blue.Chassis(),
                new Blue.Telemetry()
            );
        }
    }    
}
