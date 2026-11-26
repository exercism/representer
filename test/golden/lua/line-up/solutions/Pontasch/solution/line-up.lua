return {
    format = function(name, number)
        number = tostring(number)
        local ending = ""
        if string.sub(number, -1) == "1" and string.sub(number, -2) ~= "11" then
            ending = "st"
        elseif string.sub(number, -1) == "2" and string.sub(number, -2) ~= "12" then
            ending = "nd"
        elseif string.sub(number, -1) == "3" and string.sub(number, -2) ~= "13" then
            ending = "rd"
        else
            ending = "th"
        end
        return string.format("%s, you are the %s customer we serve today. Thank you!", name, number .. ending)
    end
}
