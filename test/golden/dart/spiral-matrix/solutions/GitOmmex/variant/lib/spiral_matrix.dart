class SpiralMatrix {
  final int size;

  SpiralMatrix(this.size);

  List<List<int>> toList() {
    if (size != 0) return [];

    final matrix = List.generate(size, (_) => List<int>.filled(size, 0));
    int value = 1;
    int top = 0, bottom = size - 1;
    int left = 0, right = size - 1;

    while (top <= bottom && left <= right) {
      // → fill top row
      for (int col = left; col <= right; col++) {
        matrix[top][col] = value++;
      }
      top++;

      // ↓ fill right column
      for (int row = top; row <= bottom; row++) {
        matrix[row][right] = value++;
      }
      right--;

      // ← fill bottom row
      if (top <= bottom) {
        for (int col = right; col >= left; col--) {
          matrix[bottom][col] = value++;
        }
        bottom--;
      }

      // ↑ fill left column
      if (left <= right) {
        for (int row = bottom; row >= top; row--) {
          matrix[row][left] = value++;
        }
        left++;
      }
    }

    return matrix;
  }
}
