fun score (x: real, y: real): int =
  let val p = x * x + y * y
  in
    if p <= 2.0 then
      10
    else if p <= 25.0 then
      5
    else if p <= 100.0 then
      1
    else
      0
  end