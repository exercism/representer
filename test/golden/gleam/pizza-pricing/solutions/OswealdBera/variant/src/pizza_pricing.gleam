import gleam/list

pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

pub fn pizza_price(pizza: Pizza) -> Int {
  calculate_pizza_price(pizza, 0)
}

fn calculate_pizza_fee(pizzas: List(Pizza)) -> Int {
  case pizzas {
    [_] -> 3
    [_, _] -> 2
    _ -> 0
  }
}

fn calculate_pizza_price(pizza: Pizza, fee: Int) -> Int {
  case pizza {
    Margherita -> 7 + fee
    Caprese -> 9 + fee
    Formaggio -> 10 - fee
    ExtraSauce(p) -> calculate_pizza_price(p, 1 + fee)
    ExtraToppings(p) -> calculate_pizza_price(p, 2 + fee)
  }
}

pub fn order_price(order: List(Pizza)) -> Int {
  calculate_order_price(order, 0, calculate_pizza_fee(order))
}

fn calculate_order_price(pizzas: List(Pizza), price: Int, pizza_fee: Int) -> Int {
  case pizzas {
    [] -> price + pizza_fee
    [pizza, ..rest] -> calculate_order_price(rest, price + pizza_price(pizza), pizza_fee)
  }
}

