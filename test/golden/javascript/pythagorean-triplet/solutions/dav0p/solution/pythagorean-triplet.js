

export function triplets({ minFactor, maxFactor, sum }) {
  return termsOfTriplet(sum, minFactor, maxFactor).map(abc => new Triplet(abc));
}


function isPythagorean(a, b, c) {
  return a**2 + b**2 === c**2;
}


// this class is useless but the tests required it
class Triplet {
  constructor(abc) {
    this.abc = abc;
  }

  toArray() {
    return this.abc;
  }
}


function termsOfTriplet(sum, minFactor = 1, maxFactor) {
  const terms = [];

  for (let a = minFactor; a < sum / 3; a++) {
    const b = (sum * (sum - 2 * a)) / (2 * (sum - a));
    const c = sum - a - b;

    if (isInt(a) && isInt(b) && a < b && c <= (maxFactor || c) && isPythagorean(a, b, c))
      terms.push([a, b, c]);
  }

  return terms;
}


function isInt(n) {
  return n % 1 === 0;
}
