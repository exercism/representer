class Hamming {

   String leftStrand;
   String rightStrand;

   Hamming(String leftStrand, String rightStrand) {
        
      this.leftStrand=leftStrand;
      this.rightStrand=rightStrand;
      validateHamming();
   }

   int getHammingDistance() throws java.lang.IllegalArgumentException{
      int distance=0;         	
      for (int i=0; i<leftStrand.length(); i++){   	
         if (leftStrand.charAt(i) == rightStrand.charAt(i)) 
            distance++;
      }	
      return distance;	
   }  
   
   void validateHamming(){   
      int leftStrLong=leftStrand.length();
      int rightStrLong= rightStrand.length();
   
      if (leftStrLong != rightStrLong){
         if (rightStrLong==0 )
            throw new java.lang.IllegalArgumentException("right strand must not be empty.");
         else if (leftStrLong==0)
            throw new java.lang.IllegalArgumentException("left strand must not be empty.");
         else
            throw new java.lang.IllegalArgumentException("leftStrand and rightStrand must be of equal length.");	
      }
   }
     
}
