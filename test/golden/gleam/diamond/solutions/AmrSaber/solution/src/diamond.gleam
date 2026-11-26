import gleam/io
import gleam/list
import gleam/string

pub fn build(letter: String) -> String {
  let letter = string.uppercase(letter)

  let first_half = list_chars(letter)
  let second_half = first_half |> list.reverse |> list.drop(1)

  let char_list = list.append(first_half, second_half)

  char_list
  |> list.map(fn(char) { build_line(char, letter) })
  |> string.join("\n")
}

fn list_chars(end_char: String) -> List(String) {
  list.range(char_to_value("A"), char_to_value(end_char))
  |> list.map(value_to_char)
}

fn build_line(char: String, target: String) -> String {
  let padding = get_padding(char, target)
  padding <> get_fill(char) <> padding
}

fn get_padding(char: String, target: String) -> String {
  char_to_value(target) - char_to_value(char)
  |> list.repeat(" ", _)
  |> string.concat
}

fn get_fill(char: String) -> String {
  let count = 2 * { char_to_value(char) - char_to_value("A") } - 1
  case count > 0 {
    False -> char
    True -> char <> string.concat(list.repeat(" ", count)) <> char
  }
}

fn char_to_value(char: String) -> Int {
  let assert [char_codepoint, ..] = string.to_utf_codepoints(char)
  string.utf_codepoint_to_int(char_codepoint)
}

fn value_to_char(value: Int) -> String {
  let assert Ok(codepoint) = string.utf_codepoint(value)
  string.from_utf_codepoints([codepoint])
}
