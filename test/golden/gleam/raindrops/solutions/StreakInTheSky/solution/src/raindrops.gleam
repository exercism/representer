import gleam/int

fn int_to_sound(factor: Int, sound: String) -> fn(Int) -> String {
  fn(number) {
    case number % factor {
      0 -> sound
      _ -> ""
    }
  }
}

pub fn convert(number: Int) -> String {
  let pling = int_to_sound(3, "Pling")
  let plang = int_to_sound(5, "Plang")
  let plong = int_to_sound(7, "Plong")
  let result = pling(number) <> plang(number) <> plong(number)
  case result {
    "" -> int.to_string(number)
    _ -> result
  }
}
