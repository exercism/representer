constant ALLERGENS = {"eggs", "peanuts", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"}

-- returns a true/false value
public function allergicTo(sequence allergen, integer score)
    integer index = find(allergen, ALLERGENS)
    if index = 0 then
        return 0
    else
        return remainder(floor(score / power(2, index - 1)), 2)
    end if
end function

-- returns a sequence of strings
public function list(integer score)
    sequence result = {}
    for i = 1 to length(ALLERGENS) do
        if remainder(floor(score / power(2, i - 1)), 2) = 1 then
            result = append(result, ALLERGENS[i])
        end if
    end for
    return result
end function
