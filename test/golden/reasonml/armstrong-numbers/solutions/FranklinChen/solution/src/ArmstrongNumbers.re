let pow = (base, exp) => {
  let rec loop = (result, base, exp) =>
    exp === 0
    ? result
    : exp mod 2 === 1
    ? loop(result * base, base * base, exp / 2)
    : loop(result, base * base, exp / 2);
  loop(1, base, exp);
};

let validate = (number) => {
  if (number === 0) {
    true;
  } else {
    let numDigits = int_of_float(log10(float_of_int(number))) + 1;
    let rec sumPowers = (n, sum) =>
      n === 0
      ? sum === number
      : {
          let digit = n mod 10;
          let newSum = sum + pow(digit, numDigits);
          if (newSum > number) {
            false;
          } else {
            sumPowers(n / 10, newSum);
          }
        };
    sumPowers(number, 0);
  }
};