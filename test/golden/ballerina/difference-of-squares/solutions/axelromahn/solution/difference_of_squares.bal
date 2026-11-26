
public function squareOfSum(int n) returns int {
    var sum = int:sum(...from var i in 1...n select i);
    return sum * sum;
}

public function sumOfSquares(int n) returns int {
    return int:sum(...from var i in 1...n select i * i);    
}

public function differenceOfSquares(int n) returns int {
    return squareOfSum(n) - sumOfSquares(n);
}
