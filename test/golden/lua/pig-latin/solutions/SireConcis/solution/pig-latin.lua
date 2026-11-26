local function piglatin(str)
    if str:find(' ') ~= nil then
        return piglatin(str:sub(1, str:find(' ')-1)) .. ' ' .. piglatin(str:sub(str:find(' ')+1, #str))
    end
    if str:find('[^aeiou]') == 1 then
        if (str:sub(1, 1) == 'x' or str:sub(1, 1) == 'y') and str:find('[aeiou]') == 2 then
            return str:sub(2) .. str:sub(1, 1) .. 'ay'
        elseif (str:sub(1, 1) == 'x' or str:sub(1, 1) == 'y') and str:find('[^aeiouy]', 2) == 2 then
            return str .. 'ay'
        elseif str:find('qu') == 1 or str:find('qu') == 2 then
            return str:sub(str:find('qu') + 2) .. str:sub(1, str:find('qu') + 1) .. 'ay'
        else
            return str:sub(str:find('[aeiouy]'), #str) .. str:sub(1, str:find('[aeiouy]') - 1) .. 'ay'
        end
    else return str .. 'ay'
    end
end
return piglatin