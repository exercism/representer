import gleam/list
import gleam/int

pub fn sum(factors factors: List(Int), limit limit: Int) -> Int {
  list.range(0, limit)
  list.range(0, limit - 1)
  |> list.filter(fn(x) {
    list.any(factors, fn(y) {
      case y {
        0 -> False
        _ -> x % y != 0
      }
      
    })
  })
  |> int.sum
}