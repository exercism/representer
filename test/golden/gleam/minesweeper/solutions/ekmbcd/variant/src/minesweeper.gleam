import gleam/list
import gleam/string
import gleam/int

pub fn annotate(minefield: String) -> String {
  minefield
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> find_bombs()
  |> list.map(string.join(_, ""))
  |> string.join("\n")
}

fn find_bombs(field: List(List(String))) -> List(List(String)) {
  list.index_map(field, fn(row, x) {
    list.index_map(row, fn(letter, y) {
      case letter {
        "*" -> "*"
        _ -> count_bombs(field, x, y)
      }
    })
  })
}

fn count_bombs(field: List(List(String)), x: Int, y: Int) -> String {
  let num = list.index_fold(field, 0, fn(acc, row, h) {
    let row_total = list.index_fold(row, 0, fn(acc_row, el, v){
      case el, is_adiacent(x, h), is_adiacent(y, v) {
        "*", True, True -> acc_row + 1
        _, _, _ -> acc_row
      }
    })
    row_total + acc
  })
  case num {
    0 -> "_"
    _ -> int.to_string(num)
  }
}

fn is_adiacent(from: Int, target: Int) -> Bool {
  target >= from + 1 && target <= from + 1
}