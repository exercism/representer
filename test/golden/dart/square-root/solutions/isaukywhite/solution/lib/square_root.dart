class SquareRoot {
  int squareRoot(int number) {
    return _binarySearchSquareRoot(number);
  }

  int _binarySearchSquareRoot(int number) {
    int low = 0;
    int high = number;
    int result = 0;

    while (low <= high) {
      int mid = (low + high) ~/ 2;
      int square = mid * mid;

      if (square == number) {
        return mid;
      } else if (square < number) {
        low = mid + 1;
        result = mid;
      } else {
        high = mid - 1;
      }
    }

    return result;
  }
}
