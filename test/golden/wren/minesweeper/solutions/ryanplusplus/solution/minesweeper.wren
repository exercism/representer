var NEIGHBOR_OFFSETS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]

class Minesweeper {
  static annotate(grid) {
    grid = grid.map { |row| row.toList }.toList

    (0...grid.count).each { |y|
      (0...grid[0].count).each { |x|
        if (grid[y][x] == "*") return

        var count = minesNear(grid, x, y)

        if (count > 0) grid[y][x] = count.toString
      }
    }

    return grid.map { |row| row.join() }.toList
  }

  static minesNear(grid, x, y) {
    var count = 0

    NEIGHBOR_OFFSETS.each { |dxdy|
      var xx = x + dxdy[0]
      var yy = y + dxdy[1]

      if (xx < 0 || yy < 0 || xx >= grid[0].count || yy >= grid.count) return
      if (grid[yy][xx] == "*") count = count + 1
    }

    return count
  }
}
