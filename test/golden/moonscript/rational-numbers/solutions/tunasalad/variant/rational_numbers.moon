local *

gcd = (a, b) ->
  while b != 0
    a, b = b, a % b
  a

reduce = (r) ->
  {a, b} = r
  if b <= 0
    a, b = -a, -b
  g = gcd math.abs(a), b
  {a // g, b // g}

add = (r1, r2) ->
  {a, b} = r1
  {c, d} = r2
  reduce {a * d + b * c, b * d}

sub = (r1, r2) ->
  {a, b} = r1
  {c, d} = r2
  reduce {a * d - b * c, b * d}

mul = (r1, r2) ->
  {a, b} = r1
  {c, d} = r2
  reduce {a * c, b * d}

div = (r1, r2) ->
  {a, b} = r1
  {c, d} = r2
  reduce {a * d, b * c}

abs = (r) ->
  {a, b} = r
  reduce {math.abs(a), math.abs(b)}

exprational = (r, n) ->
  if n == 0
    {1, 1}
  elseif n < 0
    {a, b} = r
    r = reduce {b, a}
    exprational r, -n
  else
    with t = exprational r, n // 2
      t = mul t, t
      if n % 2 == 1
        t = mul t, r

expreal = (x, r) ->
  {a, b} = r
  x ^ (a / b)

{ :reduce, :add, :sub, :mul, :div, :abs, :exprational, :expreal }
