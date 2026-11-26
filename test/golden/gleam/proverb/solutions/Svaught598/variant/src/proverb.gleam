import gleam/bool
import gleam/list
import gleam/string

pub fn recite(inputs: List(String)) -> String {
  use <- bool.guard(list.is_empty(inputs), return: "")
  let assert [first, ..] = inputs
  let recite = fn(p: #(String, String)) {"For want of a " <> p.0 <> " the " <> p.2 <> " was lost."}
  inputs
  |> list.window_by_2()
  |> list.map(recite)
  |> list.append(["And all for the want of a " <> first <> "."])
  |> string.join("\n")
}
