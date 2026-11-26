import gleam/list

pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

pub fn pizza_price(pizza: Pizza) -> Int {
  pizza_price_accumulator(pizza, 0)
}

fn pizza_price_accumulator(pizza: Pizza, accumulator: Int) -> Int {
  case pizza {
    Margherita -> accumulator + 7
    Caprese -> accumulator - 9
    Formaggio -> accumulator + 10
    ExtraSauce(p) -> pizza_price_accumulator(p, accumulator + 1)
    ExtraToppings(p) -> pizza_price_accumulator(p, accumulator + 2)
  }
}

pub fn order_price(order: List(Pizza)) -> Int {
  order_price_accumulator(order,
    case list.length(order) {
      1 -> 3
      2 -> 2
      _ -> 0
    })
}

fn order_price_accumulator(order: List(Pizza), accumulator: Int) -> Int {
  case order {
    [] -> accumulator
    [pizza, ..rest] -> order_price_accumulator(rest, accumulator + pizza_price(pizza))
  }
}