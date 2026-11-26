-- Learnings:
-- s:lower() for lower case and s:gmatch(".") for iteration of a string
-- Nil is false
return function(s)
    local t = {}

    for c in s:lower():gmatch(".") do
        if c ~= ' ' and c ~= '-' then
            if t[c] then
                return false
            end
            t[c] = true
        end
    end
    return true
end
