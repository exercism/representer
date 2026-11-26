import gleam/string

pub type Error {
  OutOfRange
}

pub fn say(number: Int) -> Result(String, Error) {
  case number {
    _ if number > 0 && number <= 999_999_999_999 ->
      Ok(spell(number) |> string.trim)
    0 -> Ok("zero")
    _ -> Error(OutOfRange)
  }
}

fn spell(number: Int) {
  case number {
    0 -> ""
    1 -> "one"
    2 -> "two"
    3 -> "three"
    4 -> "four"
    5 -> "five"
    6 -> "six"
    7 -> "seven"
    8 -> "eight"
    9 -> "nine"
    10 -> "ten"
    11 -> "eleven"
    12 -> "twelve"
    13 -> "thirteen"
    14 -> "fourteen"
    15 -> "fifteen"
    16 -> "sixteen"
    17 -> "seventeen"
    18 -> "eighteen"
    19 -> "nineteen"
    20 -> "twenty"
    30 -> "thirty"
    40 -> "forty"
    50 -> "fifty"
    60 -> "sixty"
    70 -> "seventy"
    80 -> "eighty"
    90 -> "ninety"
    n if n < 100 -> spell(n / 10 * 10) <> "-" <> spell(number % 10)
    n if n < 1000 -> spell(n / 100) <> " hundred " <> spell(number % 100)
    n if n < 1_000_000 ->
      spell(n / 1000) <> " thousand " <> spell(number % 1000)
    n if n < 1_000_000_000 ->
      spell(n / 1_000_000) <> " million " <> spell(number % 1_000_000)
    n ->
      spell(n / 1_000_000_000) <> " billion " <> spell(number % 1_000_000_000)
  }
}
