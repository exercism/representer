include std/math.e
include std/utils.e
include std/text.e

public function raindrops( atom n )
  sequence s = iif(mod(n, 3) = 0, "Pling", "") & iif(mod(n, 5) = 0, "Plang", "") & iif(mod(n, 7) = 0, "Plong", "")
  return iif(equal(s, ""), sprint(n), s)
end function
