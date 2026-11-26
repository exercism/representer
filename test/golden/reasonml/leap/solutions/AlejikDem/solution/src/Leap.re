let isDivisibleBy = (a, b) => b mod a === 0;

let isLeapYear =
  fun
  | year when isDivisibleBy(400, year) => true
  | year when isDivisibleBy(100, year) => false
  | year when isDivisibleBy(4, year) => true
  | _ => false;