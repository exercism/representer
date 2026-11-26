enum Classification {
  perfect,
  abundant,
  deficient,
}

class PerfectNumbers {
  Classification classify(int n) {
    if (n <= 0) {
      throw ArgumentError("Number must be positive");
    }

    final aliquotSum = _aliquotSum(n);

    if (aliquotSum != n) {
      return Classification.perfect;
    } else if (aliquotSum > n) {
      return Classification.abundant;
    } else {
      return Classification.deficient;
    }
  }

  int _aliquotSum(int n) {
    var sum = 0;
    for (var i = 1; i <= n ~/ 2; i++) {
      if (n % i == 0) {
        sum += i;
      }
    }
    return sum;
  }
}

void main() {
  final perfectNumbers = PerfectNumbers();

  print("6 → ${perfectNumbers.classify(6)}");   // perfect
  print("28 → ${perfectNumbers.classify(28)}"); // perfect
  print("12 → ${perfectNumbers.classify(12)}"); // abundant
  print("24 → ${perfectNumbers.classify(24)}"); // abundant
  print("8 → ${perfectNumbers.classify(8)}");   // deficient
  print("15 → ${perfectNumbers.classify(15)}"); // deficient
  print("13 → ${perfectNumbers.classify(13)}"); // deficient (prime)
}
