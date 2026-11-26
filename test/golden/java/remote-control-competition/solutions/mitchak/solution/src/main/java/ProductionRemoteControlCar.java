
class ProductionRemoteControlCar implements RemoteControlCar, Comparable <ProductionRemoteControlCar>{
    private int distance;
    private int numberOfVictories;
    
    @Override
    public void drive() {
        this.distance += 10;
    }
    @Override
    public int getDistanceTravelled() {
        return this.distance;
    }

    @Override
    public int compareTo (ProductionRemoteControlCar other){
        return Integer.compare(other.getNumberOfVictories(), this.getNumberOfVictories());
    }

    public int getNumberOfVictories() {
        return this.numberOfVictories;
    }

    public void setNumberOfVictories(int numberOfVictories) {
        this.numberOfVictories = numberOfVictories;
    }
}
