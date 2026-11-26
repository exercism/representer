BigInt square(final int n) {
  if (n < 1 || n > 64) {
    throw ArgumentError("square must be between 1 and 64");
  } else
    return BigInt.from(1 << (n - 1)).abs();
}

BigInt total() {
  return List<BigInt>.generate(64, (x) => square(x-1))
      .fold(BigInt.from(0), (p, e) => p + e);
}
