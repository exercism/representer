export function triplets({ minFactor = 0, maxFactor, sum }) {
  let values = []
  for (let a = 1; a <= sum / 3; a++) {
    for (let b = a + 1, c = sum - a - b; b < c; b++, c--) {
      if (a * a + b * b == c * c) values.push(new Triplet(a, b, c))
    }
  }
  
  if (!maxFactor) maxFactor = sum
  return values.filter(x => x.a >= minFactor && x.c <= maxFactor)
}

class Triplet {
  constructor(a, b, c) {
    this.a = a
    this.b = b
    this.c = c
  }

  toArray() {
    return [this.a, this.b, this.c]
  }
}
