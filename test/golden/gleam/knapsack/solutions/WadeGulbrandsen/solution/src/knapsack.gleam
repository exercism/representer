import gleam/int

pub type Item {
  Item(value: Int, weight: Int)
}

pub fn maximum_value(items: List(Item), maximum_weight: Int) -> Int {
  knapsack(0, items, maximum_weight)
}

fn knapsack(value: Int, items: List(Item), maximum_weight: Int) -> Int {
  case items {
    [] -> value
    [x, ..rest] if x.weight > maximum_weight ->
      knapsack(value, rest, maximum_weight)
    [x, ..rest] ->
      int.max(
        knapsack(value, rest, maximum_weight),
        knapsack(value + x.value, rest, maximum_weight - x.weight),
      )
  }
}
