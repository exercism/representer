import gleam/int
pub fn convert(number: Int) -> String {
  let result = pling(number) <> plang(number) <> plong(number)
  case result {
    "" -> int.to_string(number)
    _ -> result
  }
}

fn pling(number: Int) -> String {
  case number % 3 == 0 {
    True -> "Pling"
    False -> ""
  }
}

fn plang(number: Int) -> String {
  case number % 5 == 0 {
    True -> "Plang"
    False -> ""
  }
}

fn plong(number: Int) -> String {
  case number % 7 == 0 {
    True -> "Plong"
    False -> ""
  }
}
