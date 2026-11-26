package rational_numbers

import "core:math"

Rational :: struct {
    numerator: int,
    denominator: int,   
    // Note: a denominator of 0 is not defined. Use at your own risk.
}

abs :: proc(a: Rational) -> Rational {
    a := reduce(a)
	return Rational{math.abs(a.numerator), a.denominator}
}

add :: proc(a: Rational, b: Rational) -> Rational {
	return reduce(Rational{
        a.numerator * b.denominator + b.numerator * a.denominator, 
        a.denominator * b.denominator,
    })
}

div :: proc(a: Rational, b: Rational) -> Rational {    
	return mul(a, _multiplicative_inverse(b))
}

exprational :: proc(r: Rational, power: int) -> Rational {	
    r, power := r, power
    if power < 0 {
        power = -power
        r = _multiplicative_inverse(r)
    }
    r = reduce(r)

	return Rational{_pow_int(r.numerator, power), _pow_int(r.denominator, power)}
}

expreal :: proc(x: f64, a: Rational) -> f64 {
	return math.pow(x, _f64(a))
}

mul :: proc(a: Rational, b: Rational) -> Rational {
	return reduce(Rational{
        a.numerator * b.numerator, 
        a.denominator * b.denominator,
    })
}

reduce :: proc(r: Rational) -> Rational {
    gcd := math.gcd(r.numerator, r.denominator)
    sign := 1 if r.denominator >= 0 else -1
    return Rational{
        sign * r.numerator / gcd, 
        sign * r.denominator / gcd
    }
}

sub :: proc(a: Rational, b: Rational) -> Rational {
	return add(a, _additive_inverse(b))
}
    
_additive_inverse :: proc(r: Rational) -> Rational {
    return Rational{-r.numerator, r.denominator}
}

_f64 :: proc(r: Rational) -> f64 {
    return f64(r.numerator) / f64(r.denominator)
}
    
_multiplicative_inverse :: proc(r: Rational) -> Rational {
    assert(r.numerator != 0, "Cannot divide by zero")
    return Rational{r.denominator, r.numerator}
}

_pow_int :: proc(base, exp: int) -> int {
    res := 1
    b := base
    e := exp
    for e > 0 {
        if e % 2 == 1 do res *= b
        b *= b
        e /= 2
    }
    return res
}
