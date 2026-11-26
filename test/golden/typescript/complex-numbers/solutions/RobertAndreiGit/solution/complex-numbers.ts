export class ComplexNumber {
  private realNum: number
  private imagNum: number
  
  constructor(real: number, imaginary: number) {
    this.realNum = real
    this.imagNum = imaginary
  }

  public get real(): number {
    return this.realNum
  }

  public get imag(): number {
    return this.imagNum
  }

  public add(other: ComplexNumber): ComplexNumber {
    return new ComplexNumber(other.real + this.real, other.imag + this.imag)
  }

  public sub(other: ComplexNumber): ComplexNumber {
    return new ComplexNumber(this.real - other.real, this.imag - other.imag)
  }

  public div(other: ComplexNumber): ComplexNumber {
    const [a, b, c, d] = [this.real, this.imag, other.real, other.imag]
    
    return new ComplexNumber((a * c + b * d) / (c * c + d * d), (b * c - a * d) / (c * c + d * d))
  }

  public mul(other: ComplexNumber): ComplexNumber {
    const [a, b, c, d] = [this.real, this.imag, other.real, other.imag]
    
    return new ComplexNumber(a * c - b * d, b * c + a * d)
  }

  public get abs(): number {
    return Math.sqrt(this.real * this.real + this.imag * this.imag)
  }

  public get conj(): ComplexNumber {
    return new ComplexNumber(this.real, this.imag !== 0 ? this.imag * (-1) : 0)
  }

  public get exp(): ComplexNumber {
    const [a, b] = [this.real , this.imag]
    return new ComplexNumber(Math.exp(a) * Math.cos(b), Math.exp(a) * Math.sin(b))
  }
}
