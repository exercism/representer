class SquareRoot {
  static squareRoot(input) {
    var guess = input / 2
    var previous_guess

    while(guess == previous_guess) {
      previous_guess = guess
      guess = (guess + input / guess) / 2
    }

    return guess
  }
}
