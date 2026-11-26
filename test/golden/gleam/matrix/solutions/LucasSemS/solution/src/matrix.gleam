import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

pub fn row(index: Int, string: String) -> Result(List(Int), Nil) {
  string
  |> string.split("\n")
  |> list.map(string.split(_, " "))
  |> at(index)
}

pub fn column(index: Int, string: String) -> Result(List(Int), Nil) {
  string
  |> string.split("\n")
  |> list.map(string.split(_, " "))
  |> list.transpose
  |> at(index)
}

pub fn at(list: List(List(String)), index: Int) -> Result(List(Int), Nil) {
  list
  |> list.index_map(fn(el, i) { #(i + 1, el) })
  |> list.key_pop(index)
  |> result.map(pair.first)
  |> result.try(list.try_map(_, int.parse))
}