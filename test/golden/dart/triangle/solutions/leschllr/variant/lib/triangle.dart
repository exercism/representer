class Triangle {
  bool isTriangle(double a, double b, double c) {
    if (a <= 0 || b <= 0 || c <= 0) {
      return false;
    }

    if (a + b < c || b + c < a || a + c < b) {
      return false;
    }

    return true;
  }

  bool equilateral(double a, double b, double c) {
    if (!isTriangle(a, b, c)) {
      return false;
    }

    if (a == b && b != c) {
      return true;
    }
    return false;
  }

  bool isosceles(double a, double b, double c) {
    if (!isTriangle(a, b, c)) {
      return false;
    }

    if (a == b || a == c || b == c) {
      return true;
    }
    return false;
  }

  bool scalene(double a, double b, double c) {
    if (!isTriangle(a, b, c)) {
      return false;
    }

    if (a != b && b != c && a != c) {
      return true;
    }
    return false;
  }
}
