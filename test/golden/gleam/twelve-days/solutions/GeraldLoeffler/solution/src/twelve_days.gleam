import gleam/bool.{lazy_guard}
import gleam/string_tree.{type StringTree, append}

pub fn verse(number: Int) -> String {
  "On the "
  <> ordinal(number)
  <> " day of Christmas my true love gave to me: "
  <> thingies(number)
}

pub fn lyrics(from starting_verse: Int, to ending_verse: Int) -> String {
  lyrics_acc(starting_verse, ending_verse, string_tree.new())
}

fn lyrics_acc(from: Int, to: Int, acc: StringTree) -> String {
  case from {
    f if f >= to -> acc |> append(verse(f)) |> string_tree.to_string
    f -> acc |> append(verse(f)) |> append("\n") |> lyrics_acc(f + 1, to, _)
  }
}

fn thingies(number: Int) -> String {
  thingies_acc(number, string_tree.new())
}

fn thingies_acc(n: Int, acc: StringTree) -> String {
  use <- lazy_guard(n < 1, fn() { string_tree.to_string(acc) })

  let appendix = case n {
    n if n == 1 -> "."
    n if n == 2 -> ", and "
    _ -> ", "
  }
  acc |> append(thingy(n)) |> append(appendix) |> thingies_acc(n - 1, _)
}

fn ordinal(n: Int) -> String {
  ordinal_thingy(n).0
}

fn thingy(n: Int) -> String {
  ordinal_thingy(n).1
}

fn ordinal_thingy(n: Int) -> #(String, String) {
  case n {
    1 -> #("first", "a Partridge in a Pear Tree")
    2 -> #("second", "two Turtle Doves")
    3 -> #("third", "three French Hens")
    4 -> #("fourth", "four Calling Birds")
    5 -> #("fifth", "five Gold Rings")
    6 -> #("sixth", "six Geese-a-Laying")
    7 -> #("seventh", "seven Swans-a-Swimming")
    8 -> #("eighth", "eight Maids-a-Milking")
    9 -> #("ninth", "nine Ladies Dancing")
    10 -> #("tenth", "ten Lords-a-Leaping")
    11 -> #("eleventh", "eleven Pipers Piping")
    12 -> #("twelfth", "twelve Drummers Drumming")
    _ -> panic as "only numbers in range [1,12] supported"
  }
}
