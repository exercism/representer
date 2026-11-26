import gleam/dict.{type Dict}
import gleam/list
import gleam/string

pub fn transform(legacy: Dict(Int, List(String))) -> Dict(String, Int) {
  legacy
  |> dict.fold(dict.new(), fn(acc, score, chars) {
    chars
    |> list.fold(acc, fn(acc1, char) {
      dict.insert(acc1, string.lowercase(char), score)
    })
  })
}
