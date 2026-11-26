import gleam/list

pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

pub fn pizza_price(pizza: Pizza) -> Int {
  case pizza {
    Margherita -> 7
    Caprese -> 9
    Formaggio -> 10
    ExtraSauce(real_pizza) -> 1 + pizza_price(real_pizza)
    ExtraToppings(real_pizza) -> 2 + pizza_price(real_pizza)
  }
}

pub fn order_price(order: List(Pizza)) -> Int {
  case list.length(order) {
    1 -> 3
    2 -> 2
    _ -> 0
  } + order_price_in(order, 0)
}

fn order_price_in(order: List(Pizza), sum: Int) -> Int {
  case order {
    [] -> sum
    [first,  ..rest] -> order_price_in(rest, sum + pizza_price(first))
  }
}