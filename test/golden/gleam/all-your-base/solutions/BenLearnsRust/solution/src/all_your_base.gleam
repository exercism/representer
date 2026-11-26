import gleam/result
import gleam/list

pub type Error {
  InvalidBase(Int)
  InvalidDigit(Int)
}

fn from_digits(digits: List(Int), base: Int) -> Result(Int, Error) {
  digits
  |> list.try_fold(
    from: 0,
    with: fn(acc, d) {
      case d >= 0 && d < base {
        False -> Error(InvalidDigit(d))
        True -> Ok(base * acc + d)
      }
    },
  )
}

fn to_digits(number: Int, base: Int, acc: List(Int)) -> List(Int) {
  case number, acc {
    0, [] -> [0]
    0, x -> x
    n, _ -> to_digits(n / base, base, [n % base, ..acc])
  }
}

pub fn rebase(
  digits digits: List(Int),
  input_base input_base: Int,
  output_base output_base: Int,
) -> Result(List(Int), Error) {
  let validate_base = fn(base) {
    case base <= 1 {
      True -> Error(InvalidBase(base))
      False -> Ok(Nil)
    }
  }

  use _ <- result.try(validate_base(input_base))
  use _ <- result.try(validate_base(output_base))
  use number <- result.try(from_digits(digits, input_base))
  Ok(to_digits(number, output_base, []))
}
