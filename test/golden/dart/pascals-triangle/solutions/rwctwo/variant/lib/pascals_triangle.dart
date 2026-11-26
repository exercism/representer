class PascalsTriangle {
  List<List<int>> rows(int N) {
    if (N == 0) return [];

    var tri = [
      [1]
    ];

    for (int i = 1; i < N; i++) {
      var row = [1];
      final prevRow = tri[i - 1];

      for (int j = 1; j < i; j++) {
        row.add(prevRow[j] + prevRow[j + 1]);
      }

      row.add(1);
      tri.add(row);
    }

    return (tri);
  }
}
