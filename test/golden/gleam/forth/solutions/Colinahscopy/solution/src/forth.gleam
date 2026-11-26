import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Forth {
  Forth(stack: List(Int), words: Dict(String, List(String)))
}

pub type ForthError {
  DivisionByZero
  StackUnderflow
  InvalidWord
  UnknownWord
}

pub fn new() -> Forth {
  Forth(stack: [], words: dict.new())
}

pub fn format_stack(forth: Forth) -> String {
  forth.stack |> list.reverse |> list.map(int.to_string) |> string.join(" ")
}

pub fn eval(forth: Forth, prog: String) -> Result(Forth, ForthError) {
  let items = prog |> string.lowercase |> string.split(" ")

  case items {
    [":", new_word, ..rest] ->
      define_word(
        new_word,
        on: forth,
        // Let's assume the last item item is `;` (it should be) and drop it:
        with_items: rest |> list.take(list.length(rest) - 1),
      )

    _ -> list.try_fold(items, forth, eval_item)
  }
}

fn define_word(
  new_word: String,
  on forth: Forth,
  with_items items: List(String),
) -> Result(Forth, ForthError) {
  use <- bool.guard(
    when: new_word |> int.parse |> result.is_ok,
    return: Error(InvalidWord),
  )

  list.flat_map(items, fn(item) {
    dict.get(forth.words, item) |> result.unwrap([item])
  })
  |> dict.insert(forth.words, new_word, _)
  |> fn(words) { Ok(Forth(..forth, words: words)) }
}

fn eval_item(forth: Forth, item: String) -> Result(Forth, ForthError) {
  dict.get(forth.words, item)
  |> result.replace_error(UnknownWord)
  |> result.try(list.try_fold(_, forth, eval_item))
  |> result.try_recover(fn(_) {
    int.parse(item)
    |> result.try(fn(number) {
      Ok(Forth(..forth, stack: [number, ..forth.stack]))
    })
  })
  |> result.try_recover(fn(_) {
    case item {
      "+" | "-" | "*" | "/" | "drop" | "dup" | "over" | "swap" -> {
        case item, forth.stack {
          "+", [a, b, ..rest] -> Ok(Forth(..forth, stack: [b + a, ..rest]))
          "-", [a, b, ..rest] -> Ok(Forth(..forth, stack: [b - a, ..rest]))
          "*", [a, b, ..rest] -> Ok(Forth(..forth, stack: [b * a, ..rest]))
          "/", [0, _, ..] -> Error(DivisionByZero)
          "/", [a, b, ..rest] -> Ok(Forth(..forth, stack: [b / a, ..rest]))
          "drop", [_, ..rest] -> Ok(Forth(..forth, stack: rest))
          "dup", [a, ..rest] -> Ok(Forth(..forth, stack: [a, a, ..rest]))
          "over", [a, b, ..rest] -> Ok(Forth(..forth, stack: [b, a, b, ..rest]))
          "swap", [a, b, ..rest] -> Ok(Forth(..forth, stack: [b, a, ..rest]))
          _, _ -> Error(StackUnderflow)
        }
      }
      _ -> Error(UnknownWord)
    }
  })
}