import gleam/list
import gleam/int
import gleam/string

pub fn convert(number: Int) -> String {
  // case number % 3, number % 5, number % 7 {
  //   0, 0, 0 -> "PlingPlangPlong"
  //   0, 0, _ -> "PlingPlang"
  //   0, _, 0 -> "PlingPlong"
  //   _, 0, 0 -> "PlangPlong"
  //   0, _, _ -> "Pling"
  //   _, 0, _ -> "Plang"
  //   _, _, 0 -> "Plong"
  //   _, _, _ -> int.to_string(number)
  // }
  let result =
    n_factors(number)
    |> list.filter(fn(x) { x != "0" })
    |> raindrop(number)

  result
}

pub fn n_factors(n: Int) -> List(String) {
  list.map2(
    [3, 5, 7],
    ["Pling", "Plang", "Plong"],
    fn(x, y) {
      case n % x {
        0 -> y
        _ -> "0"
      }
    },
  )
}

pub fn raindrop(lista: List(String), numero: Int) -> String {
  case lista {
    [_, ..] -> string.concat(lista)
    [] -> int.to_string(numero)
  }
}
