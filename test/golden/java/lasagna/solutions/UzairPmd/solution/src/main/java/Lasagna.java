public class Lasagna {
    public int expectedMinutesInOven(){
        return 40;
    }

public int remainingMinutesInOven(int x){
    return expectedMinutesInOven()-x;
}
    
public int preparationTimeInMinutes(int y){
    return y+y;
}
    
    public int totalTimeInMinutes(int y,int x){
        return preparationTimeInMinutes(y)+x;
    }
    public static void main (String []args){
        Lasagna ls=new Lasagna();
       ls.expectedMinutesInOven();
         ls.remainingMinutesInOven(30);
         ls.preparationTimeInMinutes(2);
         ls.totalTimeInMinutes(3,20);
    }
}
