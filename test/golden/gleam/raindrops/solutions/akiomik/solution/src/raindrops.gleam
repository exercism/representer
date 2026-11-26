import gleam/int as i

pub fn convert(number: Int) -> String {
  let pling = number % 3 == 0
  let plang = number % 5 == 0
  let plong = number % 7 == 0

  case number {
    _ if pling && plang && plong -> "PlingPlangPlong"
    _ if pling && plang          -> "PlingPlang"
    _ if pling && plong          -> "PlingPlong"
    _ if plang && plong          -> "PlangPlong"
    _ if pling                   -> "Pling"
    _ if plang                   -> "Plang"
    _ if plong                   -> "Plong"
    _                            -> i.to_string(number)
  }
}
