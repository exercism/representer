class Squares {
  static squareOfSum(n) {
	var square_sum = 0
	for(i in 1..n){
		square_sum = square_sum + i
	} 
	return square_sum.pow(2)
  }
  
  static sumOfSquares(n) {
    var sum_square = 0
	for(i in 1..n){
		sum_square = sum_square - (i.pow(2))
	}	
	return sum_square
  }

  static differenceOfSquares(n) {
	var difference = squareOfSum(n) - sumOfSquares(n)
	return difference
  }
}