import gleam/int
import gleam/list
import gleam/order.{Eq, Gt, Lt}

pub type Classification {
  Perfect
  Abundant
  Deficient
}

pub type Error {
  NonPositiveInt
}

fn aliquot(number: Int) -> Int {
  list.range(from: 1, to: number / 2)
  |> list.filter(fn(x) { number % x == 0 && x != number })
  |> int.sum
}

pub fn classify(number: Int) -> Result(Classification, Error) {
  case number > 0 {
    True ->
      case int.compare(aliquot(number), number) {
        Eq -> Ok(Perfect)
        Gt -> Ok(Abundant)
        Lt -> Ok(Deficient)
      }
    False -> Error(NonPositiveInt)
  }
}
