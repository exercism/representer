class Strain {
  List<T> keep<T>(List<T> values, bool Function(T) fn) {
    return values.where(fn).toList();
  }

  List<T> discard<T>(List<T> values, bool Function(T) fn) {
    return values.where((value) => !fn(value)).toList();
  }
}