pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

fn calc_pizza_price(acc: Int, pizza: Pizza) -> Int {
  case pizza {
    Margherita -> 7 + acc
    Caprese -> 9 + acc
    Formaggio -> 10 + acc
    ExtraSauce(p) -> calc_pizza_price(acc + 1, p)
    ExtraToppings(p) -> calc_pizza_price(acc + 2, p)
  }    
}

pub fn pizza_price(pizza: Pizza) -> Int {
  calc_pizza_price(0, pizza)
}

fn calc_order_price(acc: Int, count: Int, order: List(Pizza)) -> Int {
  case order {
    [] -> {
      acc + case count {
        1 -> 3
        2 -> 2
        _ -> 0
      }
    }
    [first, ..rest] -> {
      calc_order_price(
        acc + pizza_price(first), 
        count + 1, 
        rest)
    }
  }
}

pub fn order_price(order: List(Pizza)) -> Int {
  calc_order_price(0, 0, order)
}
