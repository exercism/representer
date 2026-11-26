public class Lasagna {
    
    public int expectedMinutesInOven(){
        return 40;
    }

    public int remainingMinutesInOven(int minInOven){
        return expectedMinutesInOven() - minInOven;
    }

    public int preparationTimeInMinutes(int numOfLayers){
        return numOfLayers * 2;
    }

    public int totalTimeInMinutes(int numOfLayers, int minInOven){
        return preparationTimeInMinutes(numOfLayers) + minInOven;
    }

}
