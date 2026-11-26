
extension AppendExtension on List<dynamic> {
  void append(List<dynamic> other) {
    addAll(other.cast<int>());
  }
}

extension CountExtension on List<dynamic> {
  int count() => length;
}

extension MapExtension on List<dynamic> {
  List<dynamic> myMap(int Function(int) f) {
    return map((e) => f(e as int)).toList();
  }
}

extension ReverseExtension on List<dynamic> {
  List<dynamic> reverse() => List<dynamic>.from(reversed);
}

extension ConcatExtension on List<dynamic> {
  List<dynamic> concat() => expand((e) => e as Iterable).toList();
}

extension FilterExtension on List<dynamic> {
  List<dynamic> filter(bool Function(int) test) {
    return where((e) => test(e as int)).toList();
  }
}

extension FoldlExtension on List<dynamic> {
  R foldl<T, R>(R initialValue, R Function(R acc, T el) combine) {
    R result = initialValue;
    for (var el in this) {
      result = combine(result, el as T);
    }
    return result;
  }
}

extension FoldrExtension on List<dynamic> {
  R foldr<T, R>(R initialValue, R Function(T el, R acc) combine) {
    R result = initialValue;
    for (var el in this.reversed) {
      result = combine(el as T, result);
    }
    return result;
  }
}