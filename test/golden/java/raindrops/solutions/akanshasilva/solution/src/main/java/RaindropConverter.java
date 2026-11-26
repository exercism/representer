class RaindropConverter {

    String convert(int number) {
       StringBuilder obj=new StringBuilder();
        if(number%3==0){
            obj.append("Pling");
        }
        if(number%5==0){
            obj.append("Plang");
        }
        if(number%7==0){
            obj.append("Plong");
            }
        if(obj.length()==0){
            obj.append(number);
            }
        
        return obj.toString();
}
}
