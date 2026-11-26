public function pythagorean_triplets(integer perim)
  sequence acc = {}
  for c = floor(perim / 2) to 1 by -1 do
    for b = c - 1 to floor(c / 2) by -1 do
      integer a = perim - c - b
      if a <= b and c * c = a * a + b * b then
        acc = append(acc, { a, b, c })
      end if
    end for
  end for
  return acc
end function
