import java.util.ArrayList;

class RotationalCipher {
    private int shiftKey;
    
    RotationalCipher(int shiftKey) {
        this.shiftKey = shiftKey;
    }

    String rotate(String data) {
        String lowerData = data.toLowerCase();

         System.out.println(data+"\n"+lowerData);

        //Array for orignal data cases
         char[] regularData = data.toCharArray();

        //Array for data in lower case form 
         char[] dataChar = lowerData.toCharArray(); 

        //ArrayLists
         ArrayList<Character> alphaList = new ArrayList<Character>();
         ArrayList<Character> dataList = new ArrayList<Character>();
         ArrayList<Character> ansList = new ArrayList<Character>();

        //add alphabet to alphaList twice, to make rotation easier
         for(char i = 'a'; i <='z'; i++){
             alphaList.add(i);
         }
        for(char i = 'a'; i <='z'; i++){
             alphaList.add(i);
         }

        //Add data to dataList
         for(int i = 0; i<dataChar.length; i++){
             dataList.add(dataChar[i]); 
         }

        //Adds the digits and special characters to ansList. 
        //Adds the shiftKey of the alphabets to ansList
         for(Character d : dataList){
             if(alphaList.contains(d)){
                 ansList.add(alphaList.get(alphaList.indexOf(d)+shiftKey));
             }
             if(Character.isDigit(d)){
                 ansList.add(d);
             }
             if(d == '\'' || d == '.' || d == '!' && d == ','){
             	ansList.add(d);
             }
         }

        //If the original data array has a space add that back into ansList 
         for(int i = 0; i<regularData.length; i++){
             if(regularData[i] == ' '){
                 ansList.add(i, ' ');
             }
         }
                  
         String listString = "";      

        //Convert String arrayList to String with the proper letter case
         for(int i = 0; i<ansList.size(); i++){
            if(Character.isUpperCase(regularData[i]) == true){
                listString += Character.toUpperCase(ansList.get(i));
            }
            else{
                listString += ansList.get(i);
            }
         }        
        return listString;      
    }
}
