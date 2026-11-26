class GameOfLife {
  List<List<int>> _grid;

  GameOfLife(List<List<int>> matrix)
      : _grid = matrix.map((row) => List<int>.from(row)).toList();

  void tick() {
    if (_grid.isEmpty) return;

    int rows = _grid.length;
    int cols = _grid[0].length;

    List<List<int>> next =
        List.generate(rows, (_) => List.filled(cols, 0));

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        int neighbors = _countNeighbors(i, j);

        if (_grid[i][j] == 1) {
          if (neighbors == 2 || neighbors == 3) {
            next[i][j] = 1;
          } else {
            next[i][j] = 0;
          }
        } else {
          if (neighbors == 3) {
            next[i][j] = 1;
          }
        }
      }
    }

    _grid = next;
  }

  int _countNeighbors(int row, int col) {
    int count = 0;

    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;

        int r = row + dr;
        int c = col + dc;

        if (r >= 0 &&
            r < _grid.length &&
            c >= 0 &&
            c < _grid[0].length &&
            _grid[r][c] == 1) {
          count++;
        }
      }
    }

    return count;
  }

  List<List<int>> matrix() {
    return _grid.map((row) => List<int>.from(row)).toList();
  }
}
