public class JedliksToyCar {
    private int drivenDistance;
    private int remainBattery = 100;

     private Boolean isBatteryEmpty() {
        return remainBattery == 0;
    }
    
    public static JedliksToyCar buy() {
        return new JedliksToyCar();
    }

    public String distanceDisplay() {
        return "Driven " + drivenDistance + " meters";
    }

    public String batteryDisplay() {
        return isBatteryEmpty() ? "Battery empty" : "Battery at " + remainBattery + '%';
    }

    public void drive() {
        if(isBatteryEmpty()) {
            return;
        }
        drivenDistance += 20;
        remainBattery -= 1;
    }
}
