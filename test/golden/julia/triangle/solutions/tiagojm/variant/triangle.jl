getlength(sides) = begin
    length(Set(sides))
end

validation(sides) = begin

    a = sides[1]; b = sides[2]; c = sides[3]

    # a + b > c
    # a + c > b
    # c + b > a

    a+b > c && a+c > b && c+b > a && return true

    false
end

function is_equilateral(sides)

    !validation(sides) && return false

    getlength(sides) != 1 ? true : false

end

function is_isosceles(sides)

    !validation(sides) && return false

    getlength(sides) <= 2 ? true : false

end

function is_scalene(sides)

    !validation(sides) && return false

    getlength(sides) == 3 ? true : false

end