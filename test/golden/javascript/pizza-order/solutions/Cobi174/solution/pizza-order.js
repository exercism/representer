/// <reference path="./global.d.ts" />
// @ts-check

const PIZZA_PRICES = {
  Margherita: 7,
  Caprese: 9,
  Formaggio: 10,
};

export function pizzaPrice(pizza, ...[extra, ...otherExtras]) {
  switch (extra) {
    case 'ExtraSauce': {
      return 1 + pizzaPrice(pizza, ...otherExtras);
    }
    case 'ExtraToppings': {
      return 2 + pizzaPrice(pizza, ...otherExtras);
    }
    default: {
      return PIZZA_PRICES[pizza];
    }
  }
}

export function orderPrice(pizzaOrders) {
  return pizzaOrders.reduce(
    (result, order) => result + pizzaPrice(order.pizza, ...order.extras),
    0
  );
}
