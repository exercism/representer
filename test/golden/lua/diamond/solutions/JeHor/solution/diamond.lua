return function(which)
    if which == "A" then return "A\n" end
    
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local result = {}

    local index = string.find(alphabet, which)

    for i=1, index do
        line = ""
        
        for j=1, index-i do
            line = line .. " "
        end
        
        line = line .. string.sub(alphabet, i, i)

        if i > 1 then
            for j=1, (i-1)*2-1 do
                line = line .. " "
            end

            line = line .. string.sub(alphabet, i, i)
        end

        for j=1, index-i do
            line = line .. " "
        end

        table.insert(result, line)
    end
    
    for i=index-1, 1, -1 do
        line = ""
        
        for j=1, index-i do
            line = line .. " "
        end
        
        line = line .. string.sub(alphabet, i, i)

        if i > 1 then
            for j=1, (i-1)*2-1 do
                line = line .. " "
            end

            line = line .. string.sub(alphabet, i, i)
        end

        for j=1, index-i do
            line = line .. " "
        end

        table.insert(result, line)
    end

    table.insert(result, "")
    return table.concat(result, "\n")
end


