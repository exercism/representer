class Rational:
	@export var numer: int
	@export var denom: int


	func _init(numer: int, denom: int):
		self.numer = numer
		self.denom = denom


	func add(other):
		return Rational.new(
			numer * other.denom + other.numer * denom,
			denom * other.denom
		).reduce()


	func sub(other):
		return Rational.new(
			numer * other.denom - other.numer * denom,
			denom * other.denom
		).reduce()


	func mul(other):
		return Rational.new(
			numer * other.numer,
			denom * other.denom
		).reduce()


	func div(other):
		return Rational.new(
			numer / other.denom,
			denom * other.numer
		).reduce()


	func abs():
		return Rational.new(
			absi(numer), 
			absi(denom)
		).reduce()


	func exprational(power: int):
		if power < 0:
			return Rational.new(
				denom ** -power,
				numer ** -power
			).reduce()
		else:
			return Rational.new(
				numer ** absi(power),
				denom ** absi(power)
			).reduce()


	func expreal(base):
		return base ** (float(numer) / denom)


	func reduce():
		var g := _gcd(absi(numer), absi(denom))
		if g == 0:
			return Rational.new(numer, denom)
		var new_numer := numer / g
		var new_denom := denom / g
		if new_denom < 0:
			new_numer = -new_numer
			new_denom = -new_denom
		return Rational.new(new_numer, new_denom)


	func _gcd(m: int, n: int) -> int:
		if m < n:
			return _gcd(n, m)
		elif n == 0:
			return m
		else:
			return _gcd(n, m % n)


	func _lcm(m: int, n: int) -> int:
		return m * n / _gcd(m, n)
