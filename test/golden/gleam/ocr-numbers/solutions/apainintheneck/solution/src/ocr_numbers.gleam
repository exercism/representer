import gleam/string
import gleam/bool
import gleam/list

import exercism/test_runner.{ debug }

pub type Output {
  Unknown
  Digit(Int)
  List(List(Output))
}

pub type Error {
  InvalidLineNumber
  InvalidRowNumber
}

pub fn convert(input: String) -> Result(Output, Error) {
  let lines =
    input
    |> string.split("\n")
    |> list.drop(1)
    |> list.map(string.to_graphemes)

  use <- bool.guard(invalid_row_length(lines), Error(InvalidRowNumber))
  use <- bool.guard(invalid_line_length(lines), Error(InvalidLineNumber))

  let flat_digit_lines =
    lines
    |> list.map(list.sized_chunk(_, 3))
    |> list.sized_chunk(4)
    |> list.map(fn(line) {
      line
      |> list.transpose
      |> list.map(list.flatten)
      |> list.map(string.concat)
    })

  flat_digit_lines
  |> list.map(fn(line) { list.map(line, flat_digit_to_output) |> List })
  |> List
  |> flatten_output
  |> Ok
}

fn invalid_line_length(lines: List(List(String))) -> Bool {
  list.length(lines) % 4 != 0
}

fn invalid_row_length(lines: List(List(String))) -> Bool {
  list.any(lines, satisfying: fn(line) {
    let length = list.length(line)
    length == 0 || length % 3 != 0
  })
}

fn flatten_output(output: Output) -> Output {
  case output {
    List([]) -> Unknown
    List([List([one])]) -> flatten_output(one)
    List([List([..many])]) -> flatten_output(List(many))
    _ -> output
  }
}

fn flat_digit_to_output(flat_digit: String) -> Output {
  case flat_digit {
    "     |  |   " -> Digit(1)
    " _  _||_    " -> Digit(2)
    " _  _| _|   " -> Digit(3)
    "   |_|  |   " -> Digit(4)
    " _ |_  _|   " -> Digit(5)
    " _ |_ |_|   " -> Digit(6)
    " _   |  |   " -> Digit(7)
    " _ |_||_|   " -> Digit(8)
    " _ |_| _|   " -> Digit(9)
    " _ | ||_|   " -> Digit(0)
    _ -> Unknown
  }
}