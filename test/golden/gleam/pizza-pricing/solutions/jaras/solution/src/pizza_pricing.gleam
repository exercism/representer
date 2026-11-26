// TODO: please define the Pizza custom type
pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

pub fn pizza_price(pizza: Pizza) -> Int {
  case pizza {
    ExtraSauce(p) -> 1 + pizza_price(p)
    ExtraToppings(p) -> 2 + pizza_price(p)
    Margherita -> 7
    Caprese -> 9
    Formaggio -> 10
  }
}

pub fn order_price(order: List(Pizza)) -> Int {
  case order {
    [] -> 0
    [p] -> 3 + pizza_price(p)
    [p1, p2] -> 2 + pizza_price(p1) + pizza_price(p2)
    _ -> order_price_elements(0, order)
  }
}

fn order_price_elements(acc: Int, order: List(Pizza)) {
  case order {
    [] -> acc
    [p, ..rest] -> {
      let acc = acc + pizza_price(p)
      order_price_elements(acc, rest)
    }
  }
}
