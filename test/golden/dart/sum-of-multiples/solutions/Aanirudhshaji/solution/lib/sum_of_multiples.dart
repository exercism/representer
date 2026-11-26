import 'package:collection/collection.dart';

class SumOfMultiples {
  int sum(List<int> factors, int limit) {
    final multiples = <int>{};

    for (final factor in factors) {
      if (factor == 0) continue;
      for (var i = factor; i < limit; i += factor) {
        multiples.add(i);
      }
    }

    return multiples.sum;
  }
}