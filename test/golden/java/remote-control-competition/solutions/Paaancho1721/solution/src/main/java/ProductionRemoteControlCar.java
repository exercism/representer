class ProductionRemoteControlCar implements RemoteControlCar, Comparable<ProductionRemoteControlCar> {
    private int distanceTravelled = 0;
    private int numberVictories;
    
    public void drive() {
        distanceTravelled += 10;
    }

    public int getDistanceTravelled() {
        return distanceTravelled;
    }

    public int getNumberOfVictories() {
        return numberVictories;
    }

    public void setNumberOfVictories(int numberOfVictories) {
        numberVictories = numberOfVictories;
    }
    @Override
    public int compareTo(ProductionRemoteControlCar otherCar){
        return Integer.compare(otherCar.getNumberOfVictories(), this.numberVictories);
    }
}
