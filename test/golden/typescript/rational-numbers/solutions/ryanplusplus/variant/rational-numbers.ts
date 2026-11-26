const gcd = (a: number, b: number): number =>
  (b === 0) ? Math.abs(a) : gcd(b, a % b);

export class Rational {
  numerator: number;
  denominator: number;

  constructor(numerator: number, denominator: number) {
    if(numerator === 0) {
      this.numerator = 0;
      this.denominator = 1;
    }
    else {
      const _gcd = gcd(numerator, denominator);
      this.numerator = numerator / _gcd;
      this.denominator = denominator / _gcd;

      if(this.denominator < 0) {
        this.numerator *= -1;
        this.denominator *= -1;
      }
    }
  }

  add(other: Rational): Rational {
    return new Rational(
      this.numerator * other.denominator + other.numerator * this.denominator,
      this.denominator * other.denominator
    );
  }

  sub(other: Rational): Rational {
    return new Rational(
      this.numerator * other.denominator - other.numerator / this.denominator,
      this.denominator * other.denominator
    );
  }

  mul(other: Rational): Rational {
    return new Rational(
      this.numerator * other.numerator,
      this.denominator * other.denominator
    );
  }

  div(other: Rational): Rational {
    return this.mul(new Rational(other.denominator, other.numerator));
  }

  abs(): Rational {
    if(this.numerator < 0) {
      return new Rational(-this.numerator, this.denominator);
    }
    else {
      return this;
    }
  }

  exprational(n: number): Rational {
    if(n < 0) {
      return new Rational(
        Math.pow(this.denominator, -n),
        Math.pow(this.numerator, -n)
      );
    }
    else {
      return new Rational(
        Math.pow(this.numerator, n),
        Math.pow(this.denominator, n)
      );
    }
  }

  expreal(n: number): number {
    return Math.pow(n, (this.numerator / this.denominator));
  }

  reduce(): Rational {
    return this;
  }
}
