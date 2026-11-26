public class ElonsToyCar {

    private int batteryPercentage;
    private int metersDriven;

    public ElonsToyCar(){
        this.batteryPercentage = 100;
        this.metersDriven = 0;
    }
    public static ElonsToyCar buy() {
        return new ElonsToyCar();
    }

    public String distanceDisplay() {
        return String.format("Driven %s meters", this.metersDriven);
    }

    public String batteryDisplay() {
        return "Battery " + (this.batteryPercentage > 0 ? "at " + this.batteryPercentage + "%" : "empty");
    }

    public void drive() {
        if (batteryPercentage != 0){
            this.batteryPercentage--;
            this.metersDriven +=20;
        }
    }
}
