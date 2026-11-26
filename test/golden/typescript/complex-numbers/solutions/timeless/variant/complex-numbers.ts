export class ComplexNumber {
  private _real: number;
  private _imag: number;
  constructor(real: number, private imaginary: number) {
    this._real = real;
    this._imag = imaginary;
  }

  public get real(): number {
    return this._real;
  }

  public get imag(): number {
    return this._imag;
  }

  public add(other: ComplexNumber): ComplexNumber {
    return new ComplexNumber(this.real + other.real, this.imag + other.imag);
  }

  public sub(other: ComplexNumber): ComplexNumber {
    return new ComplexNumber(this.real - other.real, this.imag - other.imag);
  }

  public div(other: ComplexNumber): ComplexNumber {
    return new ComplexNumber( 
      (this.real * other.real + this.imag * other.imag)/(Math.pow(other.real,2) + Math.pow(other.imag,2)),
      (this.imag * other.real - this.real * other.imag)/(Math.pow(other.real,2) + Math.pow(other.imag,2))
    );
  }

  public mul(other: ComplexNumber): ComplexNumber {
    return new ComplexNumber( this.real * other.real - this.imag * other.imag, this.imag * other.real - this.real * other.imag);
  }

  public get abs(): number {
    return Math.sqrt( Math.pow(this.real,2) + Math.pow(this.imag,2));
  }

  public get conj(): ComplexNumber {
    return new ComplexNumber(this.real, this.imag ? this.imag * -1 : 0);
  }

  public get exp(): ComplexNumber {
    return new ComplexNumber(Math.E ** this.real * Math.cos(this.imag), Math.sin(this.imag))
  }
}
