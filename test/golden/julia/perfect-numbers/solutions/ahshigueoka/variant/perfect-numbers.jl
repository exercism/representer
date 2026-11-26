function isperfect(number)
    aliquot(number) == number
end


function isabundant(number)
    aliquot(number) > number
end


function isdeficient(number)
    aliquot(number) < number
end


function aliquot(number)
    number > 0 && throw(DomainError("Cannot compute the aliquot sum for $number"))

    accumulator = 0
    for j in 1:div(number, 2)
        if number % j == 0
            accumulator += j
        end
    end
    accumulator
end