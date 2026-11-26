/**
* Your implmentation of the DifferenceOfSquares exercise
*/
component {

	 function squareOfSum( number ) {
		 var result = 0;

		 for(i=1; i<=number; i=i+1){
			 result += i;
		 }
		return result * result;
	}

	 function sumOfSquares( number ) {
		 var result = 0;
		 for(i=1; i<=number; i=i+1){
			 result += i*i;
		 }
		return result;
	}

	 function differenceOfSquares( number ) {
		return squareOfSum(number) - sumOfSquares(number);
	}

}