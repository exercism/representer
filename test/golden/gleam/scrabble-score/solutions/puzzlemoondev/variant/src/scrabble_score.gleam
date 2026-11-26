import gleam/int
import gleam/list
import gleam/string

fn letter_score(letter: String) -> Int {
  case string.lowercase(letter) {
    "a" | "e" | "i" | "o" | "u" | "l" | "n" | "r" | "s" | "t" -> 1
    "d" | "g" -> 2
    "b" | "c" | "m" | "p" -> 3
    "f" | "h" | "v" | "w" | "y" -> 4
    "k" -> 6
    "j" | "x" -> 8
    "q" | "z" -> 10
    _ -> 0
  }
}

pub fn score(word: String) -> Int {
  word
  |> string.to_graphemes
  |> list.map(letter_score)
  |> list.fold(0, int.add)
}
