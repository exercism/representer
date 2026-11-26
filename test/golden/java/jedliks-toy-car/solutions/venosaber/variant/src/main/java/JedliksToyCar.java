public class JedliksToyCar {
    private int battery = 100;
    private int distance;
    
    public static JedliksToyCar buy() {
        return new JedliksToyCar();
    }

    public String distanceDisplay() {
        return String.format("Driven %d meters", distance);
    }

    public String batteryDisplay() {
        if (this.battery == 0){
            return "Battery empty";
        }
        return String.format("Battery at %d%%", battery);
    }

    public void drive() {
        if (this.battery < 0) {
            return;
        }
        this.battery -= 1;
        this.distance += 20;
    }
}
