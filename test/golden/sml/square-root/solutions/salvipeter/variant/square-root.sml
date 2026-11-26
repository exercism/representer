fun squareRoot (radicand: int): int =
  let fun f x =
    if x * x <= radicand andalso (x + 2) * (x + 1) > radicand
    then x
    else f (x div 2 + radicand div (2 * x))
  in f 1 end
