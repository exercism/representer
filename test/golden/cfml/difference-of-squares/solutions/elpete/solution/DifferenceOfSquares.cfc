/**
* Your implmentation of the DifferenceOfSquares exercise
*/
component {

	 function squareOfSum( number ) {
	 	var total = 0;
		for ( var i = 1; i <= number; i++ ) {
			total += i;
		}
		return total * total;
	}

	 function sumOfSquares( number ) {
	 	var total = 0;
		for ( var i = 1; i <= number; i++ ) {
			total += i * i;
		}
		return total;
	}

	 function differenceOfSquares( number ) {
		return squareOfSum( number ) - sumOfSquares( number );
	}

}