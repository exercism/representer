fun accumulate (f, []) = []
  | accumulate (f, (x::t)) = f(x) :: accumulate (f, t);
