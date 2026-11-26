import gleam/dict
import gleam/int
import gleam/list
import gleam/result

pub type Position {
  Position(row: Int, column: Int)
}

pub fn saddle_points(matrix: List(List(Int))) -> List(Position) {
  let big_int = int.bitwise_shift_left(1, 63)

  let row_max =
    matrix
    |> list.index_map(fn(row, i) { #(i, list.fold(row, 0, int.max)) })
    |> dict.from_list

  let col_min =
    matrix
    |> list.transpose
    |> list.index_map(fn(col, i) { #(i, list.fold(col, big_int, int.min)) })
    |> dict.from_list

  matrix
  |> list.index_map(fn(trees, row) {
    trees
    |> list.index_map(fn(tree, col) {
      case dict.get(row_max, row), dict.get(col_min, col) {
        Ok(r), Ok(c) if r == tree && c == tree -> Ok(Position(row + 1, col + 1))
        _, _ -> Error(Nil)
      }
    })
  })
  |> list.flatten
  |> result.values
}