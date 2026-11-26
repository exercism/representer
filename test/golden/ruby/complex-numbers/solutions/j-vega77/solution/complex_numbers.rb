=begin
Write your code for the 'Complex Numbers' exercise in this file. Make the tests in
`complex_numbers_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/complex-numbers` directory.
=end

=begin
Write your code for the 'Complex Numbers' exercise in this file. Make the tests in
`complex_numbers_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/complex-numbers` directory.
=end

include Math

class ComplexNumber
  def ==(other)
    other.is_a?(ComplexNumber) &&
      @real_num.round(2) == other.real.round(2) &&
      @imaginary_num.round(2) == other.imaginary.round(2)
  end
  def initialize(real_num, imaginary_num = 0)
    @real_num = real_num
    @imaginary_num = imaginary_num
  end
  def real
    @real_num
  end
  def imaginary
    @imaginary_num
  end
  
  def *(other)
    if other.is_a?(ComplexNumber)
      a, b = @real_num, @imaginary_num
      c, d = other.real, other.imaginary
      real = a * c - b * d
      imag = b * c + a * d
      ComplexNumber.new(real, imag)
    else
      ComplexNumber.new(@real_num * other, @imaginary_num * other)
    end
  end

  def +(other)
    if other.is_a?(ComplexNumber)
      a, b = @real_num, @imaginary_num
      c, d = other.real, other.imaginary
      ComplexNumber.new(a + c, b + d)
    else
      ComplexNumber.new(@real_num + other, @imaginary_num)
    end
  end

  def -(other)
    if other.is_a?(ComplexNumber)
      a, b = @real_num, @imaginary_num
      c, d = other.real, other.imaginary
      ComplexNumber.new(a - c, b - d)
    else
      ComplexNumber.new(@real_num - other, @imaginary_num)
    end
  end

  def /(other)
    if other.is_a?(ComplexNumber)
      a, b = @real_num, @imaginary_num
      c, d = other.real, other.imaginary
      denom = c**2 + d**2
      real = (a * c + b * d) / denom.to_f
      imag = (b * c - a * d) / denom.to_f
      ComplexNumber.new(real, imag)
    else
      ComplexNumber.new(@real_num / other.to_f, @imaginary_num / other.to_f)
    end
  end

  def conjugate
    ComplexNumber.new(@real_num, -@imaginary_num)
  end

  def abs
    a, b = @real_num, @imaginary_num
    Math.sqrt(a ** 2 + b ** 2)
  end

  def exp
    a, b = @real_num, @imaginary_num
    real = Math.exp(a) * Math.cos(b)
    imag = Math.exp(a) * Math.sin(b)
    ComplexNumber.new(real, imag)
  end
end
