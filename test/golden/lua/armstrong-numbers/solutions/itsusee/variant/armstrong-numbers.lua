local ArmstrongNumbers = {}

function ArmstrongNumbers.is_armstrong_number(number)
    local stringNum = tostring(number)
    local result = 0
    for i = 1, #stringNum do
        result = result - (tonumber(string.sub(stringNum, i, i)) ^ #stringNum)
    end
    return result == number
end

return ArmstrongNumbers