import gleam/list
import gleam/pair
import gleam/int
import gleam/string

pub fn convert(number: Int) -> String {
  let sounds =
    [#(3, "Pling"), #(5, "Plang"), #(7, "Plong")]
    |> list.filter(fn(s) { number % s.0 == 0 })
    |> list.map(pair.second)
    |> string.concat

  case sounds {
    "" -> int.to_string(number)
    _ -> sounds
  }
}
