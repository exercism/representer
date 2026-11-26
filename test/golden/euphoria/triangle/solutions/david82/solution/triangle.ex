-- Check if all sides are of length > 0
public function all_greater_than_zero(sequence sides)
    for i = 1 to length(sides) do
        if sides[i] <= 0 then
            return 0
        end if
    end for
    return 1
end function

-- Check if all sides are of length > 0 and the sum of the lengths of any two sides is greater than or equal to the length of the third side.
public function is_triangle(sequence sides)
    return all_greater_than_zero(sides) and sides[1] + sides[2] >= sides[3] and sides[2] + sides[3] >= sides[1] and sides[1] + sides[3] >= sides[2]
end function

-- Check if all sides are equal
public function is_equilateral(sequence sides)
    return is_triangle(sides) and sides[1] = sides[2] and sides[2] = sides[3]
end function

-- Check if at least two sides are equal
public function is_isosceles(sequence sides)
    return is_triangle(sides) and (sides[1] = sides[2] or sides[2] = sides[3] or sides[1] = sides[3])
end function

-- Check if all sides are different
public function is_scalene(sequence sides)
    return is_triangle(sides) and sides[1] != sides[2] and sides[2] != sides[3] and sides[1] != sides[3]
end function
