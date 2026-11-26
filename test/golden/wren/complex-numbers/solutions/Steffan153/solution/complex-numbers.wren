class ComplexNumber {
  construct new(real, imaginary) {
    _r = real
    _i = imaginary
  }

  real { _r }
  imag { _i }

  r { _r }
  i { _i }

  ==(o) { _r == o.r && _i == o.i }

  +(o) {
    if (o is Num) return ComplexNumber.new(_r + o, _i)
    return ComplexNumber.new(_r + o.r, _i + o.i)
  }

  -(o) {
    if (o is Num) return ComplexNumber.new(_r - o, _i)
    return ComplexNumber.new(_r - o.r, _i - o.i)
  }

  *(o) {
    if (o is Num) return ComplexNumber.new(_r * o, _i * o)
    return ComplexNumber.new(_r * o.r - _i * o.i, _i * o.r + _r * o.i)
  }

  /(o) {
    if (o is Num) return this / ComplexNumber.new(o, 0)
    return ComplexNumber.new((_r * o.r + _i * o.i) / (o.r*o.r + o.i*o.i),
                             (_i * o.r - _r * o.i) / (o.r*o.r + o.i*o.i))
  }

  abs { (_r * _r + _i * _i).sqrt }

  conj { ComplexNumber.new(_r, -_i) }

  exp { ComplexNumber.new(_i.cos, _i.sin) * _r.exp }

  toString { "%(_r)+%(_i)i"}
}
