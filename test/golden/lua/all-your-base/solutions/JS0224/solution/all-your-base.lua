all_your_base = {}

all_your_base.convert = function(from_digits, from_base)
    length = #from_digits
    result = from_digits[1] or 0
        
    if from_base < 2 then error('invalid input base') end
    
    for idx=2, length, 1 do
        if from_digits[idx] < 0 then
            error('negative digits are not allowed')
        elseif from_digits[idx] >= from_base then
            error('digit out of range')
        end
        result = result * from_base + from_digits[idx] 
    end
    
    interface = {}
    interface.to = function(to_base)
        if to_base < 2 then error('invalid output base') end
        t = {}
        a = result
        while (a ~= 0) do
            table.insert(t, 1, a % to_base)
            a = a // to_base
        end

        if #t == 0 then return {0} end
        return t 
    end
    
    return interface
end

return all_your_base
