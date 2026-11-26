import 'package:collection/collection.dart';

class Hamming {
  int distance(String a, String b) {
    if (a.length != b.length) {
      throw ArgumentError('strands must be of equal length');
    }
    return IterableZip([a.runes, b.runes])
        .where((e) => e.first != e.last)
        .length;
  }
}
