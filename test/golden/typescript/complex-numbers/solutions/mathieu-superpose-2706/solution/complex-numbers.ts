export class ComplexNumber {
  realPart: number;
  imagPart: number;

  constructor(real: number, imaginary: number) {
    this.realPart = real;
    this.imagPart = imaginary;
  }

  public get real(): number {
    return this.realPart;
  }

  public get imag(): number {
    return this.imagPart;
  }

  public add(other: ComplexNumber): ComplexNumber {
    const real = this.realPart + other.real;
    const imaginary = this.imagPart + other.imag;
    return new ComplexNumber(real, imaginary);
  }

  public sub(other: ComplexNumber): ComplexNumber {
    const real = this.realPart - other.real;
    const imaginary = this.imagPart - other.imag;
    return new ComplexNumber(real, imaginary);
  }

  public div(other: ComplexNumber): ComplexNumber {
    const real =
      (this.realPart * other.real + this.imagPart * other.imag) /
      (other.real ** 2 + other.imag ** 2);
    const imaginary =
      (this.imagPart * other.real - this.realPart * other.imag) /
      (other.real ** 2 + other.imag ** 2);
    return new ComplexNumber(real, imaginary);
  }

  public mul(other: ComplexNumber): ComplexNumber {
    const real = this.realPart * other.real - this.imagPart * other.imag;
    const imaginary = this.imagPart * other.real + this.realPart * other.imag;
    return new ComplexNumber(real, imaginary);
  }

  public get abs(): number {
    return Math.sqrt(this.realPart ** 2 + this.imagPart ** 2);
  }

  public get conj(): ComplexNumber {
    return new ComplexNumber(this.realPart, -1 * this.imagPart || 0);
  }

  public get exp(): ComplexNumber {
    const real = Math.exp(this.realPart) * Math.cos(this.imagPart);
    const imaginary = Math.exp(this.realPart) * Math.sin(this.imagPart);
    return new ComplexNumber(real, imaginary);
  }
}
