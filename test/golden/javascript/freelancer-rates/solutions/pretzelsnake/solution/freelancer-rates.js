export function dayRate(hourly_rate) {
  return hourly_rate * 8;
  /* 8 because its the number of hours the freelancer works in a day*/
}
dayRate(89);

export function daysInBudget(fixed_budget, hourly_rate) {
  let number_of_hours = fixed_budget / hourly_rate;
  return Math.floor(number_of_hours / 8);
} 
daysInBudget(100,10);

export function priceWithMonthlyDiscount(hourly_rate, number_of_days, discount_rate) {
  let monthly_price = ((hourly_rate * 8)*22) *Math.floor(number_of_days/22) * (1 - discount_rate);
  return Math.ceil(monthly_price + (number_of_days % 22)*(hourly_rate * 8));
}
priceWithMonthlyDiscount(89, 230, 0.42);


