import gleam/int
import gleam/list

pub fn combinations(
  size size: Int,
  sum sum: Int,
  exclude exclude: List(Int),
) -> List(List(Int)) {
  list.range(1, 9)
  |> list.filter(fn(n) { !list.contains(exclude, n) })
  |> list.combinations(size)
  |> list.filter(fn(numbers) { int.sum(numbers) == sum })
}
