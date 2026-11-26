public class CarsAssemble {

    public double productionRatePerHour(int speed) {
        if (speed==0){
            return 0;
        }
            if(speed >=1 && speed <=4){
                return (double)speed * 221 *1;
            }
            else if(speed >=5 && speed <=8){
                return (double)speed * 221 *0.9;

            }
            else if(speed ==9){
                return (double)speed * 221 *0.8;

            }
            else if(speed ==10){
                return (double)speed * 221 *0.77;

            }
            return 0;
    }

    public int workingItemsPerMinute(int speed) {
        return (int) this.productionRatePerHour(speed)/60;
    }
}
