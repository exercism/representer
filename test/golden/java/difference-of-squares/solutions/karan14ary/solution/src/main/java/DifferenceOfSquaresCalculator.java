class DifferenceOfSquaresCalculator {

   static int computeSquareOfSumTo(int input) {
      int s=0;
        for(int i=1;i<=input;i++) {
        s+=i;   
       }  
        return s*s;
        }

   static int computeSumOfSquaresTo(int input) {
   int s=0;
        for(int i=1;i<=input;i++) {
        s+=(int)Math.pow(i,2);   
       }  
        return s;
        }

    static int computeDifferenceOfSquares(int input) {
        int s1=computeSquareOfSumTo(input);
        int s2=computeSumOfSquaresTo(input);
        return s1-s2;
    }
    

}
