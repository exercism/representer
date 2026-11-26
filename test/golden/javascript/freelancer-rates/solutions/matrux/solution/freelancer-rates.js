// @ts-check
//
// ☝🏽 The line above enables type checking for this file. Various IDEs interpret
// the @ts-check directive. It will give you helpful autocompletion on the web
// and supported IDEs when implementing this exercise. You don't need to
// understand types, JSDoc, or TypeScript in order to complete this JavaScript
// exercise, and can completely ignore this comment block and directive.

// 👋🏽 Hi again!
//
// A quick reminder about exercise stubs:
//
// 💡 You're allowed to completely clear any stub before you get started. Often
// we recommend using the stub, because they are already set-up correctly to
// work with the tests, which you can find in ./freelancer-rates.spec.js.
//
// 💡 You don't need to write JSDoc comment blocks yourself; it is not expected
// in idiomatic JavaScript, but some companies and style-guides do enforce them.
//
// Get those rates calculated!

/**
 * The day rate, given a rate per hour
 *
 * @param {number} ratePerHour
 * @returns {number} the rate per day
 */
let ore = 8
let ratePerHour = 89
export function dayRate(ratePerHour) {
  let tariffa = ratePerHour * ore;
  return tariffa;
}

console.log(dayRate(ratePerHour));

/**
 * Calculates the number of days in a budget, rounded down
 *
 * @param {number} budget: the total budget
 * @param {number} ratePerHour: the rate per hour
 * @returns {number} the number of days
 */
let budget = 20000 
export function daysInBudget(budget, ratePerHour) {
  let tariffa = ratePerHour * ore;
  let giorniLavoro = Math.floor(budget/tariffa);
  return giorniLavoro;
}

console.log(daysInBudget(budget, ratePerHour));

/**
 * Calculates the discounted rate for large projects, rounded up
 *
 * @param {number} ratePerHour
 * @param {number} numDays: number of days the project spans
 * @param {number} discount: for example 20% written as 0.2
 * @returns {number} the rounded up discounted rate
 */
let numDays = 230
let discount = 0.42
export function priceWithMonthlyDiscount(ratePerHour, numDays, discount) {
  let giorniNonFatturabili = numDays % 22;
  let giorniFatturabili = numDays - giorniNonFatturabili;
  let tariffa = (ratePerHour * ore);
  let scontoDaApplicare = 1 - discount;
  let tariffaScontata = Math.ceil((giorniFatturabili * tariffa) * scontoDaApplicare);
  let tariffaNonScontata = Math.ceil(tariffa * giorniNonFatturabili);
  let result = tariffaScontata + tariffaNonScontata;
  return result;
}

console.log(priceWithMonthlyDiscount(ratePerHour, numDays, discount));
