import scala.math._

class ComplexNumber(val real: Double = 0, val imaginary: Double = 0) {

  def +(that: ComplexNumber): ComplexNumber = new ComplexNumber(real + that.real, imaginary + that.imaginary)

  def -(that: ComplexNumber): ComplexNumber = new ComplexNumber(real - that.real, imaginary - that.imaginary)

  def *(that: ComplexNumber): ComplexNumber = {
    val _r = this.real * that.real - this.imaginary * that.imaginary
    val _i = this.real * that.imaginary + that.real * this.imaginary

    new ComplexNumber(_r, _i)
  }

  def /(that: ComplexNumber): ComplexNumber = {

    val _r = (this.real * that.real + this.imaginary * that.imaginary) /
      (that.real * that.real + that.imaginary *that.imaginary)

    val _i = (that.real * this.imaginary - this.real * that.imaginary) /
      (that.real *that.real + that.imaginary * that.imaginary)

    new ComplexNumber(_r, _i)
  }

  def abs: Double = sqrt(pow(real, 2) + pow(imaginary, 2))

  def conjugate: ComplexNumber = ComplexNumber(real, imaginary * -1)

  private def exp: ComplexNumber = {

    ComplexNumber(real = Math.pow(Math.E, real)) *
      ComplexNumber(real = Math.cos(imaginary), imaginary = Math.sin(imaginary))
  }

  override def toString: String = {
    var str: String = ""

    val realPart = real
    val imgPart = imaginary

    if (realPart == 0 && imgPart == 0) return "0"
    if (realPart != 0) str = realPart + ""

    if (imgPart <= 0) str += imgPart + "i"
    else {
      if (imgPart > 0) str += "+" + imgPart + "i"
    }

    str
  }

}

object ComplexNumber {
  def apply(real: Double = 0, imaginary: Double = 0): ComplexNumber = new ComplexNumber(real, imaginary)
  def exp(complexNumber: ComplexNumber): ComplexNumber = complexNumber.exp
}
