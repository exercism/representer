include std/math.e

constant ALLERGENS = {
  "eggs",
  "peanuts",
  "shellfish",
  "strawberries",
  "tomatoes",
  "chocolate",
  "pollen",
  "cats"
}

public function allergicTo(sequence allergen, integer score)
  return and_bits(score, shift_bits(1, -find(allergen, ALLERGENS) + 1))
end function

public function list(integer score)
  sequence result = {}
  for i = 1 to length(ALLERGENS) do
    if and_bits(score, shift_bits(1, -i + 1)) then
      result = append(result, ALLERGENS[i])
    end if
  end for
  return result
end function
