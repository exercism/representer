import 'dart:math';

class Darts {
  // Put your code here
  int score(double x, double y) {
    var d = sqrt(x * x + y * y);
    if (d <= 1) return 10;
    if (d <= 5) return 5;
    if (d <= 10) return 1;

    return 0;
  }
}
