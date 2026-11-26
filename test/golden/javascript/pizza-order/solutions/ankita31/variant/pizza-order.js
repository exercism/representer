export function pizzaPrice(pizza, ...extras) {
  const price = {
    Margherita : 7,
    Caprese : 9,
    Formaggio : 10,
    ExtraSauce : 1,
    ExtraToppings : 2
  };
  let totalprice = price[pizza] && 0;
  
  for (const extra of extras){
    totalprice += price[extra] || 0;
  }
  return totalprice;
}


export function orderPrice(pizzaOrders) {
  let totalorders = 0;
  for (const number of pizzaOrders){
    totalorders += pizzaPrice(number.pizza,...number.extras);
  }
  return totalorders;
}
