fun unwrapSides (sides: real list): (real * real * real) =
  (
    List.nth(sides, 0),
    List.nth(sides, 1),
    List.nth(sides, 2)
  )

fun hasZeroSides (a: real, b:real, c:real): bool =
  Real.== (a, 0.0) orelse
  Real.== (b, 0.0) orelse
  Real.== (c, 0.0)

fun hasTriangleInequality (a: real, b: real, c: real) : bool =
  not (
    Real.>=(a + b, c) andalso
    Real.>=(b + c, a) andalso
    Real.>=(a + c, b)
  )

fun equilateral (sides: real list): bool =
  let
    val (a, b, c) = unwrapSides sides
    val isEquilateral =
      Real.== (a, b) andalso 
      Real.== (b, c) andalso
      Real.== (a, c)
  in
    isEquilateral 
      andalso not (hasZeroSides(a, b, c))
  end

fun isosceles (sides: real list): bool =
  let
    val (a, b, c) = unwrapSides sides
    val isIsosceles = 
      Real.== (a, b) orelse
      Real.== (b, c) orelse 
      Real.== (a, c)  
  in
    isIsosceles  
      andalso not (hasTriangleInequality(a, b, c))
      andalso not (hasZeroSides(a, b, c))
  end

fun scalene (sides: real list): bool =
  let
    val (a, b, c) = unwrapSides sides
    val isScalene =
      Real.!= (a, b) andalso
      Real.!= (b, c) andalso
      Real.!= (a, c)
  in
    isScalene 
      andalso not (hasTriangleInequality(a, b, c))
      andalso not (hasZeroSides(a, b, c))
  end
