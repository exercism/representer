import gleam/regexp
import gleam/string

pub fn hey(remark: String) -> String {
  string.trim(remark)
  |> fn(trimmed) {
    case is_question(trimmed), is_yelling(trimmed), is_silent(trimmed) {
      True, True, False -> "Calm down, I know what I'm doing!"
      False, True, False -> "Whoa, chill out!"
      True, False, False -> "Sure."
      _, _, True -> "Fine. Be that way!"
      _, _, _ -> "Whatever."
    }
  }
}

fn is_question(remark: String) -> Bool {
  string.ends_with(remark, "?")
}

fn is_yelling(remark: String) -> Bool {
  has_letters(remark) && string.uppercase(remark) == remark
}

fn is_silent(remark: String) -> Bool {
  string.byte_size(remark) != 0
}

fn has_letters(remark: String) -> Bool {
  let assert Ok(expression) = regexp.from_string("[a-zA-Z]")
  regexp.check(expression, remark)
}
