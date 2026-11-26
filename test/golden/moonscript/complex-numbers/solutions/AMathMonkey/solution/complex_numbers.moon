class ComplexNumber
  new: (real, imaginary) =>
    @_real = real
    @_imaginary = imaginary

  real: => @_real

  imaginary: => @_imaginary

  conjugate: => ComplexNumber @_real, -@_imaginary

  abs_sqr: => @_real * @_real + @_imaginary * @_imaginary
  abs: => math.sqrt @abs_sqr!

  exp: => 
    exp_real = math.exp @_real
    ComplexNumber exp_real * (math.cos @_imaginary), exp_real * math.sin @_imaginary

  __eq: (other) => (math.abs @_real - other._real) < 0.00001 and (math.abs @_imaginary - other._imaginary) < 0.00001

  __add: (other) => ComplexNumber @_real + other._real, @_imaginary + other._imaginary
  __sub: (other) => @ + ComplexNumber -other._real, -other._imaginary
  __mul: (other) => 
    ComplexNumber(
      @_real * other._real - @_imaginary * other._imaginary,
      @_imaginary * other._real + @_real * other._imaginary)
  __div: (other) =>
    other_abs_sqr = other\abs_sqr!
    @ * ComplexNumber other._real / other_abs_sqr, -other._imaginary / other_abs_sqr

coerce = (a) -> if (type a) == 'number' then ComplexNumber(a, 0) else a
  
add = (a, b) -> (coerce a) + coerce b
sub = (a, b) -> (coerce a) - coerce b
mul = (a, b) -> (coerce a) * coerce b
div = (a, b) -> (coerce a) / coerce b

{ :ComplexNumber, :add, :sub, :mul, :div }
