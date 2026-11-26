-- local str = "abcd"
-- for i = 1, #str do
--     local c = str:sub(i, i)
--     -- Do something with 'c'
-- end

return function(s)
    local char_count = {}
    for i = 1, #s do
        local c = string.lower(s:sub(i, i))
        ---print(c)
        local trivial = c == " " or c == "-"
        if not trivial then
            ---print("went into char count")
            if char_count[c] then
                return false
            else
                ---print("went into iniitalize char count")
                char_count[c] = 1
            end
        end
    end
    return true
end
