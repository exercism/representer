local PopCount = {}

function PopCount.egg_count(number)
    eggs = 0
    highestBase2 = 2^math.floor(math.log(number) / math.log(2))
    while(number > 0) do
        if highestBase2 <= number then
            number = number - highestBase2
            eggs = eggs + 1
        end
        highestBase2 = highestBase2 / 2
    end
    return eggs
end

return PopCount

