import gleam/int
import gleam/float
import gleam/string
import gleam/result

pub fn pence_to_pounds(pence: Int) -> Float {
  pence |> int.to_float(_) |> float.divide(_, 100.0) |> result.unwrap(_, 0.0)
}

pub fn pounds_to_string(pounds: Float) -> String {
  pounds |> float.to_string(_) |> string.append("£", _)
}
